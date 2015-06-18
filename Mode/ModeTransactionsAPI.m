//
//  ModeTransactionsAPI.m
//  Mode
//
//  Created by YedaoDEV on 15/6/18.
//  Copyright (c) 2015年 YedaoDEV. All rights reserved.
//

#import "ModeTransactionsAPI.h"
#import "PrefixHeader.pch"
#import <AFNetworking.h>
#import "ProfileInfo.h"
#import "JsonParser.h"
@implementation ModeTransactionsAPI
+(void)setTimeoutIntervalBy:(AFHTTPRequestOperationManager*)manager{
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
}
+(NSString*)getUserId{
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"userId"];
}
+(void)requestTransactionsAndCallback:(MyCallback)callback{
    NSString* path = TRANSACTIONS;
    NSString* transactionsPath = [path stringByAppendingPathComponent:[self getUserId]];
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [self setTimeoutIntervalBy:manager];
    [manager GET:transactionsPath parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray* jsonArr = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSArray* transactionArr = [JsonParser parserAllTransactionByTransactionArr:jsonArr];
        callback(transactionArr);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"request transactions failure:%@",error);
        callback([NSNull null]);
    }];
}
@end
