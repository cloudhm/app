//
//  UIColor+HexString.h
//  Mode
//
//  Created by YedaoDEV on 15/6/6.
//  Copyright (c) 2015年 YedaoDEV. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (HexString)
+(UIColor*)colorWithHexString:(NSString*)hexString;
+(UIColor*)colorWithHexString:(NSString*)hexString withAlpha:(CGFloat)alpha;
@end
