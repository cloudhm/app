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

//获取用户的collections
+(void)requestCollectionsAndCallback:(MyCallback)callback;

//按ID获取用户collectionItems
+(void)requestCollectionItems:(NSNumber*)collectionId AndCallback:(MyCallback)callback;

//分享九宫格
+(void)shareWishlistBy:(NSDictionary*)params andCallback:(MyCallback)callback;
@end
