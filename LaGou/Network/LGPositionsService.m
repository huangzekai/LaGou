//
//  LGPositionsService.m
//  LaGou
//
//  Created by kennyhuang on 15/5/29.
//  Copyright (c) 2015年 kennyhuang. All rights reserved.
//

#import "LGPositionsService.h"
#import "AFNetworking.h"
#import "LANetInterface.h"
#import "LGPositionParser.h"
#import "LGBaseFile+Storage.h"

@implementation LGPositionsService

- (void)requestLGPositions
{
    NSURL *url = [NSURL URLWithString:kLGMainUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"--------%@", str);
        LGPositionParser *parser = [[LGPositionParser alloc]initWithHtmlContent:responseObject];
        NSDictionary *positions = [parser parserLGPositions];
        [LGBaseFile storagePositionData:positions];
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"发生错误！%@",error);
    }];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:operation];
}

@end
