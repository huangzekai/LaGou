//
//  LGLoginUser.m
//  LaGou
//
//  Created by kennyhuang on 15/5/28.
//  Copyright (c) 2015年 kennyhuang. All rights reserved.
//

#import "LGLoginUser.h"

#define kAccount @"username"
#define kMd5password @"password"
#define kRemendMe @"rememberMe"
#define kHeadPic @"headPicture"
#define kSex @"sex"
#define kMobile @"mobile"
#define kEmail @"email"
#define kPosition @"position"
#define kSchool @"school"
#define kWorkExperience @"experience"

@implementation LGLoginUser
@synthesize username = _username;
@synthesize password = _password;
@synthesize headPictureUrl = _headPictureUrl;
@synthesize sex = _sex;
@synthesize mobile = _mobile;
@synthesize email = _email;
@synthesize position = _position;
@synthesize school = _school;
@synthesize workExperience = _workExperience;

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.username forKey:kAccount];
    [aCoder encodeObject:self.password forKey:kMd5password];
    [aCoder encodeObject:self.headPictureUrl forKey:kHeadPic];
    [aCoder encodeObject:self.sex forKey:kSex];
    [aCoder encodeObject:self.mobile forKey:kMobile];
    [aCoder encodeObject:self.email forKey:kEmail];
    [aCoder encodeObject:self.position forKey:kPosition];
    [aCoder encodeObject:self.school forKey:kSchool];
    [aCoder encodeObject:self.workExperience forKey:kWorkExperience];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        _username = [aDecoder decodeObjectForKey:kAccount];
        _password = [aDecoder decodeObjectForKey:kMd5password];
        _headPictureUrl = [aDecoder decodeObjectForKey:kHeadPic];
        _sex = [aDecoder decodeObjectForKey:kSex];
        _mobile = [aDecoder decodeObjectForKey:kMobile];
        _email = [aDecoder decodeObjectForKey:kEmail];
        _position = [aDecoder decodeObjectForKey:kPosition];
        _school = [aDecoder decodeObjectForKey:kSchool];
        _workExperience = [aDecoder decodeObjectForKey:kWorkExperience];
    }
    return self;
}

@end
