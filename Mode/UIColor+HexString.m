//
//  UIColor+HexString.m
//  Mode
//
//  Created by YedaoDEV on 15/6/6.
//  Copyright (c) 2015年 YedaoDEV. All rights reserved.
//

#import "UIColor+HexString.h"

@implementation UIColor (HexString)
+(UIColor*)colorWithHexString:(NSString*)hexString{
    return [self colorWithHexString:hexString withAlpha:1];
}
+(UIColor*)colorWithHexString:(NSString*)hexString withAlpha:(CGFloat)alpha{
    NSString* newHexString;
    if ([hexString hasPrefix:@"#"]) {
        newHexString = [hexString substringFromIndex:1];
    }
    while (newHexString.length<6) {
        newHexString = [@"0" stringByAppendingString:newHexString];
    }
    unsigned long redValue = strtoul([[newHexString substringWithRange:NSMakeRange(0, 2)] UTF8String], 0, 16);
    unsigned long greenValue = strtoul([[newHexString substringWithRange:NSMakeRange(2, 2)] UTF8String], 0, 16);
    unsigned long blueValue = strtoul([[newHexString substringWithRange:NSMakeRange(4, 2)] UTF8String], 0, 16);
    if (alpha>1.f) {
        alpha = 1.f;
    } else if (alpha<0.f) {
        alpha = 0.f;
    }
    return [UIColor colorWithRed:redValue/255.f green:greenValue/255.f blue:blueValue/255.f alpha:alpha];
}
@end
