//
//  ModeBrandRunwayAPI.m
//  Mode
//
//  Created by YedaoDEV on 15/6/5.
//  Copyright (c) 2015年 YedaoDEV. All rights reserved.
//

#import "ModeBrandRunwayAPI.h"
#import <AFNetworking.h>
#import "PrefixHeader.pch"
#import "ModeBrandRunway.h"
#import "JsonParser.h"
@implementation ModeBrandRunwayAPI
+(void)setTimeoutIntervalBy:(AFHTTPRequestOperationManager*)manager{
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
}
+(NSString*)getUserID{
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
}
+(void)requestBrandRunwayListByBrandName:(NSString*)brandName AndCallback:(MyCallback)callback{
    NSString* path = BRAND_GET_RUNWAY_LIST;
#warning brandName 暂时默认为任意参数,可以为nil
    NSDictionary* params = @{@"user_id":[self getUserID]};
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [manager POST:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSString* amount = [dictionary objectForKey:@"amount"];
        NSString* utime = [dictionary objectForKey:@"utime"];
        NSDictionary* brandRunwayDics = [dictionary objectForKey:@"list"];
        NSMutableArray* brandRunwaylist = [NSMutableArray array];
        for (int i = 1; i<=amount.integerValue; i++) {
            NSDictionary* brandRunwayDic = [brandRunwayDics objectForKey:[NSString stringWithFormat:@"%d",i]];
//            ModeBrandRunway* brandRunway = [JsonParser parserBrandRunwayByDictionary:brandRunwayDic];
//            [brandRunwaylist addObject:brandRunway];
        }
        callback(brandRunwaylist);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"request_brand_runway_list_error:%@",error);
        callback([NSNull null]);
    }];
}
@end
