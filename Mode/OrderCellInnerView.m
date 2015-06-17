//
//  OrderCellInnerView.m
//  Mode
//
//  Created by YedaoDEV on 15/6/6.
//  Copyright (c) 2015年 YedaoDEV. All rights reserved.
//

#import "OrderCellInnerView.h"
#define X(a) a * a
@implementation OrderCellInnerView
-(void)setModeOrder:(ModeOrder *)modeOrder{
    _modeOrder = modeOrder;
}

-(instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}


-(CGFloat) getBoundsByWidth:(CGFloat)width{
    
    return 0;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
