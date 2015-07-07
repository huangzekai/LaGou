//
//  LGBaseFile.m
//  LaGou
//
//  Created by kennyhuang on 15/5/29.
//  Copyright (c) 2015年 kennyhuang. All rights reserved.
//

#import "LGBaseFile.h"

#define kUserInfoName @"LGuserInfo"

@implementation LGBaseFile

+ (NSString *)documentDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return paths[0];
}

+ (NSString *)createPathWithName:(NSString *)name
{
    NSString *path = [LGBaseFile documentDirectory];
    path = [path stringByAppendingPathComponent:name];
    
    return path;
}

+ (NSString *)userInfoDirectory
{
    NSString *documentPath = [LGBaseFile documentDirectory];
    NSString *userInfoPath = [documentPath stringByAppendingPathComponent:kUserInfoName];
    NSLog(@"用户登录信息存放路径:%@",userInfoPath);
    return userInfoPath;
}

@end
