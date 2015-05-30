//
//  LGResumeParser.m
//  LaGou
//
//  Created by kennyhuang on 15/5/30.
//  Copyright (c) 2015年 kennyhuang. All rights reserved.
//

#import "LGResumeParser.h"
#import "LGProjectException.h"
#import "LGLoginUser.h"

@interface LGResumeParser ()
@property (nonatomic, strong) LGLoginUser *loginUser;
@end

@implementation LGResumeParser

- (LGBaseParser *)initWithHtmlContent:(NSData *)content
{
    self = [super initWithHtmlContent:content];
    if (self)
    {
        self.loginUser = [[LGLoginUser alloc]init];
    }
    return self;
}

- (void)parserMyResume
{
    [self parserUserInfomation];
    [self parserWorkException];
}

- (void)parserUserInfomation
{
    HTMLNode *bodyNode = [self.parser body];
    HTMLNode *headNode = [bodyNode findChildOfClass:@"mr_top_bg"];
    
    //头像
    NSString *headPicrureUrl = [[headNode findChildOfClass:@"mr_headimg"] getAttributeNamed:@"src"];
    self.loginUser.headPictureUrl = [headPicrureUrl stringTrimWhitespace];
    
    //姓名
    HTMLNode *nameNode = [bodyNode findChildOfClass:@"mr_p_name mr_w604 clearfixs"];
    NSString *userName = [[nameNode findChildOfClass:@"mr_name"] contents];
    self.loginUser.username = [userName stringTrimWhitespace];
    
    //职位
    HTMLNode *shenfenNode = [bodyNode findChildOfClass:@"mr_p_info mr_infoed mr_w604 clearfixs"];
    NSString *position = [[shenfenNode findChildOfClass:@"shenfen"] contents];
    self.loginUser.position = [position stringTrimWhitespace];
    
    //性别
    NSString *sex = [[shenfenNode findChildOfClass:@"s"] contents];
    self.loginUser.sex = sex;
    
    //工作经验
    NSString *jobSpan = [[shenfenNode findChildOfClass:@"job_span"] contents];
    self.loginUser.workExperience = jobSpan;
    
    //电话
    NSString *mobile = [[shenfenNode findChildOfClass:@"mobile"] contents];
    self.loginUser.mobile = [mobile stringTrimWhitespace];
    
    //邮箱
    NSString *email = [[shenfenNode findChildOfClass:@"email"] contents];
    self.loginUser.email = email;
    
    //学校
    HTMLNode *schoolNode = [bodyNode findChildOfClass:@"ul_shenfen"];
    NSString *school = [[schoolNode findChildTag:@"li"] contents];
    self.loginUser.school = [school stringTrimWhitespace];
}

- (void)parserWorkException
{
    HTMLNode *bodyNode = [self.parser body];
    NSArray *array = [bodyNode findChildrenOfClass:@"mr_jobe_list"];
    NSMutableArray *jobExceptionArray = [NSMutableArray array];
    
    for (HTMLNode *projectNode in array)
    {
        HTMLNode *titleNode = [projectNode findChildOfClass:@"projectTitle nourl"];
        if (!titleNode) {
            continue;
        }
        //项目名称
        NSString *title = [[titleNode contents] stringTrimWhitespace];
        LGProjectException *project = [[LGProjectException alloc]init];
        project.projectName = title;
        
        //工作职责
        NSString *position = [[projectNode findChildTag:@"p"] contents];
        project.projectLeader = position;
        
        //项目详情
        NSString *myResponsiblities = [[projectNode findChildOfClass:@"mr_content_m"] contents];
        project.myResponsibilities = [myResponsiblities stringTrimWhitespace];
        
        //时间
        NSString *time = [[projectNode findChildOfClass:@"mr_content_m"] contents];
        project.projectTime = [time stringTrimWhitespace];
        [jobExceptionArray addObject:project];
    }
}

@end
