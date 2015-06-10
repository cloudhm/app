//
//  JsonParser.h
//  Mode
//
//  Created by YedaoDEV on 15/5/26.
//  Copyright (c) 2015年 YedaoDEV. All rights reserved.
//

//数据模型类JSON解析
#import <Foundation/Foundation.h>
@class ModeSysList,ModeGood,GoodInfo,ModeWishlist,ModeBrandRunway;
@interface JsonParser : NSObject

//主页面SYS_LIST
+(ModeSysList*)parserModeListByDictionary:(NSDictionary*)dictionary;

//商品对象解析
+(ModeGood*)parserGoodByDictionary:(NSDictionary*)dictionary;

//商品基本信息
+(GoodInfo*)parserGoodInfoByDictionary:(NSDictionary*)dictionary;

//心愿单
+(ModeWishlist*)parserWishlistByDictionary:(NSDictionary*)dictionary;

//品牌秀场
+(ModeBrandRunway*)parserBrandRunwayByDictionary:(NSDictionary*)dictionary;

@end
