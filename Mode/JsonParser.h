//
//  JsonParser.h
//  Mode
//
//  Created by YedaoDEV on 15/5/26.
//  Copyright (c) 2015年 YedaoDEV. All rights reserved.
//

//数据模型类JSON解析
#import <Foundation/Foundation.h>

@class ModeSysList,ModeWishlist,ModeBrandRunway,ProfileInfo,BrandInfo,CollectionInfo;

@interface JsonParser : NSObject

//主页面SYS_LIST
+(NSDictionary*)parserMenuListByDictionary:(NSDictionary*)dictionary;

//获取个人信息
+(ProfileInfo*)parserProfileInfoByDictionary:(NSDictionary*)dictionary;

//获取用户历史交易信息
+(NSArray*)parserAllTransactionByTransactionArr:(NSArray*)transactionArr;

//获取用户Collection列表
+(NSArray*)parserModeCollectionArrBy:(NSArray*)array;

//获取一个collection中的items
+(NSArray*)parserCollectionItemsBy:(NSDictionary*)dictionary;

//一组秀场
+(NSArray*)parserRunwayInfoByDictionary:(NSDictionary*)dictionary;

//品牌信息介绍
+(BrandInfo*)parserBrandInfoByDictionary:(NSDictionary*)dictionary;

+(NSArray*)parserMenuListByArray:(NSArray*)array;


+(CollectionInfo*)parserCollectionInfoByDictionary:(NSDictionary*)dictionary;

@end
