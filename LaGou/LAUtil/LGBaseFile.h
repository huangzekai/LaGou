//
//  LGBaseFile.h
//  LaGou
//
//  Created by kennyhuang on 15/5/29.
//  Copyright (c) 2015年 kennyhuang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LGBaseFile : NSObject
+ (NSString *)documentDirectory;
+ (NSString *)createPathWithName:(NSString *)name;
+ (NSString *)userInfoDirectory;
@end
