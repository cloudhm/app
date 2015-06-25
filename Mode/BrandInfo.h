//
//  BrandInfo.h
//  Mode
//
//  Created by YedaoDEV on 15/5/26.
//  Copyright (c) 2015年 YedaoDEV. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface BrandInfo : NSObject
@property (strong, nonatomic) NSNumber *brandId;
@property (strong, nonatomic) NSString *brandName;
@property (strong, nonatomic) NSString *brandCname;
@property (strong, nonatomic) NSString *brandEname;
@property (strong, nonatomic) NSString *brandLogo;
@property (strong, nonatomic) NSString *brandTitle;//null
@property (strong, nonatomic) NSString *brandDescription;//null
@property (strong, nonatomic) NSNumber *merchantId;//null
@property (strong, nonatomic) NSNumber *sortOrder;

@property (strong, nonatomic) NSNumber *status;

@property (strong, nonatomic) NSNumber *likes;
@property (strong, nonatomic) NSNumber *ctime;
@property (strong, nonatomic) NSNumber *utime;

-(CGFloat)getBrandDetailHeigthtByWidth:(CGFloat)width;
@end
