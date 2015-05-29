//
//  LALoginService.m
//  LaGou
//
//  Created by kennyhuang on 15/5/28.
//  Copyright (c) 2015年 kennyhuang. All rights reserved.
//

#import "LALoginService.h"
#import "KNUtil.h"
#import "NSObject+SafeOperation.h"
#import "AFNetworking.h"
#import "LANetInterface.h"

#define kLAMD5key @"veenike"

@implementation LALoginService

- (NSString *)createMd5password:(NSString *)password
{
    NSString *md5Password = [password md5Lowercase];
    md5Password = [NSString stringWithFormat:@"%@%@%@",kLAMD5key, md5Password, kLAMD5key];
    md5Password = [md5Password md5Lowercase];
    return md5Password;
}

- (void)loginWithUserName:(NSString *)userName andPassword:(NSString *)password
{
    if (userName.length <= 0 || password.length <= 0)
    {
        return;
    }
    
    NSString *md5password = [self createMd5password:password];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeOpSetObject:userName forKey:@"username"];
    [params safeOpSetObject:md5password forKey:@"password"];
    [params safeOpSetObject:@"true" forKey:@"rememberMe"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:kLALoginUrl parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON: %@", responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

@end
