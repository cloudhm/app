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
+(NSString*)getUserId{
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"userId"];
}
//主页面请求数据
+(void)requestMenuListAndCallback:(MyCallback)callback{
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [manager GET:MENU parameters:[self getUserId] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSString* utime = [dictionary objectForKey:@"utime"];
        NSString* last_utime = [[NSUserDefaults standardUserDefaults]objectForKey:@"menu_utime"];
        if (![utime isEqualToString:last_utime]) {
            [[NSUserDefaults standardUserDefaults]setObject:utime forKey:@"menu_time"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            [ModeDatabase deleteTableWithName:HOME_LIST_TABLENAME andConditionKey:nil andConditionValue:nil];
            NSArray* allData = [JsonParser parserMenuListByDictionary:dictionary];
            callback(@([ModeDatabase replaceIntoTable:HOME_LIST_TABLENAME andTableElements:HOME_LIST_ELEMENTS andInsertContent:allData]));
//            NSArray* styleDics = [dictionary objectForKey:@"styles"];
//            BOOL flag1 = NO,flag2 = NO,flag3 = NO;
//            if (![styleDics isKindOfClass:[NSNull class]]) {
//                flag1 = [self createModalByMoalArr:styleDics andKeyword:@"styles" andSaveIntoTable:HOME_LIST_TABLENAME];
//            }
//            
//            NSArray* occasionDics = [dictionary objectForKey:@"occasions"];
//            if (![occasionDics isKindOfClass:[NSNull class]]) {
//                flag2 = [self createModalByMoalArr:occasionDics andKeyword:@"occasions" andSaveIntoTable:HOME_LIST_TABLENAME];
//            }
//            
//            NSArray* brandDics = [dictionary objectForKey:@"brands"];
//            if (![brandDics isKindOfClass:[NSNull class]]) {
//                flag3 = [self createModalByMoalArr:brandDics andKeyword:@"brands" andSaveIntoTable:HOME_LIST_TABLENAME];
//            }
//            
//            if (flag1&&flag2&&flag3) {
//                callback(@(YES));//请求成功，并且存入数据库
//            } else {
//                callback(@(NO));
//            }
        } else {
            callback(@(NO));
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"menu request fail : %@",error);
        callback([NSNull null]);
    }];
    
    
    
}
//+(BOOL) createModalByMoalArr:(NSArray*)modalArr andKeyword:(NSString*)keyword andSaveIntoTable:(NSString*)tableName{
////    return [ModeDatabase replaceIntoTable:HOME_LIST_TABLENAME andTableElements:HOME_LIST_ELEMENTS andInsertContent:modalArr];
//    if (modalArr.count>0) {
//        for (int i = 0; i<modalArr.count; i++) {
//            ModeSysList* syslist = [JsonParser parserMenuListByDictionary:modalArr[i] withKeyword:keyword];
//            
//        }
//    }
//    return NO;
//}


/* //  deprecated request method
//主页面品牌列表请求
+(void)requestBrandListAndCallback:(MyCallback)callback{
    NSString* path = BRAND_LIST;
    AFHTTPRequestOperationManager* manager= [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [manager GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSArray* brandDics = [dictionary objectForKey:@"menuBrands"];
        NSString *utime = [dictionary objectForKey:@"utime"];
        NSString *last_utime=[[NSUserDefaults standardUserDefaults]objectForKey:@"brandlist_utime"];
        if (![utime isEqualToString:last_utime]) {
            [[NSUserDefaults standardUserDefaults]setObject:utime forKey:@"brandlist_utime"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            [ModeDatabase deleteTableWithName:HOME_LIST_TABLENAME andConditionKey:TYPE andConditionValue:BRAND];
            NSMutableArray * brandArr = [NSMutableArray array];
            for (int i = 0; i<brandDics.count; i++) {
                ModeSysList* sysList = [JsonParser parserModeListByDictionary:brandDics[i]];
                [brandArr addObject:sysList];
            }
            callback(brandArr);
        } else {
            callback(@(0));
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
        NSString *utime = [dictionary objectForKey:@"utime"];
        NSArray* occasionDics = [dictionary objectForKey:@"menuOccasions"];
        NSString *last_utime=[[NSUserDefaults standardUserDefaults]objectForKey:@"occssionlist_utime"];
        if (![utime isEqualToString:last_utime]) {
            [[NSUserDefaults standardUserDefaults]setObject:utime forKey:@"occssionlist_utime"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            [ModeDatabase deleteTableWithName:HOME_LIST_TABLENAME andConditionKey:TYPE andConditionValue:OCCASION];
            NSMutableArray * occasionArr = [NSMutableArray array];
            for (int i = 0; i<occasionDics.count; i++) {
                ModeSysList* sysList = [JsonParser parserModeListByDictionary:occasionDics[i]];
                [occasionArr addObject:sysList];
            }
            callback(occasionArr);
        } else {
            callback(@(0));;
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
        NSArray* styleDics = [dictionary objectForKey:@"menuStyles"];
        NSString *utime = [dictionary objectForKey:@"utime"];
        NSString *last_utime=[[NSUserDefaults standardUserDefaults]objectForKey:@"stylelist_utime"];
        if (![utime isEqualToString:last_utime]) {
            [[NSUserDefaults standardUserDefaults]setObject:utime forKey:@"stylelist_utime"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            [ModeDatabase deleteTableWithName:HOME_LIST_TABLENAME andConditionKey:TYPE andConditionValue:STYLE];
            NSMutableArray * styleArr = [NSMutableArray array];
            for (int i = 0; i<styleDics.count; i++) {
                ModeSysList* sysList = [JsonParser parserModeListByDictionary:styleDics[i]];
                [styleArr addObject:sysList];
            }
            callback(styleArr);
        } else {
            callback(@(0));
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"request stylelist fail:%@",error);
        callback([NSNull null]);
    }];
}
*/
@end
