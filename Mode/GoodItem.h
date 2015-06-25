//
//  GoodItem.h
//  Mode
//
//  Created by YedaoDEV on 15/6/19.
//  Copyright (c) 2015年 YedaoDEV. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodItem : NSObject
@property (strong, nonatomic) NSNumber *itemId;//int
@property (strong, nonatomic) NSString *itemName;//默认@""
@property (strong, nonatomic) NSNumber *merchantId;//long int商家编号
@property (strong, nonatomic) NSNumber *brandId;//int 默认NULL
@property (strong, nonatomic) NSNumber *status;//long int
@property (strong, nonatomic) NSString *ctime;//source->int
@property (strong, nonatomic) NSNumber *utime;//int
@property (strong, nonatomic) NSNumber *saletime;//int
@property (strong, nonatomic) NSString *defaultThumb;//@""
@property (strong, nonatomic) NSString *defaultImage;//@""
@property (strong, nonatomic) NSNumber *goodPrice;// float
@property (strong, nonatomic) NSString *moreProperty;//null
@property (strong, nonatomic) NSString *sku;//null
@property (strong, nonatomic) NSString *goodTitle;//null--产品标题
@property (strong, nonatomic) NSString *goodDescription;//null--产品描述
@property (strong, nonatomic) NSString *goodSize;//source->size  null
@property (strong, nonatomic) NSString *color;//null
@property (strong, nonatomic) NSString *productLink;//null---产品网络链接
@property (strong, nonatomic) NSNumber *expires;//int
@property (strong, nonatomic) NSString *style;//null
@property (strong, nonatomic) NSString *occasion;//null

@property (strong, nonatomic) NSNumber *ifCoupon;
#warning 缺优惠券

@property (strong, nonatomic) NSNumber *hasSelected;
@end
