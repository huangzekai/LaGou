//
//  LAMyResumeService.m
//  LaGou
//
//  Created by kennyhuang on 15/5/29.
//  Copyright (c) 2015年 kennyhuang. All rights reserved.
//

#import "LAMyResumeService.h"
#import "LANetInterface.h"
#import "AFNetworking.h"
#import "LGResumeParser.h"

@implementation LAMyResumeService
///请求我的简历
- (void)requestMyResume
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:kLAMyResumeUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *htmlContent =  [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"JSON: %@", htmlContent);
        
        LGResumeParser *parser = [[LGResumeParser alloc]initWithHtmlContent:responseObject];
        [parser parserMyResume];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

@end
