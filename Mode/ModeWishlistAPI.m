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
#import "ModeWishlist.h"
@implementation ModeWishlistAPI

+(NSString*)getUserID{
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
}
+(void)requestWishlistsAndCallback:(MyCallback)callback{
    NSString* path = GET_WISHLISTS;
    NSDictionary* params = @{@"user_id":[self getUserID]};
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [manager POST:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSString* amount = [dictionary objectForKey:@"amount"];
        NSString* utime = [dictionary objectForKey:@"utime"];
//        NSString* lastTime = [[NSUserDefaults standardUserDefaults]objectForKey:@"wishlist_utime"];
//        if (![utime isEqualToString:lastTime]) {
//            [[NSUserDefaults standardUserDefaults]setObject:utime forKey:@"wishlist_utime"];
//            [[NSUserDefaults standardUserDefaults]synchronize];
            NSDictionary* wishlistDics = [dictionary objectForKey:@"lists"];
            NSMutableArray *wishlists = [NSMutableArray array];
            for (int i = 1; i<=amount.integerValue; i++) {
                NSDictionary* wishlistDic = [wishlistDics objectForKey:[NSString stringWithFormat:@"%d",i]];
                ModeWishlist* modeWishlist = [JsonParser parserWishlistByDictionary:wishlistDic];
                [wishlists addObject:modeWishlist];
            }
            callback(wishlists);
//        } else {
//            callback([NSNull null]);
//        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        callback([NSNull null]);
        NSLog(@"request wishlists failure:%@",error);
    }];
}

+(void)requestWishlistsByWishlist_ID:(NSString*)wishlist_id AndCallback:(MyCallback)callback{
    NSString* path = GET_WISHLIST_BY_ID;
    NSDictionary* params = @{@"user_id":[self getUserID],@"wishlist_id":wishlist_id};
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [manager POST:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSString* amount = [dictionary objectForKey:@"amount"];
        NSString* gtime = [dictionary objectForKey:@"gtime"];
        NSString* user_id = [dictionary objectForKey:@"user_id"];
        
        NSDictionary* itemDics = [dictionary objectForKey:@"items"];
        NSMutableArray *itemArr = [NSMutableArray array];
        for (int i = 1; i<=amount.integerValue; i++) {
            NSDictionary* itemDic = [itemDics objectForKey:[NSString stringWithFormat:@"%d",i]];
            ModeGood* modeGood = [JsonParser parserGoodByDictionary:itemDic];
            [itemArr addObject:modeGood];
        }
        callback(itemArr);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"request wishlistInfo failure:%@",error);
        callback([NSNull null]);
    }];
}

+(void)requestNewestWishlistAndCallback:(MyCallback)callback{
    NSString* path = GET_NEWEST_WISHLIST;
    NSDictionary* params = @{@"user_id":[self getUserID]};
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [manager POST:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSString* amount = [dictionary objectForKey:@"amount"];
        NSString* gtime = [dictionary objectForKey:@"gtime"];
        NSString* user_id = [dictionary objectForKey:@"user_id"];
        NSDictionary* itemDics = [dictionary objectForKey:@"items"];
        NSMutableArray* itemArr = [NSMutableArray array];
        for (int i = 0; i<=amount.integerValue; i++) {
            NSDictionary* itemDic = [itemDics objectForKey:[NSString stringWithFormat:@"%d",i]];
            ModeGood* modeGood = [JsonParser parserGoodByDictionary:itemDic];
//            WishlistInfo* wishlistInfo = [JsonParser parserWishlistInfoByDictionary:itemDic];
            [itemArr addObject:modeGood];
            
        }
        callback(itemArr);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"request newest wishlist failure:%@",error);
    }];
}

@end
