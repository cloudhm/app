//
//  ModeGood.m
//  Mode
//
//  Created by YedaoDEV on 15/5/28.
//  Copyright (c) 2015年 YedaoDEV. All rights reserved.
//

#import "ModeGoodAPI.h"
#import "PrefixHeader.pch"
#import <AFNetworking.h>
#import "JsonParser.h"
#import "ModeGood.h"
@implementation ModeGoodAPI
+(void)setTimeoutIntervalBy:(AFHTTPRequestOperationManager*)manager{
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
}
+(NSString*)getUserID{
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"userId"];
}



+(void)setGoodsFeedbackWithParams:(NSDictionary*)params andCallback:(MyCallback)callback{
    NSString* path = SET_GOODS_FEEDBACK;
    NSMutableDictionary* allParams = [params mutableCopy];
    [allParams setObject:[self getUserID] forKey:@"userId"];
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [manager POST:path parameters:allParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        callback(dictionary);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"set_good_feedback-error:%@",error);
    }];
}

//+(void)requestGoodInfoWithGoodID:(NSString*)goodID andCallback:(MyCallback)callback{
//    NSString* path = GET_GOODS;
//    NSDictionary* params = @{@"id":goodID};
//    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
//    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
//    [manager POST:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSDictionary* dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
//        GoodInfo* goodInfo=[JsonParser parserGoodInfoByDictionary:dictionary];
//        callback(goodInfo);
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        callback([NSNull null]);
//        NSLog(@"requestGoodInfo error:%@",error);
//    }];
//}
@end
