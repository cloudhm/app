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
#import "ModeGood.h"
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
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [manager POST:path parameters:allParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* jsonDic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSMutableArray* runwayArr = [[JsonParser parserRunwayInfoByDictionary:jsonDic]mutableCopy];
        [runwayArr addObject:params];
//        NSDictionary* runwayDic = [dictionary objectForKey:@"runway"];
//        
//        NSString* intro_desc = [dictionary objectForKey:@"intro_desc"];
//        NSString* intro_title = [dictionary objectForKey:@"intro_title"];
//        /*
//         解析秀场所有商品  [dictionary objectForKey:@"items"]
//         */
//        NSDictionary* goodDics = [dictionary objectForKey:@"items"];
//        NSMutableArray* goodArr = [NSMutableArray array];
////        NSArray* goodItems = [JsonParser par]
//        NSDictionary* callbackDic =@{@"intro_desc":intro_desc,@"intro_title":intro_title,@"allItems":goodArr};
        callback(runwayArr);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"get_new error:%@",error);
        callback([NSNull null]);
    }];
}
@end
