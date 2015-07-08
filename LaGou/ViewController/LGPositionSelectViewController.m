//
//  LGPositionSelectViewController.m
//  LaGou
//
//  Created by kennyhuang on 15/7/7.
//  Copyright (c) 2015年 kennyhuang. All rights reserved.
//

#import "LGPositionSelectViewController.h"

@interface LGPositionSelectViewController ()
@property (nonatomic, strong) NSMutableArray *positionArray;
@end

@implementation LGPositionSelectViewController

- (instancetype)initWithPositionArray:(NSArray *)array
{
    self = [super init];
    if (self)
    {
        self.positionArray = [NSMutableArray arrayWithArray:array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.tableFooterView = [[UIView alloc]init];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(rightBarButtonAction:)];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)rightBarButtonAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.positionArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    NSDictionary *info = self.positionArray[indexPath.row];
    cell.textLabel.text = [info objectForKey:@"positionName"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.tableView reloadData];
}

@end
