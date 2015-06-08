//
//  ModeOrder.m
//  Mode
//
//  Created by YedaoDEV on 15/6/6.
//  Copyright (c) 2015年 YedaoDEV. All rights reserved.
//

#import "ModeOrder.h"

@implementation ModeOrder
-(CGFloat)getTitleHeightByFontDictionary:(NSDictionary*)fontDictionary andLabelWidth:(CGFloat)width{
    CGRect rect = [self.clothesTitle boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:fontDictionary context:nil];
    return rect.size.height + 10.f;
}

@end
