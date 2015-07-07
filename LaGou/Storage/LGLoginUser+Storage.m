//
//  LGLoginUser+Storage.m
//  LaGou
//
//  Created by kennyhuang on 15/6/30.
//  Copyright (c) 2015年 kennyhuang. All rights reserved.
//

#import "LGLoginUser+Storage.h"
#import "LGBaseFile.h"

@implementation LGLoginUser (Storage)

- (BOOL)save
{
    NSString *userPath = [LGBaseFile userInfoDirectory];
    return [NSKeyedArchiver archiveRootObject:self toFile:userPath];
}

+ (LGLoginUser *)shareInstance
{
    NSString *userPath = [LGBaseFile userInfoDirectory];
    return [NSKeyedUnarchiver unarchiveObjectWithFile:userPath];
}

@end
