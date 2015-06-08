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

@property (nonatomic, strong) NSString* brandIntroduce;

-(CGFloat)getBrandDetailHeigthtByWidth:(CGFloat)width;
@end
