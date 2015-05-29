//
//  LGBaseParser.h
//  LaGou
//
//  Created by kennyhuang on 15/5/29.
//  Copyright (c) 2015年 kennyhuang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTMLParser.h"

@interface LGBaseParser : NSObject

@property (nonatomic, copy) NSString *htmlContent;

- (LGBaseParser *)initWithHtmlContent:(NSData *)content;

- (NSArray *)parserNodesWithName:(NSString *)nodeName;

- (NSString *)parserContentWithNode:(HTMLNode *)node;

@end
