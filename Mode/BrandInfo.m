//
//  BrandInfo.m
//  Mode
//
//  Created by YedaoDEV on 15/5/26.
//  Copyright (c) 2015年 YedaoDEV. All rights reserved.
//

#import "BrandInfo.h"

@implementation BrandInfo

-(CGFloat)getBrandDetailHeigthtByWidth:(CGFloat)width{
    NSDictionary* attributes = @{NSFontAttributeName : [UIFont systemFontOfSize:14]};
    CGRect frame = [self.brandIntroduce boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    return frame.size.height + 10.f;
}



@end
