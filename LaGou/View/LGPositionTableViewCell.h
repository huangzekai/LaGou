//
//  LGPositionTableViewCell.h
//  LaGou
//
//  Created by kennyhuang on 15/5/30.
//  Copyright (c) 2015年 kennyhuang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LGPositionTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *logoImageView;
@property (strong, nonatomic) IBOutlet UILabel *companyLabel;
@property (strong, nonatomic) IBOutlet UILabel *positionLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *salaryLabel;

@end
