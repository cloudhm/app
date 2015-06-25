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
@implementation ModeGoodAPI
+(void)setTimeoutIntervalBy:(AFHTTPRequestOperationManager*)manager{
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
}
+(NSString*)getUserID{
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"userId"];
}

//+(void)setGoodsFeedbackWithParams:(NSDictionary*)params andCallback:(MyCallback)callback{
//    NSString* path = SET_GOODS_FEEDBACK;
//    NSString* requestPath = [[[path stringByAppendingPathComponent:[self getUserID]]stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[params objectForKey:@"brandId"]]]stringByAppendingPathComponent:[params objectForKey:@"like"]];
////    NSMutableDictionary* allParams = [params mutableCopy];
////    [allParams setObject:[self getUserID] forKey:@"userId"];
//    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
//    [manager.requestSerializer setValue:[[NSUserDefaults standardUserDefaults]objectForKey:@"token"] forHTTPHeaderField:Token];
//    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
//    [self setTimeoutIntervalBy:manager];
//    [manager POST:requestPath parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSDictionary* dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
//        if ([dictionary objectForKey:@"code"]) {
//            callback(@(YES));
//        } else {
//            callback(@(NO));
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"set_good_feedback-error:%@",error);
//        callback([NSNull null]);
//    }];
//}


@end
