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
+(void)signupWithParams:(NSDictionary*)params andCallback:(MyCallback)callback{
    NSString* path = ACCOUNT_SIGNUP;
    NSMutableDictionary* allParams = [params mutableCopy];
    [allParams setObject:@"f" forKey:@"gender"];
    [allParams setObject:@"Mode" forKey:@"nickname"];
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [manager POST:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        callback(dictionary);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"signup error:%@",error);
        callback([NSNull null]);
    }];
}
@end
