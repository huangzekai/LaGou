//
//  KNFlowView.m
//  KNFlowView
//  可重用规则网格视图
//  Created by huangzekai on 14-12-1.
//  Copyright (c) 2014年 kennyHuang. All rights reserved.
//

/**
 *  步骤：
 *      1、读取cell总数目(numberOfCellsInFlowView)
 *      2、缓存cell高度信息
 *      2、读取每个cell(cellForViewAtIndex)
 *      3、将cell添加到flowView上面时调用(willDisplayCell)
 *      4、将cell放入重用队列中时调用(didEndDisplayCell)
 */

#import "KNFlowView.h"

@interface KNFlowView ()<UIScrollViewDelegate>
{
    ///行高度
    CGFloat _rowHeight;
    ///列宽度
    CGFloat _columnWidth;
    ///可见视图范围
    NSRange _visiableRange;
    ///选中单元格下标
    NSInteger _selectedIndex;
    ///结构体类型
    const char *_infoType;
    
    ///单元格信息
    struct cellInfo
    {
        ///y轴坐标
        CGFloat cellOffestY;
        ///x轴坐标
        CGFloat cellOffestX;
        ///索引
        NSInteger cellIndex;
    };
}
///单元格总数
@property (nonatomic) NSInteger numberOfCellCount;
///屏幕可见视图(key值为cell索引)
@property (nonatomic, readonly) NSMutableDictionary *visibleCells;
///重用视图集合
@property (nonatomic, readonly) NSMutableSet *reusableCells;
///缓存视图信息
@property (nonatomic, readonly) NSMutableArray *cellInfosArray;

@end

///记录上次滑动的y轴
static CGFloat perOffestY = 0.0;

@implementation KNFlowView
@synthesize visibleCells  = _visibleCells;
@synthesize reusableCells = _reusableCells;
@synthesize cellWidth     = _cellWidth;
@synthesize cellInfosArray = _cellInfosArray;

#pragma mark - 属性

///当前可见视图
- (NSMutableDictionary *)visibleCells
{
    if (!_visibleCells)
    {
        _visibleCells = [NSMutableDictionary dictionary];
    }
    return _visibleCells;
}

///单元格宽度
- (CGFloat)cellWidth
{
    if (_cellWidth == 0.0 && self.numberOfColumn)
    {
        _cellWidth = (CGRectGetWidth(self.bounds) - self.cellSpace) / self.numberOfColumn - self.cellSpace;
    }
    return _cellWidth;
}

///可重用视图
- (NSMutableSet *)reusableCells
{
    if (!_reusableCells)
    {
        _reusableCells = [[NSMutableSet alloc]init];
    }
    return _reusableCells;
}

///视图信息
- (NSMutableArray *)cellInfosArray
{
    if (!_cellInfosArray)
    {
        _cellInfosArray = [NSMutableArray array];
    }
    return _cellInfosArray;
}

- (void)setDelegate:(id<KNFlowViewDelegate>)delegate
{
    if (self.delegate != delegate)
    {
        super.delegate = delegate;
        [self tryReloadData];
    }
}

- (void)setCellHeight:(CGFloat)cellHeight
{
    if (_cellHeight != cellHeight)
    {
        _cellHeight = cellHeight;
        _rowHeight = cellHeight + self.cellSpace;
        [self tryReloadData];
    }
}

- (void)setNumberOfColumn:(NSInteger)numberOfColumn
{
    if(_numberOfColumn != numberOfColumn)
    {
        _numberOfColumn = numberOfColumn;
        [self tryReloadData];
    }
}

#pragma mark - 生命周期

- (void)dealloc
{
    [super setDelegate:nil];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor whiteColor];
        self.numberOfColumn  = 4;
        self.cellSpace       = 5;
        self.cellHeight      = 100;
        _columnWidth         = CGRectGetWidth(frame) / 4;
        
        _infoType        = @encode(struct cellInfo);
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    CGSize size = self.frame.size;
    super.frame = frame;
    
    //视图大小改变需要重新刷新、布局
    if (size.width != frame.size.width)
    {
        [self tryReloadData];
    }
    else if (size.height != frame.size.height)
    {
        [self resetFlowViewContentSize];
        [self tryReloadData];
    }
        
    //默认cell高度等于cell宽度
    self.cellHeight = self.cellWidth;
    _rowHeight = _columnWidth;
}

- (void)tryReloadData
{
    if(self.window && !self.hidden)
    {
        [self reloadData];
    }
}

- (void)didMoveToWindow
{
    [super didMoveToWindow];
    
    if (self.window && !self.hidden)
    {
        [self reloadData];
    }
}

- (void)setContentOffset:(CGPoint)contentOffset
{
    super.contentOffset = contentOffset;
    
    if (contentOffset.y != perOffestY)
    {
        @synchronized(self)
        {
            [CATransaction begin];
            [CATransaction setDisableActions:YES];
            [self displayCell];
            [CATransaction commit];
        }
    }
}

#pragma mark - 自定义方法

///获取重用视图
- (id)dequeueReusableCell
{
    return _reusableCells.anyObject;
}

///回收视图
- (void)cacheCells:(NSArray *)cells
{
    if (cells.count > 0)
    {
        for (UIView *reuseCell in cells)
        {
            [reuseCell removeFromSuperview];
            [self.reusableCells addObject:reuseCell];
        }
    }
}

///刷新视图
- (void)reloadData
{
     _rowHeight = self.cellHeight + self.cellSpace;
    _columnWidth = CGRectGetWidth(self.bounds) / self.numberOfColumn;
    
    //先移除掉前面显示的，再重新布局
    for (NSNumber *number in [self.visibleCells allKeys])
    {
        [self removeCellAtIndex:[number unsignedIntegerValue]];
    }
    [self.visibleCells removeAllObjects];
    [self.cellInfosArray removeAllObjects];
    
    if ([self.delegate respondsToSelector:@selector(numberOfCellsInFlowView:)])
    {
        //1、读取总数目
        self.numberOfCellCount = [self.delegate numberOfCellsInFlowView:self];
        ///设置contentSize
        [self resetFlowViewContentSize];
        ///缓存高度信息
        [self cacheCellInfomations];
    }
    
    if (!self.numberOfCellCount)
    {
        return;
    }
    
    NSInteger count = [self numberOfReuseCell];
    _visiableRange.location = 0;
    _visiableRange.length = count;
    
    for (int index = 0; index < count; index ++)
    {
        [self addCellToFlowViewAtIndex:index];
    }
    
    ///布局cell
    [self displayCell];
}

///缓存单元视图信息
- (void)cacheCellInfomations
{
    struct cellInfo info;
    
    for (NSInteger index = 0; index < self.numberOfCellCount; index ++)
    {
        NSInteger row = index / self.numberOfColumn;
        NSInteger column = index % self.numberOfColumn;
        
        CGFloat x = self.cellSpace * (column + 1) + self.cellWidth * column;
        CGFloat y = row * _rowHeight + self.cellSpace;
        
        info.cellIndex   = index;
        info.cellOffestY = y;
        info.cellOffestX = x;
        
        NSValue *cellInfo = [NSValue valueWithBytes:&info objCType:_infoType];
        [self.cellInfosArray addObject:cellInfo];
    }
}

#pragma mark - 添加/移除单元视图

///添加一个单元格
- (UIView *)addCellToFlowViewAtIndex:(NSInteger)index
{
    //2、获取cell
    UIView *cell = [self.delegate flowView:self cellForViewAtIndex:index];
    [self.reusableCells removeObject:cell];
    
    struct cellInfo info;
    [self.cellInfosArray[index] getValue:&info];

    cell.frame = CGRectMake(info.cellOffestX, info.cellOffestY, self.cellWidth, self.cellHeight);
    
    [self insertSubview:cell atIndex:0];
    self.visibleCells[@(index)] = cell;
    
    if ([self.delegate respondsToSelector:@selector(flowView:willDisplayCell:atIndex:)])
    {
        [self.delegate flowView:self willDisplayCell:cell atIndex:index];
    }
    
    return cell;
}

///移除一个单元
- (void)removeCellAtIndex:(NSInteger)index
{
    NSNumber *cellKey = @(index);
    UIView *cell = self.visibleCells[cellKey];
    
    if (cell)
    {
        [cell removeFromSuperview];
        [self.visibleCells removeObjectForKey:cellKey];
        ///添加到可回收视图中
        [self.reusableCells addObject:cell];
        
        //3、视图显示完毕
        if ([self.delegate respondsToSelector:@selector(flowView:didEndDisplayCell:atIndex:)])
        {
            [self.delegate flowView:self didEndDisplayCell:cell atIndex:index];
        }
    }
    else
    {
        NSLog(@"KNFlowView视图回收异常:%ld", (long)index);
    }
}

///获取cell的位置
- (CGRect)cellFrameAtIndex:(NSInteger)index
{
    if (self.numberOfCellCount <= 0)
    {
        return CGRectZero;
    }
    
    NSInteger row = index / self.numberOfColumn;
    NSInteger column = index % self.numberOfColumn;
    
    CGFloat x = self.cellSpace * (column + 1) + self.cellWidth * column;
    CGFloat y = row * _rowHeight + self.cellSpace;
    CGRect frame = CGRectMake(x, y, self.cellWidth, self.cellHeight);

    return frame;
}

///重设视图内容大小
- (void)resetFlowViewContentSize
{
    NSInteger rows =  self.numberOfCellCount ? ceil((float)self.numberOfCellCount / self.numberOfColumn) : 0;
    CGFloat height = (self.cellHeight + self.cellSpace) * rows + self.cellSpace;
    
    if (!self.numberOfCellCount || height <= CGRectGetHeight(self.bounds))
    {
        self.contentSize = CGSizeZero;
    }
    else
    {
        CGSize contentSize = CGSizeMake(CGRectGetWidth(self.bounds), height);
        self.contentSize = contentSize;
    }
}

///需要分配的重用视图个数
- (NSInteger)numberOfReuseCell
{
    CGFloat height = CGRectGetHeight(self.bounds);
    if (self.contentSize.height > height)
    {
        NSInteger row = ceilf(height / _rowHeight);
        return row * self.numberOfColumn;
    }
    return self.numberOfCellCount;
}

///重新排列视图
- (void)displayCell
{
    CGFloat currentOffestY = self.contentOffset.y;
    
    if (currentOffestY >= perOffestY)
    {
        /*
         * 回收顶部，添加底部
         */
        
        struct cellInfo topCellInfo, bottomCellInfo;
        NSInteger lastIndex  = NSMaxRange(_visiableRange) - 1;
        
//        if (lastIndex == self.numberOfCellCount - 1)
//        {
//            perOffestY = currentOffestY;
//            return;
//        }
        
        [self.cellInfosArray[_visiableRange.location] getValue:&topCellInfo];
        [self.cellInfosArray[lastIndex] getValue:&bottomCellInfo];
        CGFloat minY = topCellInfo.cellOffestY + self.cellHeight;
        CGFloat maxY = bottomCellInfo.cellOffestY + self.cellHeight + self.cellSpace;
        
        //最顶部一行移出屏幕,则进行回收
        if (currentOffestY > minY)
        {
            //移除顶部
            while (minY < currentOffestY)
            {
//                NSLog(@"移除第%ld个",_visiableRange.location);
                [self removeCellAtIndex:_visiableRange.location];
                _visiableRange.location ++;
                _visiableRange.length --;
                
                if (_visiableRange.location > lastIndex)
                {
                    _visiableRange.location = lastIndex;
                    break;
                }
                
                [self.cellInfosArray[_visiableRange.location] getValue:&topCellInfo];
                minY = topCellInfo.cellOffestY + self.cellHeight;
            }
        }
        
        //最后一行需要补充，则添加底部
        if (currentOffestY + self.bounds.size.height > maxY)
        {
            if (NSMaxRange(_visiableRange) < self.numberOfCellCount)
            {
                ///添加底部
                [self.cellInfosArray[NSMaxRange(_visiableRange)] getValue:&bottomCellInfo];
                NSInteger maxY = bottomCellInfo.cellOffestY;
                
                while (maxY < currentOffestY + CGRectGetHeight(self.bounds))
                {
//                    NSLog(@"========添加%ld",NSMaxRange(_visiableRange));
                    [self addCellToFlowViewAtIndex:NSMaxRange(_visiableRange)];
                    _visiableRange.length ++;
                    
                    if (NSMaxRange(_visiableRange) == self.numberOfCellCount)
                    {
                        break;
                    }
                    
                    [self.cellInfosArray[NSMaxRange(_visiableRange)] getValue:&bottomCellInfo];
                    maxY = bottomCellInfo.cellOffestY;
                }
            }
        }
    }
    else
    {
        /*
         * 回收底部，添加顶部
         */
        struct cellInfo topCllInfo, bottomCellInfo;
        NSInteger lastIndex = NSMaxRange(_visiableRange) - 1;
        [self.cellInfosArray[_visiableRange.location] getValue:&topCllInfo];
        [self.cellInfosArray[lastIndex] getValue:&bottomCellInfo];
        
        CGFloat minY = topCllInfo.cellOffestY + self.cellHeight;
        CGFloat maxY = bottomCellInfo.cellOffestY;
        
        //底部若有移出屏幕的，则进行回收
        if (maxY > currentOffestY + self.bounds.size.height)
        {
            while (maxY > currentOffestY + self.bounds.size.height)
            {
//                NSLog(@"移除第%ld个",NSMaxRange(_visiableRange) - 1);
                [self removeCellAtIndex:NSMaxRange(_visiableRange) - 1];
                
                if (_visiableRange.length == 0)
                {
                    break;
                }
                _visiableRange.length --;
                
                [self.cellInfosArray[NSMaxRange(_visiableRange) - 1] getValue:&bottomCellInfo];
                maxY = bottomCellInfo.cellOffestY;
            }
        }
        
        //顶部补充单元格
        if (minY > currentOffestY)
        {
            if (_visiableRange.location == 0)
            {
                perOffestY = currentOffestY;
                return;
            }
            
            [self.cellInfosArray[_visiableRange.location - 1] getValue:&topCllInfo];
            minY = topCllInfo.cellOffestY + self.cellHeight;
            
            while (minY > currentOffestY)
            {
                _visiableRange.location --;
                _visiableRange.length ++;
//                NSLog(@"========添加%ld",_visiableRange.location);
                [self addCellToFlowViewAtIndex:_visiableRange.location];
                
                if (_visiableRange.location == 0)
                {
                    break;
                }
                
                [self.cellInfosArray[_visiableRange.location - 1] getValue:&topCllInfo];
                minY = topCllInfo.cellOffestY + self.cellHeight;
            }
        }
    }
    
    perOffestY = currentOffestY;
}

///滑动到顶端
- (void)scrollToTopAnimated:(BOOL)animated
{
    [self setContentOffset:CGPointZero animated:animated];
}

///滑动到底部
- (void)scrollToBottomWithAnimated:(BOOL)animated
{
    CGPoint offest = CGPointMake(0, self.contentSize.height - CGRectGetHeight(self.bounds));
    [self setContentOffset:offest animated:animated];
}

///获取点击单元格下标
- (NSInteger)indexAtTouches:(NSSet *)touches
{
    UITouch *touch = [touches anyObject];
    CGPoint point  = [touch locationInView:self];
    
    if (_columnWidth <= 0.0 || _rowHeight <= 0)
    {
        return NSNotFound;
    }
    
    NSInteger column = point.x / _columnWidth;
    NSInteger row = point.y / _rowHeight;
    
    if (column >= self.numberOfColumn)
    {
        return NSNotFound;
    }
    
    NSInteger index = row * self.numberOfColumn + column;
    
    if (index > self.numberOfCellCount)
    {
        return NSNotFound;
    }
    
    return index;
}

#pragma mark - 点击事件

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!self.numberOfCellCount)
    {
        _selectedIndex = NSNotFound;
        return;
    }
    
    _selectedIndex = [self indexAtTouches:touches];
    
    if (_selectedIndex == NSNotFound)
    {
        return;
    }
    
    UIView *cell = _visibleCells[@(_selectedIndex)];
    
    if (!cell)
    {
        _selectedIndex = NSNotFound;
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(flowView:willSelectedCell:atIndex:)])
    {
        [self.delegate flowView:self willSelectedCell:cell atIndex:_selectedIndex];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_selectedIndex != NSNotFound && [self.delegate respondsToSelector:@selector(flowView:didDeselectCell:atIndex:)])
    {
        UIView *cell = _visibleCells[@(_selectedIndex)];
        [self.delegate flowView:self didDeselectCell:cell atIndex:_selectedIndex];
        _selectedIndex = NSNotFound;
    }
    else
    {
        [super touchesCancelled:touches withEvent:event];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_selectedIndex == NSNotFound)
    {
        [super touchesMoved:touches withEvent:event];
        return;
    }
    
    UIView *cell = _visibleCells[@(_selectedIndex)];
    
    if(cell)
    {
        UITouch *touch = touches.anyObject;
        CGPoint point = [touch locationInView:cell];
        
        if(CGRectContainsPoint(cell.bounds, point))
        {
            return;
        }
    }
    
    if([self.delegate respondsToSelector:@selector(flowView:didDeselectCell:atIndex:)])
    {
        NSLog(@"---------选中: %ld",(long)_selectedIndex);
        [self.delegate flowView:self didDeselectCell:cell atIndex:_selectedIndex];
    }
    
    _selectedIndex = NSNotFound;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_selectedIndex == NSNotFound)
    {
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(flowView:didSelectedCell:atIndex:)])
    {
        UIView *cell = _visibleCells[@(_selectedIndex)];
        [self.delegate flowView:self didSelectedCell:cell atIndex:_selectedIndex];
        NSLog(@"---------选中: %ld",(long)_selectedIndex);
    }
    _selectedIndex = NSNotFound;
}

@end
