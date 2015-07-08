//
//  LGCityViewController.m
//  LaGou
//
//  Created by kennyhuang on 15/7/7.
//  Copyright (c) 2015年 kennyhuang. All rights reserved.
//

#import "LGCityViewController.h"
#import "KNFlowView.h"

@interface LGCityViewController ()<UITableViewDataSource, UITableViewDelegate, KNFlowViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) KNFlowView *flowView;
///热门城市
@property (nonatomic, strong) NSMutableArray *hotCitys;
@end

@implementation LGCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    
    self.flowView = [[KNFlowView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 100)];
    self.flowView.delegate = self;
    self.flowView.cellHeight = 30;
    self.tableView.tableHeaderView = self.flowView;
}

#pragma mark - KNFlowViewDelegate

- (NSUInteger)numberOfCellsInFlowView:(KNFlowView *)flowView
{
    return self.hotCitys.count;
}
///每个视图定义
- (UIView *)flowView:(KNFlowView *)flowView cellForViewAtIndex:(NSInteger)index
{
    UILabel *label = [flowView dequeueReusableCell];
    
    if (!label)
    {
        NSLog(@"分配内存%ld",(long)index);
        label  = [[UILabel alloc]init];
        label.textColor = [UIColor blackColor];
        label.backgroundColor = [UIColor redColor];
        label.textAlignment = NSTextAlignmentCenter;
    }
    
    label.text = self.hotCitys[index];
    return label;
}

///视图被选中
- (void)flowView:(KNFlowView *)flowView didSelectedCell:(id)cell atIndex:(NSInteger)index
{
        NSLog(@"视图被点击");
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *bgView = [[UIView alloc]init];
    bgView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 30);
    bgView.backgroundColor = [UIColor grayColor];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectInset(bgView.bounds, 15, 0)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont boldSystemFontOfSize:14];
    label.textAlignment = NSTextAlignmentLeft;
    [bgView addSubview:label];
    
    return bgView;
}

@end
