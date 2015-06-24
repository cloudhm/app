//
//  ModeWishlistAPI.m
//  Mode
//
//  Created by huangmin on 15/5/31.
//  Copyright (c) 2015年 YedaoDEV. All rights reserved.
//

#import "ModeWishlistAPI.h"
#import "PrefixHeader.pch"
#import <AFNetworking.h>
#import "JsonParser.h"
#import "ModeCollection.h"
#import "GoodItem.h"
@implementation ModeWishlistAPI
+(void)setTimeoutIntervalBy:(AFHTTPRequestOperationManager*)manager{
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
}
+(NSString*)getUserID{
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"userId"];
}
+(void)requestCollectionsAndCallback:(MyCallback)callback{
    NSString* path = GET_COLLECTION;
    NSString* getCollectionPath = [path stringByAppendingPathComponent:[self getUserID]];
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:[[NSUserDefaults standardUserDefaults]objectForKey:@"token"] forHTTPHeaderField:Token];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [manager GET:getCollectionPath parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* jsonDic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        if (![jsonDic isKindOfClass:[NSDictionary class]]) {
            NSArray* jsonArr = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
            NSArray* collectionArr = [JsonParser parserModeCollectionArrBy:jsonArr];
            callback(collectionArr);
        } else {
            callback(@(NO));
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        callback([NSNull null]);
        NSLog(@"request wishlists failure:%@",error);
    }];
}

+(void)requestCollectionItems:(NSNumber*)collectionId AndCallback:(MyCallback)callback{
    NSString* path = GET_COLLECTION_ITEMS;
    NSString* collectionItemsPath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%ld",(long)[collectionId integerValue]]];
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [self setTimeoutIntervalBy:manager];
    [manager GET:collectionItemsPath parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* jsonDic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        if (![jsonDic objectForKey:@"code"]) {
            NSArray* collectionItems = [JsonParser parserCollectionItemsBy:jsonDic];
            callback(collectionItems);
        } else {
            callback(@(NO));
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"request wishlistInfo failure:%@",error);
        callback([NSNull null]);
    }];
}

+(void)shareWishlistBy:(NSDictionary*)params andCallback:(MyCallback)callback{
    NSString* path = SHARE_COLLECTION;
    NSMutableDictionary* allParams = [NSMutableDictionary dictionary];
    [allParams setObject:[self getUserID] forKey:@"userId"];
    NSMutableArray* collectionItems = [NSMutableArray array];
    NSArray* items = [params objectForKey:@"items"];
    for (GoodItem*goodItem in items) {
        [collectionItems addObject:goodItem.itemId];
    }
    [allParams setObject:collectionItems forKey:@"collectionitems"];
    [allParams setObject:[params objectForKey:@"text"] forKey:@"comments"];
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [self setTimeoutIntervalBy:manager];
    [manager POST:path parameters:allParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        if (![dictionary objectForKey:@"code"]) {//服务器成功收到
            callback(@(YES));
        } else {
            callback(@(NO));
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"share error:%@",error);
        callback([NSNull null]);
    }];
}



@end
