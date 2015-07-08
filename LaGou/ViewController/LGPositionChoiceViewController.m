//
//  LGPositionChoiceViewController.m
//  LaGou
//
//  Created by kennyhuang on 15/6/17.
//  Copyright (c) 2015年 kennyhuang. All rights reserved.
//

#import "LGPositionChoiceViewController.h"
#import "LGPositionSelectViewController.h"
#import "LGBaseFile+Storage.h"
#import "MJExtension.h"
#import "KNUtil.h"


#pragma mark - UICollectionView HeaderView
#define kScreenWidth [UIScreen mainScreen].bounds.size.width

#define kTextColor 0xe45657

@interface BMCollectionHeaderView : UICollectionReusableView
@property (nonatomic, strong) UITableViewCell *cell;
@end

@implementation BMCollectionHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
        self.cell.backgroundColor = [UIColor clearColor];
        self.cell.textLabel.textColor = [UIColor colorWithUInt:kTextColor];
        self.cell.textLabel.font = [UIFont systemFontOfSize:16];
        self.cell.detailTextLabel.textColor = [UIColor colorWithUInt:kTextColor];
        self.cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:14];
        self.cell.detailTextLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        self.cell.accessoryView.hidden = YES;
        [self addSubview:self.cell];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.cell.frame = self.bounds;
}

@end




#pragma mark - UICollectionView Item

#define kHeadPictureWidth 56

@interface UICollectionItemView : UICollectionViewCell
@property (nonatomic, strong) UIButton *positionButton;
@end

@implementation UICollectionItemView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
//        self.positionLabel = [[UILabel alloc]init];
//        self.positionLabel.backgroundColor = [UIColor clearColor];
//        self.positionLabel.textColor = [UIColor blueColor];
//        self.positionLabel.textAlignment = NSTextAlignmentCenter;
//        self.positionLabel.font = [UIFont systemFontOfSize:14];
//        self.positionLabel.backgroundColor = [UIColor brownColor];
//        [self.contentView addSubview:self.positionLabel];
        self.positionButton = [[UIButton alloc]init];
        self.positionButton.backgroundColor = [UIColor clearColor];
        [self.positionButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [self.positionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [self.positionButton setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
        [self.positionButton setBackgroundImage:[UIImage imageWithColor:[UIColor redColor]] forState:UIControlStateNormal];
        [self.positionButton setBackgroundImage:[UIImage imageWithColor:[UIColor blueColor]] forState:UIControlStateSelected];
        [self.positionButton setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateHighlighted];
        self.positionButton.titleLabel.font = [UIFont systemFontOfSize:14];
        self.positionButton.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.positionButton.enabled = NO;
        [self addSubview:self.positionButton];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.positionButton.frame = CGRectInset(self.bounds, 5, 0);
}

@end











#define kSectionHeaderHeight 40
#define kSectionHeaderColor 0xfee791


@interface LGPositionChoiceViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic) NSString *toyNickName;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *positionArray;
@end

@implementation LGPositionChoiceViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumLineSpacing = 15;
    layout.minimumInteritemSpacing = 10;
    self.collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
    [self.collectionView registerClass:[UICollectionItemView class] forCellWithReuseIdentifier:@"cellItemIdentifier"];
    [self.collectionView registerClass:[BMCollectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.collectionView];
    
    NSDictionary *positionDict = [LGBaseFile obtainPositionDict];
    self.titleArray = [NSArray arrayWithArray:[positionDict allKeys]];
    self.positionArray = [NSArray arrayWithArray:[positionDict allValues]];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [self.titleArray count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.positionArray[section] count];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(100, 40);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionItemView *itemView = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellItemIdentifier" forIndexPath:indexPath];
    itemView.backgroundColor = [UIColor clearColor];
    if (indexPath.section < self.positionArray.count)
    {
        NSArray *posArray = [self.positionArray objectAtIndex:indexPath.section];
        if (indexPath.row < posArray.count)
        {
            NSDictionary *info = posArray[indexPath.row];
            [itemView.positionButton setTitle:[[info allKeys] firstObject] forState:UIControlStateNormal];
        }
    }
    
    return itemView;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 15, 10, 15);
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section < self.positionArray.count)
    {
        NSArray *posArray = [self.positionArray objectAtIndex:indexPath.section];
        if (indexPath.row < posArray.count)
        {
            NSDictionary *info = posArray[indexPath.row];
            NSArray *detailPositionArray = [NSArray arrayWithArray:[[info allValues] firstObject]];
            
            LGPositionSelectViewController *controller = [[LGPositionSelectViewController alloc]initWithPositionArray:detailPositionArray];
            [self.navigationController pushViewController:controller animated:YES];
        }
    }
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(CGRectGetWidth(self.view.bounds), kSectionHeaderHeight);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    BMCollectionHeaderView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
    reusableView.backgroundColor = [UIColor colorWithUInt:kSectionHeaderColor];
    
    if (indexPath.section < self.titleArray.count) {
        reusableView.cell.textLabel.text = [self.titleArray objectAtIndex:indexPath.section];
    }
    
    return reusableView;
}

#pragma mark - 点击事件

- (void)groupNameSectionTapAction:(UITapGestureRecognizer *)sender
{
    
}

- (void)quitGroupButtonAction:(UIButton *)sender
{
    
}

@end