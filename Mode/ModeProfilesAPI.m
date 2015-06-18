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
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [self setTimeoutIntervalBy:manager];
    [manager GET:profilesInfoPath parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        ProfileInfo* profileInfo = [JsonParser parserProfileInfoByDictionary:dictionary];
        callback(profileInfo);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"request profileInfo failure:%@",error);
        callback([NSNull null]);
    }];
}
@end
