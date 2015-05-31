//
//  LGPositionParser.m
//  LaGou
//
//  Created by kennyhuang on 15/5/29.
//  Copyright (c) 2015年 kennyhuang. All rights reserved.
//

#import "LGPositionParser.h"
#import "KNUtil.h"
#import "LGPosition.h"

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

- (void)parserRecommandJobs
{
    HTMLNode *bodyNode = [self.parser body];
    HTMLNode *hotlistNode = [bodyNode findChildOfClass:@"hot_pos hot_posHotPosition hot_position_list reset"];
    NSArray *listArray = [hotlistNode findChildTags:@"li"];
    
    NSMutableArray *positionArray = [NSMutableArray array];
    
    for (HTMLNode *jobNode in listArray)
    {
        if ([jobNode className].length <= 0) {
            continue;
        }
        LGPosition *position = [[LGPosition alloc]init];
        
        HTMLNode *contentNode = [jobNode findChildOfClass:@"mb10"];
        HTMLNode *companyNode = [contentNode findChildTag:@"a"];
        NSString *detailUrl = [[companyNode getAttributeNamed:@"href"] stringTrimWhitespace];
        position.positionDetailUrl = detailUrl;
        NSString *company = [[companyNode contents] stringTrimWhitespace];
        //公司
        position.company = company;
        
        NSString *workPlace = [[contentNode findChildOfClass:@"c9"] contents];
        //工作地点
        position.workPlace = [workPlace stringTrimWhitespace];
        
        NSArray *daiyuArray = [jobNode findChildTags:@"span"];

        for (HTMLNode *daiyuNode in daiyuArray)
        {
            if ([daiyuNode findChildOfClass:@"c7"])
            {
                NSString *allContent = [[daiyuNode allContents] clearMarginSpace];
                NSArray *array = [allContent componentsSeparatedByString:@" "];
                NSString *content = [array lastObject];
                if ([allContent containsString:@"月薪"])
                {
                    position.salary = content;
                }
                else if ([allContent containsString:@"经验"])
                {
                    position.experience = content;
                }
                else if ([allContent containsString:@"最低学历"])
                {
                    position.education = content;
                }
                else if ([allContent containsString:@"职位诱惑"])
                {
                    position.temptation = content;
                }
            }
            HTMLNode *timeNode = [daiyuArray lastObject];
            position.publicTime = [[timeNode contents] stringTrimWhitespace];
        }
        
        ///////公司///////
        HTMLNode *companyInfoNode = [jobNode findChildOfClass:@"hot_pos_r"];
        NSArray *infoArray = [companyInfoNode findChildTags:@"span"];
        
        for (HTMLNode *infoNode in infoArray)
        {
            if ([infoNode findChildOfClass:@"c7"])
            {
                NSString *allContent = [[infoNode allContents] clearMarginSpace];
                NSArray *array = [allContent componentsSeparatedByString:@" "];
                NSString *content = [array lastObject];
                
                if ([allContent containsString:@"领域"])
                {
                    position.companyDomain = content;
                }
                else if ([allContent containsString:@"阶段"])
                {
                    position.stage = content;
                }
                else if ([allContent containsString:@"规模"])
                {
                    position.personNumber = content;
                }
            }
        }
    }
    
}

@end
