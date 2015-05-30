//
//  LGBaseFile.m
//  LaGou
//
//  Created by kennyhuang on 15/5/29.
//  Copyright (c) 2015年 kennyhuang. All rights reserved.
//

#import "LGBaseFile.h"

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

@end
