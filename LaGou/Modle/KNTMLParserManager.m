//
//  KNTMLParserManager.m
//  KNNetWorkTest
//
//  Created by kennyHuang on 14/12/3.
//  Copyright (c) 2014年 kennyHuang. All rights reserved.
//

#import "KNTMLParserManager.h"
#import "HTMLParser.h"

@interface KNTMLParserManager ()
///html内容
@property (nonatomic, copy) NSString *htmlContent;
@end

@implementation KNTMLParserManager

- (KNTMLParserManager *)initWithHtmlContent:(NSData *)content
{
    self = [super init];
    
    if (self)
    {
        NSString *gbkHtmlContent = [self parseGBKStringWithData:content];
        self.htmlContent = gbkHtmlContent;
    }
    return self;
}

- (NSArray *)parserContentWithSuperName:(NSString *)superName childName:(NSString *)childName
{
    if (self.htmlContent.length <= 0)
    {
        return nil;
    }
    
    NSError *error = nil;
    HTMLParser *parser = [[HTMLParser alloc]initWithString:self.htmlContent error:&error];
    
    if (error)
    {
        return nil;
    }
    
    HTMLNode *bodyNode = [parser body];
    NSArray *inputNodes = [bodyNode findChildrenOfClass:superName];
    NSMutableArray *contentArray = [NSMutableArray array];
    
    for (HTMLNode *subNode in inputNodes)
    {
        NSArray *nodeArray = [subNode findChildTags:childName];
        
        for (HTMLNode *node in nodeArray)
        {
            if ([[node contents] isKindOfClass:[NSString class]])
            {
                NSString *content = [NSString stringWithUTF8String:[[node contents] UTF8String]];
                [contentArray addObject:content];
            }
        }
    }
    return contentArray;
}

- (NSArray *)parserUrlsWithSuperName:(NSString *)superName childName:(NSString *)childName
{
    if (self.htmlContent.length <= 0)
    {
        return nil;
    }
    
    NSError *error = nil;
    HTMLParser *parser = [[HTMLParser alloc]initWithString:self.htmlContent error:&error];
    
    if (error)
    {
        return nil;
    }
    
    HTMLNode *bodyNode = [parser body];
    NSArray *inputNodes = [bodyNode findChildrenOfClass:superName];
    NSMutableArray *contentArray = [NSMutableArray array];
    
    for (HTMLNode *subNode in inputNodes)
    {
        NSArray *nodeArray = [subNode findChildTags:childName];
        
        for (HTMLNode *node in nodeArray)
        {
            NSString *url = [node getAttributeNamed:@"href"];
            if ([url isKindOfClass:[NSString class]])
            {
                NSString *content = [NSString stringWithUTF8String:[url UTF8String]];
                [contentArray addObject:content];
            }
        }
    }
    return contentArray;
}

- (NSArray *)parserWithNodeName:(NSString *)nodeName
{
    if (self.htmlContent.length <= 0)
    {
        return nil;
    }
    
    NSError *error = nil;
    HTMLParser *parser = [[HTMLParser alloc]initWithString:self.htmlContent error:&error];
    
    if (error)
    {
        return nil;
    }
    
    HTMLNode *bodyNode = [parser body];
    NSArray *inputNodes = [bodyNode findChildrenOfClass:nodeName];
    NSMutableArray *contentArray = [NSMutableArray array];
    
    for (HTMLNode *subNode in inputNodes)
    {
        if ([[subNode contents] isKindOfClass:[NSString class]])
        {
            [contentArray addObject:[subNode contents]];
        }
    }
    return contentArray;
}

///解析出GBK编码的字符串
- (NSString *)parseGBKStringWithData:(NSData *)sourceData
{
    NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString *gbkString = [[NSString alloc] initWithData:sourceData encoding:gbkEncoding];
    
    return gbkString;
}

@end
