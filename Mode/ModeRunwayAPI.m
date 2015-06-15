//
//  RunwayAPI.m
//  Mode
//
//  Created by huangmin on 15/5/31.
//  Copyright (c) 2015年 YedaoDEV. All rights reserved.
//

#import "ModeRunwayAPI.h"
#import <AFNetworking.h>
#import "PrefixHeader.pch"
#import "ModeGood.h"
#import "JsonParser.h"
@implementation ModeRunwayAPI
+(NSNumber*)getUserID{
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
}

//新建一组秀场心愿单接口
+(void)requestGetNewWithParams:(NSDictionary*)params andCallback:(MyCallback)callback{
    NSString* path = GET_NEW;
    NSMutableDictionary* allParams = [params mutableCopy];
    NSLog(NSHomeDirectory());
    [allParams setObject:[self getUserID] forKey:@"user_id"];
    AFHTTPRequestOperationManager*manager=[AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [manager POST:path parameters:allParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSNumber* amount = [dictionary objectForKey:@"amount"];
        NSNumber* user_id = [dictionary objectForKey:@"user_id"];
        NSString* gtime = [dictionary objectForKey:@"gtime"];
        NSString* intro_desc = [dictionary objectForKey:@"intro_desc"];
        NSString* intro_title = [dictionary objectForKey:@"intro_title"];
        /*
         解析秀场所有商品
         */
        NSDictionary* goodDics = [dictionary objectForKey:@"items"];
        NSMutableArray* goodArr = [NSMutableArray array];
        for (int i = 1; i<=amount.integerValue; i++ ) {
            NSDictionary* goodDic = [goodDics objectForKey:[NSString stringWithFormat:@"%d",i]];
            ModeGood* modeGood = [JsonParser parserGoodByDictionary:goodDic];
            [goodArr addObject:modeGood];
        }
        NSDictionary* callbackDic =@{@"intro_desc":intro_desc,@"intro_title":intro_title,@"allItems":goodArr};
        callback(callbackDic);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"get_new error:%@",error);
        callback([NSNull null]);
    }];
}
@end
