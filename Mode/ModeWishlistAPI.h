//
//  ModeWishlistAPI.h
//  Mode
//
//  Created by huangmin on 15/5/31.
//  Copyright (c) 2015年 YedaoDEV. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^MyCallback)(id obj);
@interface ModeWishlistAPI : NSObject

//获取用户的wishlist
+(void)requestWishlistsAndCallback:(MyCallback)callback;

//按ID获取用户wishlist
+(void)requestWishlistsByWishlist_ID:(NSString*)wishlist_id AndCallback:(MyCallback)callback;

//获取用户最新的wishlist
+(void)requestNewestWishlistAndCallback:(MyCallback)callback;
@end
