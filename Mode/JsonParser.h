//
//  JsonParser.h
//  Mode
//
//  Created by YedaoDEV on 15/5/26.
//  Copyright (c) 2015年 YedaoDEV. All rights reserved.
//

//数据模型类JSON解析
#import <Foundation/Foundation.h>
@class ModeSysList,ModeGood,GoodInfo,ModeWishlist,ModeBrandRunway,ProfileInfo;
@interface JsonParser : NSObject

//主页面SYS_LIST
+(NSArray*)parserMenuListByDictionary:(NSDictionary*)dictionary;

//获取个人信息
+(ProfileInfo*)parserProfileInfoByDictionary:(NSDictionary*)dictionary;

//获取用户历史交易信息
+(NSArray*)parserAllTransactionByTransactionArr:(NSArray*)transactionArr;

//获取用户Collection列表
+(NSArray*)parserModeCollectionArrBy:(NSArray*)array;
//获取一个collection中的items
+(NSArray*)parserCollectionItemsBy:(NSArray*)array;

//商品对象解析
+(ModeGood*)parserGoodByDictionary:(NSDictionary*)dictionary;

//商品基本信息
+(GoodInfo*)parserGoodInfoByDictionary:(NSDictionary*)dictionary;

//心愿单
+(ModeWishlist*)parserWishlistByDictionary:(NSDictionary*)dictionary;

//品牌秀场
+(ModeBrandRunway*)parserBrandRunwayByDictionary:(NSDictionary*)dictionary;

@end
