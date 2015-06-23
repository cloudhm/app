//
//  ModeSys.m
//  Mode
//
//  Created by YedaoDEV on 15/5/26.
//  Copyright (c) 2015年 YedaoDEV. All rights reserved.
//

#import "ModeSysAPI.h"
#import <AFNetworking.h>
#import "JsonParser.h"
#import <FMDB.h>
#import "ModeDatabase.h"
#import "PrefixHeaderDatabase.pch"
@implementation ModeSysAPI
+(void)setTimeoutIntervalBy:(AFHTTPRequestOperationManager*)manager{
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
}
+(NSString*)getUserId{
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"userId"];
}
//主页面请求数据
+(void)requestMenuListAndCallback:(MyCallback)callback{
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [self setTimeoutIntervalBy:manager];
    [manager GET:MENU parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSInteger utime = [[dictionary objectForKey:@"utime"] integerValue];
        NSInteger last_utime = [[NSUserDefaults standardUserDefaults]integerForKey:@"menu_utime"];
        if (utime>last_utime) {
            [[NSUserDefaults standardUserDefaults]setInteger:utime forKey:@"menu_utime"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            [ModeDatabase deleteTableWithName:HOME_LIST_TABLENAME andConditionKey:nil andConditionValue:nil];
            NSArray* allData = [JsonParser parserMenuListByDictionary:dictionary];
            callback(@([ModeDatabase replaceIntoTable:HOME_LIST_TABLENAME andTableElements:HOME_LIST_ELEMENTS andInsertContent:allData]));
        } else {
            callback(@(NO));
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"menu request fail : %@",error);
        callback([NSNull null]);
    }];
}
@end
