//
//  JsonParser.m
//  Mode
//
//  Created by YedaoDEV on 15/5/26.
//  Copyright (c) 2015年 YedaoDEV. All rights reserved.
//

#import "JsonParser.h"
#import "ModeSysList.h"

#import "ModeCollection.h"

#import "PrefixHeaderDatabase.pch"
#import "ProfileInfo.h"
#import "Transaction.h"
#import "CollectionItem.h"
#import "GoodItem.h"
#import "Runway.h"
#import "BrandInfo.h"

#import "CollectionInfo.h"

@implementation JsonParser

#pragma mark TIME-CONVERT
+(NSString*)getRelativeTimeBySeconds:(id)seconds{
    NSTimeInterval  t = [seconds doubleValue];//把字符串或者NSNumber类型转成double
    NSDate* createDate = [NSDate dateWithTimeIntervalSince1970:t];
    NSDateFormatter* df = [[NSDateFormatter alloc]init];
    df.dateFormat = @"YYYY.MM.dd";
    NSString *strDate = [df stringFromDate:createDate];
    return strDate;
}
+(NSString*)getRelativeTimeModeTwoBySeconds:(id)seconds{
    NSTimeInterval  t = [seconds doubleValue];//把字符串或者NSNumber类型转成double
    NSDate* createDate = [NSDate dateWithTimeIntervalSince1970:t];
    NSDateFormatter* df = [[NSDateFormatter alloc]init];
    df.dateFormat = @"dd/MM/YYYY";
    NSString *strDate = [df stringFromDate:createDate];
    return strDate;
}
#pragma mark MENUS
+(NSDictionary*)parserMenuListByDictionary:(NSDictionary*)dictionary{
//    NSMutableDictionary* allData = [NSMutableDictionary dictionary];
//    NSArray* stylesArr = [dictionary objectForKey:STYLE];
//    if (![stylesArr isKindOfClass:[NSNull class]]) {
//        NSArray* modeSysLists = [self parserMenuListByArray:stylesArr withKeyword:STYLE];
//        [allData setObject:modeSysLists forKey:STYLE];
//
//    }
//    
//    NSArray* brandsArr = [dictionary objectForKey:BRAND];
//    if (![brandsArr isKindOfClass:[NSNull class]]) {
//        NSArray* modeSysLists = [self parserMenuListByArray:brandsArr withKeyword:BRAND];
//        [allData setObject:modeSysLists forKey:BRAND];
//    }
//    NSArray* occasionsArr = [dictionary objectForKey:OCCASION];
//    if (![occasionsArr isKindOfClass:[NSNull class]]) {
//        NSArray* modeSysLists = [self parserMenuListByArray:occasionsArr withKeyword:OCCASION];
//        [allData setObject:modeSysLists forKey:OCCASION];
//        
//    }
    return nil;
}
+(NSArray*)parserMenuListByArray:(NSArray*)array{
    NSMutableArray* array1 = [NSMutableArray array];
    for (NSArray* subArray in array) {
        ModeSysList* sysList = [self parserMenuListBySubArray:subArray];
        [array1 addObject:sysList];
    }
    return array1;
}
+(ModeSysList*)parserMenuListBySubArray:(NSArray*)subArray{
    ModeSysList* sysList = [[ModeSysList alloc]init];
    sysList.name = subArray[0];
    sysList.picLink = subArray[1];

    if ([sysList.picLink isKindOfClass:[NSNull class]]||sysList.picLink == nil) {
        sysList.picLink = @"";
    }
    return sysList;
}
#pragma mark PROFILE_INFO
+(ProfileInfo*)parserProfileInfoByDictionary:(NSDictionary*)dictionary{
    ProfileInfo* profileInfo = [[ProfileInfo alloc]init];
    profileInfo.likes = [dictionary objectForKey:@"likes"];
    profileInfo.usd = [dictionary objectForKey:@"usd"];
    
    profileInfo.level = [dictionary objectForKey:@"level"];
    profileInfo.profileId = [dictionary objectForKey:@"profileId"];
    profileInfo.uuid = [dictionary objectForKey:@"uuid"];
    profileInfo.profilePoint = [dictionary objectForKey:@"profilePoint"];
    profileInfo.utime = [dictionary objectForKey:@"utime"];
    profileInfo.userId = [dictionary objectForKey:@"userId"];
    profileInfo.rmb = [dictionary objectForKey:@"rmb"];
    profileInfo.source = [dictionary objectForKey:@"source"];
    profileInfo.ctime = [dictionary objectForKey:@"ctime"];
    profileInfo.birthday = [dictionary objectForKey:@"birthday"];
    profileInfo.wishes = [dictionary objectForKey:@"wishes"];
    profileInfo.vip = [dictionary objectForKey:@"vip"];
    profileInfo.orders = [dictionary objectForKey:@"orders"];
    profileInfo.inviteBy = [dictionary objectForKey:@"inviteBy"];
    profileInfo.inviteCode = [dictionary objectForKey:@"inviteCode"];
    profileInfo.nickname = [dictionary objectForKey:@"nickname"];
    profileInfo.countryCode = [self stringObjectForKey:@"countryCode" byDictionary:dictionary];
    profileInfo.longitude = [self numberObjectForKey:@"longitude" byDictionary:dictionary];
    profileInfo.latitude = [self numberObjectForKey:@"latitude" byDictionary:dictionary];
    profileInfo.gender = [self stringObjectForKey:@"gender" byDictionary:dictionary];
    profileInfo.shares = [dictionary objectForKey:@"shares"];
    profileInfo.avatar = [dictionary objectForKey:@"avatar"];
    profileInfo.fbToken = [dictionary objectForKey:@"fbToken"];
    profileInfo.email = [self stringObjectForKey:@"email" byDictionary:dictionary];

    return profileInfo;
}
#pragma mark TRANSACTIONS
+(NSArray*)parserAllTransactionByTransactionArr:(NSArray*)transactionArr{
    NSMutableArray* array = [NSMutableArray array];
    for (NSDictionary* dictionary in transactionArr) {
        Transaction* transaction = [self parserTransactionBy:dictionary];
        [array addObject:transaction];
    }
    return array;
}
+(Transaction*)parserTransactionBy:(NSDictionary*)dictionary{
    Transaction* transaction = [[Transaction alloc]init];
    NSNumber* t = [dictionary objectForKey:@"ctime"];
    transaction.ctimeStr = [self getRelativeTimeModeTwoBySeconds:t];
    transaction.amount = [NSString stringWithFormat:@"%.2lf",[[dictionary objectForKey:@"amount"]doubleValue]];
    transaction.formerAmount = [self numberObjectForKey:@"formerAmount" byDictionary:dictionary];
    transaction.comment = [self stringObjectForKey:@"comment" byDictionary:dictionary];
    transaction.unit = [dictionary objectForKey:@"unit"];
    transaction.sn = [self stringObjectForKey:@"sn" byDictionary:dictionary];
    transaction.userId = [dictionary objectForKey:@"userId"];
    transaction.utime = [dictionary objectForKey:@"utime"];
    transaction.transactionId = [dictionary objectForKey:@"transactionId"];
    transaction.status = [self numberObjectForKey:@"status" byDictionary:dictionary];
    return transaction;
}

#pragma mark Collection－List
+(NSArray*)parserModeCollectionArrBy:(NSArray*)array{
    NSMutableArray* array1 = [NSMutableArray array];
    for (NSDictionary* dic in array) {
        ModeCollection* modeCollection = [self parserModeCollectionBy:dic];
        [array1 addObject:modeCollection];

    }
    return array1;
}
+(ModeCollection*)parserModeCollectionBy:(NSDictionary*)dictionary{
    ModeCollection* modeCollection = [[ModeCollection alloc]init];
    modeCollection.ctimeStr = [self getRelativeTimeBySeconds:[dictionary objectForKey:@"ctime"]];
    modeCollection.defaultThumb = [self stringObjectForKey:@"defaultThumb" byDictionary:dictionary];
    modeCollection.defaultImage = [self stringObjectForKey:@"defaultImage" byDictionary:dictionary];
    modeCollection.comments = [self stringObjectForKey:@"comments" byDictionary:dictionary];
    modeCollection.utime = [dictionary objectForKey:@"utime"];
    modeCollection.collectionId = [dictionary objectForKey:@"collectionId"];
    return modeCollection;
}

#pragma mark CollectionItems
#warning 这个返回的数组在另一个页面要重新发请求  需要调整
+(NSArray*)parserCollectionItemsBy:(NSDictionary*)dictionary{
    NSMutableArray* array1 = [NSMutableArray array];
    NSArray* itemArr = [dictionary objectForKey:@"items"];
    for (NSDictionary* itemDic in itemArr) {
        GoodItem* goodItem = [JsonParser parserGoodItemByDictionary:itemDic];
        [array1 addObject:goodItem];
    }
    return array1;
}
//解析商品item
+(GoodItem*)parserGoodItemByDictionary:(NSDictionary*)dictionary{
    GoodItem* goodItem = [[GoodItem alloc]init];
    goodItem.moreProperty = [self stringObjectForKey:@"moreProperty" byDictionary:dictionary];
    goodItem.saletime = [dictionary objectForKey:@"saletime"];
    goodItem.sku = [self stringObjectForKey:@"sku" byDictionary:dictionary];
    goodItem.utime = [dictionary objectForKey:@"utime"];
    goodItem.color = [self colorObjectForKey:@"color" byDictionary:dictionary];
    goodItem.itemId = [dictionary objectForKey:@"itemId"];
    goodItem.ctime = [self getRelativeTimeBySeconds:[dictionary objectForKey:@"ctime"]];
    goodItem.goodSize = [self stringObjectForKey:@"size" byDictionary:dictionary];
    goodItem.expires = [dictionary objectForKey:@"expires"];
    goodItem.itemName = [dictionary objectForKey:@"itemName"];
    goodItem.merchantId = [dictionary objectForKey:@"merchantId"];
    goodItem.defaultImage = [dictionary objectForKey:@"defaultImage"];
    goodItem.goodPrice = [dictionary objectForKey:@"price"];
    goodItem.style = [self stringObjectForKey:@"style" byDictionary:dictionary];
    goodItem.defaultThumb = [dictionary objectForKey:@"defaultThumb"];
    goodItem.productLink = [self stringObjectForKey:@"productLink" byDictionary:dictionary];
    goodItem.goodTitle = [self stringObjectForKey:@"title" byDictionary:dictionary];
    goodItem.brandId = [self numberObjectForKey:@"brandId" byDictionary:dictionary];
    goodItem.occasion = [self stringObjectForKey:@"occasion" byDictionary:dictionary];
    goodItem.status = [dictionary objectForKey:@"status"];
    goodItem.goodDescription = [self stringObjectForKey:@"description" byDictionary:dictionary];
    goodItem.ifCoupon = [self numberObjectForKey:@"ifCoupon" byDictionary:dictionary];
    //以下一个自己设的
    goodItem.hasSelected = @(0);
    return goodItem;
}





+(Runway*)parserRunwayByDictionary:(NSDictionary*)dictionary{
    Runway* runway = [[Runway alloc]init];
    runway.status = [self numberObjectForKey:@"status" byDictionary:dictionary];
    runway.source = [self stringObjectForKey:@"source" byDictionary:dictionary];
    runway.runwayDescription = [self stringObjectForKey:@"description" byDictionary:dictionary];
    runway.runwayTitle = [self stringObjectForKey:@"title" byDictionary:dictionary];
    runway.ctime = [dictionary objectForKey:@"ctime"];
    runway.runwayId = [dictionary objectForKey:@"runwayId"];
    runway.utime = [dictionary objectForKey:@"utime"];
    return runway;
}
+(NSArray*)parserRunwayInfoByDictionary:(NSDictionary*)dictionary{
    NSDictionary* runwayDic = [dictionary objectForKey:@"runway"];
    Runway* runway = [self parserRunwayByDictionary:runwayDic];
    NSMutableArray* goodItems = [NSMutableArray array];
    NSArray* goodItemDics = [dictionary objectForKey:@"items"];
    for (NSDictionary* goodItemDic in goodItemDics) {
        if ([goodItemDic isKindOfClass:[NSNull class]]) {
            continue;
        }
        GoodItem* goodItem = [self parserGoodItemByDictionary:goodItemDic];
        [goodItems addObject:goodItem];
    }
    return @[runway,goodItems];
}
+(BrandInfo*)parserBrandInfoByDictionary:(NSDictionary*)dictionary{
#warning 需要核对
    BrandInfo* brandInfo = [[BrandInfo alloc]init];
    brandInfo.brandId = [dictionary objectForKey:@"brandId"];
    brandInfo.brandName = [dictionary objectForKey:@"brandName"];
    brandInfo.brandCname = [dictionary objectForKey:@"brandCname"];
    brandInfo.brandEname = [dictionary objectForKey:@"brandEname"];
    brandInfo.brandLogo = [dictionary objectForKey:@"brandLogo"];
    brandInfo.brandTitle = [self stringObjectForKey:@"title" byDictionary:dictionary];
    brandInfo.brandDescription = [self stringObjectForKey:@"description" byDictionary:dictionary];
    brandInfo.merchantId = [self numberObjectForKey:@"merchantId" byDictionary:dictionary];
    brandInfo.sortOrder = [dictionary objectForKey:@"sortOrder"];
    brandInfo.status = [dictionary objectForKey:@"status"];
    brandInfo.likes = [dictionary objectForKey:@"likes"];
    brandInfo.ctime = [dictionary objectForKey:@"ctime"];
    brandInfo.utime = [dictionary objectForKey:@"utime"];
    return brandInfo;
}

+(CollectionInfo*)parserCollectionInfoByDictionary:(NSDictionary*)dictionary{
    NSDictionary* collectionDic = [dictionary objectForKey:@"collection"];
    CollectionInfo* collectionInfo = [[CollectionInfo alloc]init];
    collectionInfo.collectionId = [collectionDic objectForKey:@"collectionId"];
    collectionInfo.userId = [collectionDic objectForKey:@"userId"];
    collectionInfo.ctimeStr = [self getRelativeTimeBySeconds:[dictionary objectForKey:@"ctime"]];
    collectionInfo.utime = [collectionDic objectForKey:@"utime"];
    collectionInfo.comments = [self stringObjectForKey:@"comments" byDictionary:collectionDic];
    collectionInfo.defaultThumb = [self stringObjectForKey:@"defaultThumb" byDictionary:collectionDic];
    collectionInfo.defaultImage = [self stringObjectForKey:@"defaultImage" byDictionary:collectionDic];
    NSMutableArray* arr = [NSMutableArray array];
    NSArray* collectionItemDics = [dictionary objectForKey:@"items"];
    for (NSDictionary* collectionItemDic in collectionItemDics) {
        GoodItem* goodItem = [self parserGoodItemByDictionary:collectionItemDic];
        [arr addObject:goodItem];
    }
    collectionInfo.collectionItems = arr;
    return collectionInfo;
}

#pragma mark parser null or nil -default value
//颜色判断是否为十六进制编码
+(NSString*)colorObjectForKey:(NSString*)key byDictionary:(NSDictionary*)dictionary{
    if ([[dictionary objectForKey:key]isKindOfClass:[NSNull class]]||
        [dictionary objectForKey:key]==nil||
        [[dictionary objectForKey:key]isEqualToString:@"null"]||
        [[dictionary objectForKey:key]isEqualToString:@"red"]||
        [[dictionary objectForKey:key]isEqualToString:@"Array"]) {
        return @"";
    } else {
        return [dictionary objectForKey:key];
    }
}
//字符串类型判断是否为空或空对象
+(NSString*)stringObjectForKey:(NSString*)key byDictionary:(NSDictionary*)dictionary{
    if ([[dictionary objectForKey:key]isKindOfClass:[NSNull class]]||[dictionary objectForKey:key]==nil) {
        return @"";
    } else {
        return [dictionary objectForKey:key];
    }
}
//数值类型判断是否为空或空对象
+(NSNumber*)numberObjectForKey:(NSString*)key byDictionary:(NSDictionary*)dicitionary{
    if ([[dicitionary objectForKey:key]isKindOfClass:[NSNull class]]||[dicitionary objectForKey:key]==nil) {
        return @(0);
    } else {
        return [dicitionary objectForKey:key];
    }
    
}
@end
