//
//  ModeAccountAPI.m
//  Mode
//
//  Created by YedaoDEV on 15/6/4.
//  Copyright (c) 2015年 YedaoDEV. All rights reserved.
//

#import "ModeAccountAPI.h"
#import <AFNetworking.h>
@implementation ModeAccountAPI

+(void)setTimeoutIntervalBy:(AFHTTPRequestOperationManager*)manager{
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
}

+(void)signupWithParams:(NSDictionary*)params andCallback:(MyCallback)callback{
    NSString* path = ACCOUNT_SIGNUP;
    NSMutableDictionary* allParams = [params mutableCopy];
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [self setTimeoutIntervalBy:manager];
    [manager POST:path parameters:allParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        if (![dictionary objectForKey:@"code"]) {
            NSNumber* utime = [dictionary objectForKey:@"utime"];
            NSString* userId = [dictionary objectForKey:@"userId"];
            NSString* token = [dictionary objectForKey:@"token"];
            NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
            [ud setObject:userId forKey:@"userId"];
            [ud setDouble:utime.doubleValue forKey:@"utime"];
            [ud setObject:token forKey:@"token"];
            [ud synchronize];
            callback(@(YES));
        } else {
            callback(@(NO));
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"signup error:%@",error);
        callback([NSNull null]);
    }];
}
+(void)loginWithParams:(NSDictionary*)params andCallback:(MyCallback)callback{
    NSString* path = ACCOUNT_LOGIN;
    NSMutableDictionary* allParams = [params mutableCopy];
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [self setTimeoutIntervalBy:manager];
    [manager POST:path parameters:allParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        if (![dictionary objectForKey:@"code"]) {
            NSString* userId = [dictionary objectForKey:@"userId"];
            NSNumber* utime = [dictionary objectForKey:@"utime"];
            NSString* token = [dictionary objectForKey:@"token"];
            NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
            [ud setObject:userId forKey:@"userId"];
            [ud setDouble:utime.doubleValue forKey:@"utime"];
            [ud setObject:token forKey:@"token"];
            [ud synchronize];
            callback(@(YES));
        } else {
            callback(@(NO));
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"login error:%@",error);
        callback([NSNull null]);
    }];
}
@end
