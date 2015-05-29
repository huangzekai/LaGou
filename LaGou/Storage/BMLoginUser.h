//
//  BMLoginUser.h
//  LaGou
//
//  Created by kennyhuang on 15/5/28.
//  Copyright (c) 2015年 kennyhuang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BMLoginUser : NSObject<NSCoding>
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *rememberMe; //true
@end
