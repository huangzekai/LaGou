//
//  KNFlowView.h
//  KNFlowView
//  可重用规则网格视图
//  Created by huangzekai on 14-12-1.
//  Copyright (c) 2014年 kennyHuang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KNFlowView;


#pragma mark - 代理

@protocol KNFlowViewDelegate <UIScrollViewDelegate>

@required
///单元格视图总个数
- (NSUInteger)numberOfCellsInFlowView:(KNFlowView *)flowView;
///每个视图定义
- (UIView *)flowView:(KNFlowView *)flowView cellForViewAtIndex:(NSInteger)index;

@optional
///视图将要被展示
- (void)flowView:(KNFlowView *)flowView willDisplayCell:(id)cell atIndex:(NSInteger)index;
//视图将结束展示
- (void)flowView:(KNFlowView *)flowView didEndDisplayCell:(id)cell atIndex:(NSUInteger)index;
///视图将要被点击
- (void)flowView:(KNFlowView *)flowView willSelectedCell:(id)cell atIndex:(NSInteger)index;
///视图被点击
- (void)flowView:(KNFlowView *)flowView didSelectedCell:(id)cell atIndex:(NSInteger)index;
///视图取消点击
- (void)flowView:(KNFlowView *)flowView didDeselectCell:(id)cell atIndex:(NSInteger)index;
///视图被删除
- (void)flowView:(KNFlowView *)flowView didDeletedCell:(id)cell atIndex:(NSInteger)index;

@end



@interface KNFlowView : UIScrollView

#pragma mark - 属性

///当前可见视图数组
@property (nonatomic, readonly) NSArray *visibleCellsArray;
///照片流列数
@property (nonatomic) NSInteger numberOfColumn;
///每个单元之间的间隔(默认为5个像素)
@property (nonatomic) CGFloat cellSpace;
///cell高度(默认cellHeight等于宽度)
@property (nonatomic) CGFloat cellHeight;
///单元格宽度
@property (nonatomic, readonly) CGFloat cellWidth;
///代理
@property (nonatomic, weak) id<KNFlowViewDelegate> delegate;

#pragma mark - 方法

///获取重用视图
- (id)dequeueReusableCell;
///刷新
- (void)reloadData;
///滑动到顶端
- (void)scrollToTopAnimated:(BOOL)animated;
///滑动到底部
- (void)scrollToBottomWithAnimated:(BOOL)animated;

@end
