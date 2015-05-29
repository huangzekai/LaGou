//
//  LGPositionParser.m
//  LaGou
//
//  Created by kennyhuang on 15/5/29.
//  Copyright (c) 2015年 kennyhuang. All rights reserved.
//

#import "LGPositionParser.h"
#import "KNUtil.h"

@interface LGPositionParser ()
@property (nonatomic, strong) NSMutableDictionary *positionDict;
@end

@implementation LGPositionParser

- (LGBaseParser *)initWithHtmlContent:(NSData *)content
{
    self = [super initWithHtmlContent:content];
    if (self)
    {
        self.positionDict = [NSMutableDictionary dictionary];
    }
    return self;
}

- (NSDictionary *)parserLGPositions
{
    NSArray *nodeArray = [self parserNodesWithName:@"menu_box"];
    
    for (HTMLNode *boxNode in nodeArray)
    {
        HTMLNode *titleNode = [boxNode findChildOfClass:@"menu_main"];
        NSString *title = [[titleNode findChildTag:@"h2"] contents];
        title = [title stringTrimWhitespace];
        NSMutableArray *positionArray = [NSMutableArray array];
        
        HTMLNode *subNode = [boxNode findChildOfClass:@"menu_sub dn"];
        
        NSArray *dlNodeArray = [subNode findChildTags:@"dl"];
        
        for (HTMLNode *dlNode in dlNodeArray)
        {
            HTMLNode *subTitleNode = [dlNode findChildTag:@"dt"];
            NSString *subTitle = [[subTitleNode findChildTag:@"a"] contents];
            subTitle = [subTitle stringTrimWhitespace];
            
            NSArray *array = [[dlNode findChildTag:@"dd"] findChildTags:@"a"];
            NSMutableArray *jobArray = [NSMutableArray array];
            for (HTMLNode *positionNode in array)
            {
                NSString *positionName = [[positionNode contents] stringTrimWhitespace];
                NSString *positionUrl = [positionNode getAttributeNamed:@"href"];
                NSDictionary *dict = @{@"positionName" : positionName, @"positionUrl" : positionUrl};
                [jobArray addObject:dict];
            }
            NSDictionary *dict = @{subTitle : jobArray};
            [positionArray addObject:dict];
        }
        [self.positionDict setObject:positionArray forKey:title];
    }
    return self.positionDict;
}

@end
