//
//  LGBaseFile+Storage.h
//  LaGou
//
//  Created by kennyhuang on 15/5/29.
//  Copyright (c) 2015年 kennyhuang. All rights reserved.
//

#import "LGBaseFile.h"

@interface LGBaseFile (Storage)

+ (BOOL)storagePositionData:(NSDictionary *)dict;

+ (NSDictionary *)obtainPositionDict;

@end
