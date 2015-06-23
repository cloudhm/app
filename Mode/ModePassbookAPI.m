//
//  ModePassbookAPI.m
//  Mode
//
//  Created by YedaoDEV on 15/6/22.
//  Copyright (c) 2015年 YedaoDEV. All rights reserved.
//

#import "ModePassbookAPI.h"
#import "PrefixHeader.pch"
#import <AFNetworking.h>
#import "JsonParser.h"
#import "Passbook.h"
@implementation ModePassbookAPI
+(NSString*)getUserId{
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"userId"];
}
+(void)requestPassbookListAndCallback:(MyCallback)callback{
    NSString* path = PASSBOOK_LIST;
    NSString* passbookPath = [path stringByAppendingPathComponent:[self getUserId]];
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [manager GET:passbookPath parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"request passbook_list error:%@",error);
    }];
}
@end
