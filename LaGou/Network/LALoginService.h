//
//  LALoginService.h
//  LaGou
//
//  Created by kennyhuang on 15/5/28.
//  Copyright (c) 2015年 kennyhuang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LALoginService : NSObject
- (void)loginWithUserName:(NSString *)userName andPassword:(NSString *)password;
@end
