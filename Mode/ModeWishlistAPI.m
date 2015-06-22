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
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [manager GET:getCollectionPath parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray* jsonArr = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSArray* collectionArr = [JsonParser parserModeCollectionArrBy:jsonArr];
        callback(collectionArr);
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
    [manager GET:collectionItemsPath parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* jsonDic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSArray* collectionItems = [JsonParser parserCollectionItemsBy:jsonDic];
        callback(collectionItems);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"request wishlistInfo failure:%@",error);
        callback([NSNull null]);
    }];
}

+(void)shareWishlistBy:(NSDictionary*)params andCallback:(MyCallback)callback{
    NSString* path = SHARE_COLLECTION;
    NSMutableDictionary* allParams = [NSMutableDictionary dictionary];
    [allParams setObject:[self getUserID] forKey:@"userId"];
    NSString* collectionStr = @"";
    NSArray* items = [params objectForKey:@"items"];
    for (int i = 0; i<items.count; i++) {
        if ([items[i] isKindOfClass:[GoodItem class]]) {
            GoodItem* goodItem = items[i];
            if (i == 0) {//第一项直接拼接
                collectionStr = [collectionStr stringByAppendingFormat:@"%ld",(long)goodItem.itemId.integerValue];
            } else {//其他项加头&&
                collectionStr = [collectionStr stringByAppendingFormat:@"&&%ld",(long)goodItem.itemId.integerValue];
            }
        }
    }
    [allParams setObject:collectionStr forKey:@"collectionitems"];
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [self setTimeoutIntervalBy:manager];
    [manager POST:path parameters:allParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"share success");
        NSDictionary* dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        callback(dictionary);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"share error:%@",error);
        callback([NSNull null]);
    }];
}


//+(void)requestNewestWishlistAndCallback:(MyCallback)callback{
//    NSString* path = GET_NEWEST_WISHLIST;
//    NSDictionary* params = @{@"user_id":[self getUserID]};
//    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
//    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
//    [manager POST:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSDictionary* dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
//        NSString* amount = [dictionary objectForKey:@"amount"];
//
//        NSDictionary* itemDics = [dictionary objectForKey:@"items"];
//        NSMutableArray* itemArr = [NSMutableArray array];
//        for (int i = 0; i<=amount.integerValue; i++) {
//            NSDictionary* itemDic = [itemDics objectForKey:[NSString stringWithFormat:@"%d",i]];
//            ModeGood* modeGood = [JsonParser parserGoodByDictionary:itemDic];
////            WishlistInfo* wishlistInfo = [JsonParser parserWishlistInfoByDictionary:itemDic];
//            [itemArr addObject:modeGood];
//            
//        }
//        callback(itemArr);
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"request newest wishlist failure:%@",error);
//    }];
//}

@end
