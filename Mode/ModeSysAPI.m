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
@implementation ModeSysAPI
+(void)clearTable:(NSString*)style_type{
    NSString* documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString* path = [documentPath stringByAppendingPathComponent:@"my.sqlite"];
    FMDatabase* db = [FMDatabase databaseWithPath:path];
    if ([db open]) {
        NSString* sql = [NSString stringWithFormat:@"delete from list_home where type = ? "];
        BOOL res = [db executeUpdate:sql,style_type];
        if (res) {
            NSLog(@"删除成功");
        } else {
            NSLog(@"删除不成功");
        }
        [db close];
    } else {
        [db close];
        NSLog(@"未打开数据库");
    }
}
//主页面品牌列表请求
+(void)requestBrandListAndCallback:(MyCallback)callback{
    NSString* path = BRAND_LIST;
    AFHTTPRequestOperationManager* manager= [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [manager GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSString *amount = [dictionary objectForKey:@"amount"];
        NSString *utime = [dictionary objectForKey:@"utime"];
        NSString *last_utime=[[NSUserDefaults standardUserDefaults]objectForKey:@"brandlist_utime"];
        if (![utime isEqualToString:last_utime]) {
            [[NSUserDefaults standardUserDefaults]setObject:utime forKey:@"brandlist_utime"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            [self clearTable:@"brand"];
            NSDictionary* brandDics = [dictionary objectForKey:@"list"];
            NSMutableArray * brandArr = [NSMutableArray array];
            for (int i = 1; i<=amount.integerValue; i++) {
                NSDictionary *brandDic = [brandDics objectForKey:[NSString stringWithFormat:@"%d",i]];
                ModeSysList* sysList = [JsonParser parserModeListByDictionary:brandDic];
                [brandArr addObject:sysList];
            }
            callback(brandArr);
        } else {
            callback([NSNull null]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"request fail");
        callback([NSNull null]);
    }];
}
//主页面场合列表请求
+(void)requestOccasionListAndCallback:(MyCallback)callback{
    NSString* path = OCCASION_LIST;
    AFHTTPRequestOperationManager* manager= [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [manager GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSString *amount = [dictionary objectForKey:@"amount"];
        NSString *utime = [dictionary objectForKey:@"utime"];
        NSString *last_utime=[[NSUserDefaults standardUserDefaults]objectForKey:@"occssionlist_utime"];
        if (![utime isEqualToString:last_utime]) {
            [[NSUserDefaults standardUserDefaults]setObject:utime forKey:@"occssionlist_utime"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            [self clearTable:@"occasion"];
            NSDictionary* occasionDics = [dictionary objectForKey:@"list"];
            NSMutableArray * occasionArr = [NSMutableArray array];
            for (int i = 1; i<=amount.integerValue; i++) {
                NSDictionary *occasionDic = [occasionDics objectForKey:[NSString stringWithFormat:@"%d",i]];
                ModeSysList* sysList = [JsonParser parserModeListByDictionary:occasionDic];
                [occasionArr addObject:sysList];
            }
            callback(occasionArr);
        } else {
            callback([NSNull null]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"request fail");
        callback([NSNull null]);
    }];
}
//主页面风格请求
+(void)requestStyleListAndCallback:(MyCallback)callback{
    NSString* path = STYLE_LIST;
    AFHTTPRequestOperationManager* manager= [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [manager GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSString *amount = [dictionary objectForKey:@"amount"];
        NSString *utime = [dictionary objectForKey:@"utime"];
        NSString *last_utime=[[NSUserDefaults standardUserDefaults]objectForKey:@"stylelist_utime"];
        if (![utime isEqualToString:last_utime]) {
            [[NSUserDefaults standardUserDefaults]setObject:utime forKey:@"stylelist_utime"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            [self clearTable:@"style"];
            NSDictionary* styleDics = [dictionary objectForKey:@"list"];
            NSMutableArray * styleArr = [NSMutableArray array];
            for (int i = 1; i<=amount.integerValue; i++) {
                NSDictionary *styleDic = [styleDics objectForKey:[NSString stringWithFormat:@"%d",i]];
                ModeSysList* sysList = [JsonParser parserModeListByDictionary:styleDic];
                [styleArr addObject:sysList];
            }
            callback(styleArr);
        } else {
            callback([NSNull null]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"request stylelist fail:%@",error);
        callback([NSNull null]);
    }];
}
@end
