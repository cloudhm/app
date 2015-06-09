//
//  OrderCellInnerView.h
//  Mode
//
//  Created by YedaoDEV on 15/6/6.
//  Copyright (c) 2015年 YedaoDEV. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModeOrder.h"
//目前cell都写定值了 暂时未用到此类
@interface OrderCellInnerView : UIView
@property (nonatomic,strong)ModeOrder* modeOrder;
@property (strong, nonatomic) UILabel *clothesTitleLabel;
@property (strong, nonatomic) UIView *separatorLineView;
@property (strong, nonatomic) UILabel *releaseDateLabel;
//@property (strong, nonatomic) ui *<#name#>;
-(CGFloat) getBoundsByWidth:(CGFloat)width;
@end
