//
//  KNTMLParserManager.h
//  KNNetWorkTest
//
//  Created by kennyHuang on 14/12/3.
//  Copyright (c) 2014年 kennyHuang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KNTMLParserManager : NSObject

/**
 *  初始化
 *
 *  @param content html内容
 *
 *  @return KNTMLParserManager实例
 */
- (KNTMLParserManager *)initWithHtmlContent:(NSData *)content;

/**
 *  解析出子节点内容
 *
 *  @param superName 父节点名字
 *  @param childName 子节点名字
 *
 *  @return 子节点内容数组
 */
- (NSArray *)parserContentWithSuperName:(NSString *)superName childName:(NSString *)childName;

/**
 *  解析出所有节点中的url
 *
 *  @param superName 父节点名字
 *  @param childName 子节点名字
 *
 *  @return urls
 */
- (NSArray *)parserUrlsWithSuperName:(NSString *)superName childName:(NSString *)childName;

/**
 *  解析出单个节点内容
 *
 *  @param nodeName 节点名字
 *
 *  @return 节点内容数组
 */
- (NSArray *)parserContentWithNodeName:(NSString *)nodeName;

@end
