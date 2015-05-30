//
//  LGBaseParser.m
//  LaGou
//
//  Created by kennyhuang on 15/5/29.
//  Copyright (c) 2015年 kennyhuang. All rights reserved.
//

#import "LGBaseParser.h"
#import "HTMLParser.h"
#import "KNUtil.h"

@interface LGBaseParser ()
@end

@implementation LGBaseParser

- (LGBaseParser *)initWithHtmlContent:(NSData *)content
{
    self = [super init];
    
    if (self)
    {
        NSString *gbkHtmlContent = [[NSString alloc]initWithData:content encoding:NSUTF8StringEncoding];
        self.htmlContent = gbkHtmlContent;
        NSError *error = nil;
        self.parser = [[HTMLParser alloc]initWithString:self.htmlContent error:&error];
        if (error) {
            NSLog(@"parser html error: %@", error);
        }
    }
    return self;
}

///解析出GBK编码的字符串
- (NSString *)parseGBKStringWithData:(NSData *)sourceData
{
    NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString *gbkString = [[NSString alloc] initWithData:sourceData encoding:gbkEncoding];
    
    return gbkString;
}

- (NSArray *)parserNodesWithName:(NSString *)nodeName
{
    if (!self.parser) {
        return nil;
    }
    
    HTMLNode *bodyNode = [self.parser body];
    NSArray *inputNodes = [bodyNode findChildrenOfClass:nodeName];
    return inputNodes;
}

- (NSString *)parserContentWithNode:(HTMLNode *)node
{
    NSString *content = [[node contents] clearMarginSpace];
    return content;
}

@end
