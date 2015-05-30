//
//  LGProjectException.h
//  LaGou
//
//  Created by kennyhuang on 15/5/30.
//  Copyright (c) 2015年 kennyhuang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LGProjectException : NSObject
@property (nonatomic, strong) NSString *projectName;
@property (nonatomic, strong) NSString *projectTime;
@property (nonatomic, strong) NSString *projectLeader;
@property (nonatomic, strong) NSString *myResponsibilities;
@end
