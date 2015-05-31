//
//  LGPosition.h
//  LaGou
//
//  Created by kennyhuang on 15/5/29.
//  Copyright (c) 2015年 kennyhuang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LGPosition : NSObject
///职位名称
@property (nonatomic, strong) NSString *position;
///职位详情
@property (nonatomic, strong) NSString *positionDetailUrl;
///公司名称
@property (nonatomic, strong) NSString *company;
///公司logo
@property (nonatomic, strong) NSString *companyLogo;
///公司主页
@property (nonatomic, strong) NSString *companyUrl;
///公司领域
@property (nonatomic, strong) NSString *companyDomain;
///公司融资阶段
@property (nonatomic, strong) NSString *stage;
///公司人数规模
@property (nonatomic, strong) NSString *personNumber;
///工作地点
@property (nonatomic, strong) NSString *workPlace;
///薪水
@property (nonatomic, strong) NSString *salary;
///工作经验
@property (nonatomic, strong) NSString *experience;
///发布时间
@property (nonatomic, strong) NSString *publicTime;
///职位诱惑
@property (nonatomic, strong) NSString *temptation;
///学历要求
@property (nonatomic, strong) NSString *education;
@end
