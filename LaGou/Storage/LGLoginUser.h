//
//  LGLoginUser.h
//  LaGou
//
//  Created by kennyhuang on 15/5/28.
//  Copyright (c) 2015年 kennyhuang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LGLoginUser : NSObject<NSCoding>
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *rememberMe; //true
@property (nonatomic, strong) NSString *headPictureUrl;
@property (nonatomic, strong) NSString *sex;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *position;
@property (nonatomic, strong) NSString *school;
@property (nonatomic, strong) NSString *workExperience;
@end
