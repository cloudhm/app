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

@implementation JsonParser
+(NSString*)getRelativeTimeBySeconds:(NSString*)seconds{
    NSTimeInterval timeInterval = seconds.doubleValue;
    NSDate* createDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSDateFormatter* df = [[NSDateFormatter alloc]init];
    df.dateFormat = @"YYYY.MM.dd";
    NSString *strDate = [df stringFromDate:createDate];
    return strDate;
}
+(NSArray*)parserMenuListByDictionary:(NSDictionary*)dictionary{
    NSMutableArray* allData = [NSMutableArray array];
    NSArray* styleDics = [dictionary objectForKey:@"styles"];
    for (NSDictionary* styleDic in styleDics) {
        ModeSysList* modeSysList = [self parserMenuListByDictionary:styleDic withKeyword:@"styles"];
        [allData addObject:modeSysList];
    }
    NSArray* occasionDics = [dictionary objectForKey:@"occasions"];
    for (NSDictionary* occasionDic in occasionDics) {
        ModeSysList* modeSysList = [self parserMenuListByDictionary:occasionDic withKeyword:@"occasions"];
        [allData addObject:modeSysList];
    }
    
    NSArray* brandDics = [dictionary objectForKey:@"brands"];
    for (NSDictionary* brandDic in brandDics) {
        ModeSysList* modeSysList = [self parserMenuListByDictionary:brandDic withKeyword:@"brands"];
        [allData addObject:modeSysList];
    }
    return allData;
}
+(ModeSysList*)parserMenuListByDictionary:(NSDictionary*)dictionary withKeyword:(NSString*)keyword{
    ModeSysList* sysList = [[ModeSysList alloc]init];
    sysList.eventId = [dictionary objectForKey:@"eventId"];
    sysList.name = [dictionary objectForKey:@"name"];
    sysList.amount = [dictionary objectForKey:@"amount"];
    sysList.menutype = keyword;
    sysList.picLink = [dictionary objectForKey:@"picLink"];
    if ([sysList.picLink isKindOfClass:[NSNull class]]) {
        sysList.picLink = @"";
    }
    return sysList;
}
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
