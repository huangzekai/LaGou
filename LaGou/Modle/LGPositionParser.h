//
//  LGPositionParser.h
//  LaGou
//
//  Created by kennyhuang on 15/5/29.
//  Copyright (c) 2015年 kennyhuang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LGBaseParser.h"

@interface LGPositionParser : LGBaseParser
- (NSDictionary *)parserLGPositions;
- (void)parserRecommandJobs;
@end
