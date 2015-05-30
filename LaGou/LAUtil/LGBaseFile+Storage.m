//
//  LGBaseFile+Storage.m
//  LaGou
//
//  Created by kennyhuang on 15/5/29.
//  Copyright (c) 2015年 kennyhuang. All rights reserved.
//

#import "LGBaseFile+Storage.h"

#define kPositionStorageName @"positions.plist"

@implementation LGBaseFile (Storage)

+ (BOOL)storagePositionData:(NSDictionary *)dict
{
    if (!dict) {
        return NO;
    }
    NSString *path = [LGBaseFile createPathWithName:kPositionStorageName];
    NSLog(@"---------%@",path);
    [dict writeToFile:path atomically:YES];
    return YES;
}

+ (NSDictionary *)obtainPositionDict
{
    NSString *path = [LGBaseFile createPathWithName:kPositionStorageName];
    return [LGBaseFile obtainDictAtPath:path];
}

+ (NSDictionary *)obtainDictAtPath:(NSString *)path
{
    NSDictionary *data = [NSDictionary dictionaryWithContentsOfFile:path];
    return data;
}

@end
