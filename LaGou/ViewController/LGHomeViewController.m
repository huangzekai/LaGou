//
//  LGHomeViewController.m
//  LaGou
//
//  Created by kennyhuang on 15/5/30.
//  Copyright (c) 2015年 kennyhuang. All rights reserved.
//

#import "LGHomeViewController.h"
#import "LGPositionTableViewCell.h"
#import <GoogleMobileAds/GoogleMobileAds.h>
#import "Masonry.h"

@interface LGHomeViewController ()
@property (nonatomic) GADBannerView *bannerView;
@end

@implementation LGHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.rowHeight = 80;

    self.bannerView = [[GADBannerView alloc]init];
    self.bannerView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 50);
    [self.view insertSubview:self.bannerView aboveSubview:self.tableView];
    
    self.bannerView.adUnitID = @"ca-app-pub-3940256099942544/2934735716";
    self.bannerView.rootViewController = self;
    [self.bannerView loadRequest:[GADRequest request]];
    
    NSLog(@"-------------google admob version:%@",[GADRequest sdkVersion]);
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"PositionCell";
    LGPositionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell)
    {
        cell = [[LGPositionTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"LGPositionTableViewCell" owner:nil options:nil];
        cell = [nibArray objectAtIndex:0];
    }
    cell.logoImageView.backgroundColor = [UIColor grayColor];
    cell.companyLabel.text = @"测试";
    cell.positionLabel.text = @"iOS [广州]";
    cell.timeLabel.text = @"2015-01-12";
    cell.salaryLabel.text = @"12-20K";
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

//    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
//    
//    [self.navigationController pushViewController:detailViewController animated:YES];
}

@end
