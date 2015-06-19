//
//  JsonParser.m
//  Mode
//
//  Created by YedaoDEV on 15/5/26.
//  Copyright (c) 2015年 YedaoDEV. All rights reserved.
//

#import "JsonParser.h"
#import "ModeSysList.h"
#import "ModeGood.h"
#import "GoodInfo.h"
#import "Coupon.h"
#import "ModeCollection.h"
#import "ModeBrandRunway.h"
#import "PrefixHeaderDatabase.pch"
#import "ProfileInfo.h"
#import "Transaction.h"
#import "CollectionItem.h"
#import "GoodItem.h"
#import "Runway.h"
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
+(NSArray*)parserMenuListByDictionary:(NSDictionary*)dictionary{
    NSMutableArray* allData = [NSMutableArray array];
    NSArray* stylesArr = [dictionary objectForKey:STYLE];
    if (![stylesArr isKindOfClass:[NSNull class]]) {
        NSArray* modeSysLists = [self parserMenuListByArray:stylesArr withKeyword:STYLE];
        [allData addObjectsFromArray:modeSysLists];

    }
    
    NSArray* brandsArr = [dictionary objectForKey:BRAND];
    if (![brandsArr isKindOfClass:[NSNull class]]) {
        NSArray* modeSysLists = [self parserMenuListByArray:brandsArr withKeyword:BRAND];
        [allData addObjectsFromArray:modeSysLists];
    }
    NSArray* occasionsArr = [dictionary objectForKey:OCCASION];
    if (![occasionsArr isKindOfClass:[NSNull class]]) {
        NSArray* modeSysLists = [self parserMenuListByArray:occasionsArr withKeyword:OCCASION];
        [allData addObjectsFromArray:modeSysLists];
        
    }
    return allData;
}
+(NSArray*)parserMenuListByArray:(NSArray*)array withKeyword:(NSString*)keyword{
    NSMutableArray* array1 = [NSMutableArray array];
    for (NSArray* subArray in array) {
        ModeSysList* sysList = [self parserMenuListBySubArray:subArray withKeyword:keyword];
        [array1 addObject:sysList];
    }
    return array1;
}
+(ModeSysList*)parserMenuListBySubArray:(NSArray*)subArray withKeyword:(NSString*)keyword{
    ModeSysList* sysList = [[ModeSysList alloc]init];
    sysList.name = subArray[0];
    sysList.picLink = subArray[1];
    sysList.menutype = keyword;
    if ([sysList.picLink isKindOfClass:[NSNull class]]) {
        sysList.picLink = @"";
    }
    return sysList;
}
#pragma mark PROFILE_INFO
+(ProfileInfo*)parserProfileInfoByDictionary:(NSDictionary*)dictionary{
    ProfileInfo* profileInfo = [[ProfileInfo alloc]init];
//    profileInfo.level = [dictionary objectForKey:@"level"];
//    profileInfo.profileId = [dictionary objectForKey:@"profileId"];
//    profileInfo.uuid = [dictionary objectForKey:@"uuid"];
//    profileInfo.profilePoint = [dictionary objectForKey:@"profilePoint"];
//    profileInfo.utime = [dictionary objectForKey:@"utime"];
//    profileInfo.userId = [dictionary objectForKey:@"userId"];
//    profileInfo.rmb = [dictionary objectForKey:@"rmb"];
//    profileInfo.source = [dictionary objectForKey:@"source"];
//    profileInfo.ctime = [dictionary objectForKey:@"ctime"];
//    profileInfo.birthday = [dictionary objectForKey:@"birthday"];
//    profileInfo.wishes = [dictionary objectForKey:@"wishes"];
//    profileInfo.vip = [dictionary objectForKey:@"vip"];
//    profileInfo.orders = [dictionary objectForKey:@"orders"];
//    profileInfo.inviteBy = [dictionary objectForKey:@"inviteBy"];
//    profileInfo.inviteCode = [dictionary objectForKey:@"inviteCode"];
//    profileInfo.username = [dictionary objectForKey:@"username"];
//    profileInfo.countryCode = [dictionary objectForKey:@"countryCode"];
//    profileInfo.longitude = [dictionary objectForKey:@"longitude"];
//    profileInfo.latitude = [dictionary objectForKey:@"latitude"];
//    profileInfo.gender = [dictionary objectForKey:@"gender"];
    profileInfo.likes = [dictionary objectForKey:@"likes"];
//    profileInfo.shares = [dictionary objectForKey:@"shares"];
    profileInfo.usd = [dictionary objectForKey:@"usd"];
//    profileInfo.avatar = [dictionary objectForKey:@"avatar"];
//    profileInfo.fbToken = [dictionary objectForKey:@"fbToken"];
    
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
    return transaction;
}
#pragma mark 
+(ModeGood*)parserGoodByDictionary:(NSDictionary*)dictionary{
    ModeGood* modeGood = [[ModeGood alloc]init];
    modeGood.brand_img_link = [dictionary objectForKey:@"brand_img_link"];
    modeGood.brand_name = [dictionary objectForKey:@"brand_name"];
    modeGood.goods_id = [dictionary objectForKey:@"goods_id"];
    modeGood.img_link = [dictionary objectForKey:@"img_link"];
    modeGood.has_coupon = [dictionary objectForKey:@"has_coupon"];
    return modeGood;
}
+(GoodInfo*)parserGoodInfoByDictionary:(NSDictionary*)dictionary{
    GoodInfo* goodInfo = [[GoodInfo alloc]init];
    
    goodInfo.brand_id = [dictionary objectForKey:@"brand_id"];
    goodInfo.brand_name = [dictionary objectForKey:@"brand_name"];
    goodInfo.goods_id = [dictionary objectForKey:@"goods_id"];
    goodInfo.goods_title = [dictionary objectForKey:@"goods_title"];
    goodInfo.has_coupon = [dictionary objectForKey:@"has_coupon"];
    goodInfo.img_link = [dictionary objectForKey:@"img_link"];
    goodInfo.last_time = [dictionary objectForKey:@"last_time"];
    goodInfo.goods_price = [dictionary objectForKey:@"price"];
    goodInfo.goods_color = [dictionary objectForKey:@"color"];
    goodInfo.goods_size = [dictionary objectForKey:@"size"];
    goodInfo.img_detail_link = [dictionary objectForKey:@"img_detail_link"];
    goodInfo.ctime = [dictionary objectForKey:@"ctime"];
    goodInfo.ctime=[self getRelativeTimeBySeconds:goodInfo.ctime];
    if ([goodInfo.has_coupon isEqualToString:@"Y"]) {
        NSDictionary* couponDic = [dictionary objectForKey:@"coupon"];
        goodInfo.coupon = [self parserCouponByDictionary:couponDic];
    } else {
        goodInfo.coupon = nil;
    }
    return goodInfo;
}
+(Coupon*)parserCouponByDictionary:(NSDictionary*)dictionary{
    Coupon* coupon = [[Coupon alloc]init];
    coupon.amount = [dictionary objectForKey:@"amount"];
    coupon.coupon = [dictionary objectForKey:@"coupon"];
    coupon.coupon_id = [dictionary objectForKey:@"coupon_id"];
    coupon.expired_time = [dictionary objectForKey:@"expired_time"];
    coupon.left_amount = [dictionary objectForKey:@"left_amount"];
    return coupon;
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
    modeCollection.defaultThumb = [dictionary objectForKey:@"defaultThumb"];
    modeCollection.comments = [dictionary objectForKey:@"comments"];
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
    goodItem.color = [self stringObjectForKey:@"color" byDictionary:dictionary];
    goodItem.itemId = [dictionary objectForKey:@"itemId"];
    goodItem.ctime = [self getRelativeTimeBySeconds:[dictionary objectForKey:@"ctime"]];
    goodItem.goodSize = [dictionary objectForKey:@"size"];
    goodItem.expires = [dictionary objectForKey:@"expires"];
    goodItem.itemName = [dictionary objectForKey:@"itemName"];
    goodItem.merchantId = [dictionary objectForKey:@"merchantId"];
    goodItem.defaultImage = [dictionary objectForKey:@"defaultImage"];
    goodItem.goodPrice = [dictionary objectForKey:@"goodPrice"];
    goodItem.style = [self stringObjectForKey:@"style" byDictionary:dictionary];
    goodItem.defaultThumb = [dictionary objectForKey:@"defaultThumb"];
    goodItem.productLink = [self stringObjectForKey:@"productLink" byDictionary:dictionary];
    goodItem.goodTitle = [self stringObjectForKey:@"goodTitle" byDictionary:dictionary];
    goodItem.brandId = [dictionary objectForKey:@"brandId"];
    goodItem.occasion = [self stringObjectForKey:@"occasion" byDictionary:dictionary];
    goodItem.status = [dictionary objectForKey:@"status"];
    goodItem.goodDescription = [self stringObjectForKey:@"goodDescription" byDictionary:dictionary];
    goodItem.hasCoupon = @"true";//自己设的
    goodItem.hasSelected = NO;
    return goodItem;
}
//+(CollectionItem*)parserCollectionItemBy:(NSDictionary*)dictionary{
//    CollectionItem* collectionItem = [[CollectionItem alloc]init];
//    collectionItem.itemId = [dictionary objectForKey:@"itemId"];
//    collectionItem.ctime = [dictionary objectForKey:@"ctime"];
//    collectionItem.utime = [dictionary objectForKey:@"utime"];
//    return collectionItem;
//}


+(NSString*)stringObjectForKey:(NSString*)key byDictionary:(NSDictionary*)dictionary{
    if ([[dictionary objectForKey:key]isKindOfClass:[NSNull class]]||[dictionary objectForKey:key]==nil||[[dictionary objectForKey:key]isEqualToString:@"null"]||[[dictionary objectForKey:key]isEqualToString:@"red"]||[[dictionary objectForKey:key]isEqualToString:@"Array"]) {
        return @"";
    } else {
        return [dictionary objectForKey:key];
    }
}
//+(ModeWishlist*)parserWishlistByDictionary:(NSArray*)array{
//    ModeWishlist* modeWishlist = [[ModeWishlist alloc]init];
//    modeWishlist.wishlist_id = [dictionary objectForKey:@"wishlist_id"];
//    modeWishlist.comments = [dictionary objectForKey:@"comments"];
//    modeWishlist.img_link = [dictionary objectForKey:@"img_link"];
//    modeWishlist.ctime = [dictionary objectForKey:@"ctime"];
//    modeWishlist.ctime = [self getRelativeTimeBySeconds:modeWishlist.ctime];
//    return modeWishlist;
//}
+(ModeBrandRunway*)parserBrandRunwayByDictionary:(NSDictionary*)dictionary{
    ModeBrandRunway* brandRunway = [[ModeBrandRunway alloc]init];
    brandRunway.ctime = [dictionary objectForKey:@"ctime"];
    brandRunway.pic_link = [dictionary objectForKey:@"pic_link"];
    brandRunway.event_id = [dictionary objectForKey:@"event_id"];
    return brandRunway;
}
+(Runway*)parserRunwayByDictionary:(NSDictionary*)dictionary{
    Runway* runway = [[Runway alloc]init];
    runway.runwayDescription = [dictionary objectForKey:@"description"];
    runway.runwayTitle = [dictionary objectForKey:@"title"];
    return runway;
}
+(NSArray*)parserRunwayInfoByDictionary:(NSDictionary*)dictionary{
    NSDictionary* runwayDic = [dictionary objectForKey:@"runway"];
    Runway* runway = [self parserRunwayByDictionary:runwayDic];
    NSMutableArray* goodItems = [NSMutableArray array];
    NSArray* goodItemDics = [dictionary objectForKey:@"items"];
    for (NSDictionary* goodItemDic in goodItemDics) {
        GoodItem* goodItem = [self parserGoodItemByDictionary:goodItemDic];
        [goodItems addObject:goodItem];
    }
    return @[runway,goodItems];
}
@end
