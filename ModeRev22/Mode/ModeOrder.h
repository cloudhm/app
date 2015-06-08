//
//  ModeOrder.h
//  Mode
//
//  Created by YedaoDEV on 15/6/6.
//  Copyright (c) 2015年 YedaoDEV. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface ModeOrder : NSObject
#warning 只是暂时根据效果图更改
@property (copy, nonatomic) NSString *clothesTitle;
@property (copy, nonatomic) NSString *releaseDate;
@property (copy, nonatomic) NSString *clothesColor;
@property (copy, nonatomic) NSString *clothesSize;
@property (copy, nonatomic) NSString *clothesPrice;
-(CGFloat)getTitleHeightByFontDictionary:(NSDictionary*)fontDictionary andLabelWidth:(CGFloat)width;
@end
