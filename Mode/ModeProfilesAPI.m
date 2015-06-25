//
//  ModeProfilesAPI.m
//  Mode
//
//  Created by YedaoDEV on 15/6/18.
//  Copyright (c) 2015年 YedaoDEV. All rights reserved.
//

#import "ModeProfilesAPI.h"
#import "PrefixHeader.pch"
#import <AFNetworking.h>
#import "ProfileInfo.h"
#import "JsonParser.h"
@implementation ModeProfilesAPI
+(void)setTimeoutIntervalBy:(AFHTTPRequestOperationManager*)manager{
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
}
+(NSString*)getUserId{
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"userId"];
}
+(void)requestProfilesAndCallback:(MyCallback)callback{
    NSString* path = PROFILEINFO;
    NSString* profilesInfoPath = [path stringByAppendingPathComponent:[self getUserId]];
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:[[NSUserDefaults standardUserDefaults]objectForKey:@"token"] forHTTPHeaderField:Token];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [self setTimeoutIntervalBy:manager];
    [manager GET:profilesInfoPath parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        if (![dictionary objectForKey:@"code"]) {
            ProfileInfo* profileInfo = [JsonParser parserProfileInfoByDictionary:dictionary];
            callback(profileInfo);
        } else {
            callback(@(NO));
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"request profileInfo failure:%@",error);
        callback([NSNull null]);
    }];
}
+(void)requestEnchashmentWithParams:(NSDictionary*)params andCallback:(MyCallback)callback{
    NSString* path = ENCHASHMENT;
    NSMutableDictionary* allParams = [params mutableCopy];
    [allParams setObject:[self getUserId] forKey:@"userId"];
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:[[NSUserDefaults standardUserDefaults]objectForKey:@"token"] forHTTPHeaderField:Token];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [manager PUT:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* jsonDic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        callback(jsonDic);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        callback([NSNull null]);
        NSLog(@"enchashment fail:%@",error);
    }];
}
@end
