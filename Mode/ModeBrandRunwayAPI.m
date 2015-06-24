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
#import "JsonParser.h"
#import "BrandInfo.h"
@implementation ModeBrandRunwayAPI
+(void)setTimeoutIntervalBy:(AFHTTPRequestOperationManager*)manager{
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
}
+(NSString*)getUserID{
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"userId"];
}
+(void)requestBrandInfoByBrandId:(NSNumber*)brandId andCallback:(MyCallback)callback{
    NSString* path = BRANDINFO;
    NSString* brandInfoPath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%ld",brandId.integerValue]];
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:[[NSUserDefaults standardUserDefaults]objectForKey:@"token"] forHTTPHeaderField:Token];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [self setTimeoutIntervalBy:manager];
    [manager GET:brandInfoPath parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        if (![dictionary objectForKey:@"code"]) {
            BrandInfo* brandInfo = [JsonParser parserBrandInfoByDictionary:dictionary];
            callback(brandInfo);
        } else {
            callback(@(NO));
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"request_brand_info_error:%@",error);
        callback([NSNull null]);
    }];
}
@end
