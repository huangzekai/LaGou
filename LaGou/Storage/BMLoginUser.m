//
//  BMLoginUser.m
//  LaGou
//
//  Created by kennyhuang on 15/5/28.
//  Copyright (c) 2015年 kennyhuang. All rights reserved.
//

#import "BMLoginUser.h"

#define kAccount @"username"
#define kMd5password @"password"
#define kRemendMe @"rememberMe"

@implementation BMLoginUser
@synthesize username = _username;
@synthesize password = _password;

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.username forKey:kAccount];
    [aCoder encodeObject:self.password forKey:kMd5password];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        _username = [aDecoder decodeObjectForKey:kAccount];
        _password = [aDecoder decodeObjectForKey:kMd5password];
    }
    return self;
}

@end
