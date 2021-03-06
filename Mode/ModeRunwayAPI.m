//
//  RunwayAPI.m
//  Mode
//
//  Created by huangmin on 15/5/31.
//  Copyright (c) 2015年 YedaoDEV. All rights reserved.
//

#import "ModeRunwayAPI.h"
#import <AFNetworking.h>
#import "PrefixHeader.pch"
#import "JsonParser.h"
@implementation ModeRunwayAPI
+(void)setTimeoutIntervalBy:(AFHTTPRequestOperationManager*)manager{
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
}
+(NSNumber*)getUserID{
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"userId"];
}

//新建一组秀场心愿单接口
+(void)requestRunwayWithParams:(NSDictionary*)params andCallback:(MyCallback)callback{
    NSString* path = RUNWAY;
    NSMutableDictionary* allParams = [params mutableCopy];
    [allParams setObject:[self getUserID] forKey:@"userId"];
    AFHTTPRequestOperationManager*manager=[AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:[[NSUserDefaults standardUserDefaults]objectForKey:@"token"] forHTTPHeaderField:Token];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [manager POST:path parameters:allParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* jsonDic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        if (![jsonDic objectForKey:@"code"]) {
            NSMutableArray* runwayArr = [[JsonParser parserRunwayInfoByDictionary:jsonDic]mutableCopy];
            [runwayArr addObject:params];
            callback(runwayArr);
        } else {
            callback(@(NO));
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"get_new error:%@",error);
        callback([NSNull null]);
    }];
}
@end
