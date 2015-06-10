//
//  GoodInfo.h
//  Mode
//
//  Created by huangmin on 15/5/30.
//  Copyright (c) 2015年 YedaoDEV. All rights reserved.
//

//get_goods获得的商品信息
#import <Foundation/Foundation.h>
@class Coupon;
@interface GoodInfo : NSObject
@property (nonatomic,copy) NSString* goods_id;
@property (nonatomic,copy) NSString* goods_title;
@property (nonatomic,copy) NSString* img_link;
@property (nonatomic,copy) NSString* img_detail_link;
@property (nonatomic,copy) NSString* goods_price;//price与系统关键字重名
@property (nonatomic,copy) NSString* goods_size;//size与系统关键字重名
@property (nonatomic,copy) NSString* goods_color;//color与系统关键字重名
@property (nonatomic,copy) NSString* has_coupon;
@property (nonatomic,strong) Coupon* coupon;
@property (nonatomic,copy) NSString* ctime;
@property (nonatomic,copy) NSString* last_time;
@property (nonatomic,copy) NSString* brand_name;
@property (nonatomic,copy) NSString* brand_id;
@end
