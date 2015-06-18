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
#import "ModeWishlist.h"
#import "ModeBrandRunway.h"
#import "PrefixHeaderDatabase.pch"
#import "ProfileInfo.h"
@implementation JsonParser

#pragma mark TIME-CONVERT
+(NSString*)getRelativeTimeBySeconds:(NSString*)seconds{
    NSTimeInterval timeInterval = seconds.doubleValue;
    NSDate* createDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSDateFormatter* df = [[NSDateFormatter alloc]init];
    df.dateFormat = @"YYYY.MM.dd";
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
    NSArray* occasionsArr = [dictionary objectForKey:OCCASION];
    if (![occasionsArr isKindOfClass:[NSNull class]]) {
        NSArray* modeSysLists = [self parserMenuListByArray:occasionsArr withKeyword:OCCASION];
        [allData addObjectsFromArray:modeSysLists];

    }
    NSArray* brandsArr = [dictionary objectForKey:BRAND];
    if (![brandsArr isKindOfClass:[NSNull class]]) {
        NSArray* modeSysLists = [self parserMenuListByArray:brandsArr withKeyword:BRAND];
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
+(ModeWishlist*)parserWishlistByDictionary:(NSDictionary*)dictionary{
    ModeWishlist* modeWishlist = [[ModeWishlist alloc]init];
    modeWishlist.wishlist_id = [dictionary objectForKey:@"wishlist_id"];
    modeWishlist.comments = [dictionary objectForKey:@"comments"];
    modeWishlist.img_link = [dictionary objectForKey:@"img_link"];
    modeWishlist.ctime = [dictionary objectForKey:@"ctime"];
    modeWishlist.ctime = [self getRelativeTimeBySeconds:modeWishlist.ctime];
    return modeWishlist;
}
+(ModeBrandRunway*)parserBrandRunwayByDictionary:(NSDictionary*)dictionary{
    ModeBrandRunway* brandRunway = [[ModeBrandRunway alloc]init];
    brandRunway.ctime = [dictionary objectForKey:@"ctime"];
    brandRunway.pic_link = [dictionary objectForKey:@"pic_link"];
    brandRunway.event_id = [dictionary objectForKey:@"event_id"];
    return brandRunway;
}

@end
