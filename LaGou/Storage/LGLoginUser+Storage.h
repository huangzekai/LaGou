//
//  LGLoginUser+Storage.h
//  LaGou
//
//  Created by kennyhuang on 15/6/30.
//  Copyright (c) 2015年 kennyhuang. All rights reserved.
//

#import "LGLoginUser.h"

@interface LGLoginUser (Storage)

+ (LGLoginUser *)shareInstance;

- (BOOL)save;

@end
