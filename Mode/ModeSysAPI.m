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
    NSString* path = MENU;
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:[[NSUserDefaults standardUserDefaults]objectForKey:@"token"] forHTTPHeaderField:Token];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [self setTimeoutIntervalBy:manager];
    // First request for menu, add headers for Machine ID, OS, Location, etc
    // X-Machine-Id
    // X-Os-Version
    // X-Loc-Longititude
    // X-Loc-Latitude
    [manager GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        if (![dictionary objectForKey:@"code"]) {
            NSData* jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:nil];
            NSString* jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            NSNumber* lastUtime = [ModeDatabase readDatabaseInTableName:HOME_LIST_TABLENAME andSelectConditionKey:@"utime" andSelectConditionValue:nil];
            NSNumber* utime = [dictionary objectForKey:@"utime"];
            if (utime.integerValue != lastUtime.integerValue) {
                [ModeDatabase deleteTableWithName:HOME_LIST_TABLENAME andConditionKey:nil andConditionValue:nil];
                callback(@([ModeDatabase replaceIntoTable:HOME_LIST_TABLENAME andTableElements:HOME_LIST_ELEMENTS andInsertContent:jsonStr]));
            } else {
                callback(@(NO));
            }
        } else {
            callback(@(NO));
        }
       
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"menu request fail : %@",error);
        callback([NSNull null]);
    }];
}
@end
