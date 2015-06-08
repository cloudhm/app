//
//  Coupon.h
//  Mode
//
//  Created by huangmin on 15/5/30.
//  Copyright (c) 2015年 YedaoDEV. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Coupon : NSObject
@property (nonatomic,copy) NSString* amount;
@property (nonatomic,copy) NSString* coupon;
@property (nonatomic,copy) NSString* coupon_id;
@property (nonatomic,copy) NSString* expired_time;
@property (nonatomic,copy) NSString* left_amount;
@end
