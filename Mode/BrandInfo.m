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
    NSMutableAttributedString* attributedStr = [[NSMutableAttributedString alloc]initWithString:self.brandIntroduce];
    NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:2.f];
    [attributedStr setAttributes:@{NSParagraphStyleAttributeName:paragraphStyle,NSFontAttributeName:[UIFont fontWithName:@"TimesNewRomanPS-ItalicMT" size:14],NSForegroundColorAttributeName:[UIColor colorWithRed:74/255.f green:74/255.f blue:74/255.f alpha:1]} range:NSMakeRange(0,[self.brandIntroduce length])];
//    NSDictionary* attributes = @{NSFontAttributeName : [UIFont fontWithName:@"Helvetica-Oblique" size:14],NSForegroundColorAttributeName:[UIColor lightGrayColor]};
    CGRect frame = [attributedStr boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    return frame.size.height + 10.f;
}



@end
