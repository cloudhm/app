//
//  CashView.m
//  Mode
//
//  Created by YedaoDEV on 15/6/11.
//  Copyright (c) 2015年 YedaoDEV. All rights reserved.
//

#import "CashView.h"
@interface CashView()
@property (weak, nonatomic) UILabel *addOrDel;
@property (weak, nonatomic) UILabel *currency;
@property (weak, nonatomic) UILabel *num;

@end
@implementation CashView
-(instancetype)init{
    self = [super init];
    if (self) {
        
        self.backgroundColor = [UIColor yellowColor];
        
        UILabel* l1 = [[UILabel alloc]init];
        l1.font = [UIFont systemFontOfSize:40];
        self.addOrDel = l1;
        [self addSubview:l1];
        
        UILabel* l2 = [[UILabel alloc]init];
        l2.font = [UIFont systemFontOfSize:40];
        self.currency = l2;
        [self addSubview:l2];
        
        UILabel* l3 = [[UILabel alloc]init];
        l3.font = [UIFont systemFontOfSize:90];
        l3.textAlignment = NSTextAlignmentLeft;
        l3.backgroundColor = [UIColor grayColor];
        self.num = l3;
        [self addSubview:l3];
    }
    return self;
}
-(void)setCashNumStr:(NSString *)cashNumStr{
    _cashNumStr = cashNumStr;
    [self layoutSubviews];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.currency.text = @"$";
    if (self.cashNumStr.floatValue>=0) {
        
        self.addOrDel.text = @"+";
        self.addOrDel.textColor = [UIColor greenColor];
        self.currency.textColor = [UIColor greenColor];
        self.num.textColor = [UIColor greenColor];
        
    } else {
        self.addOrDel.text = @"-";
        self.addOrDel.textColor = [UIColor redColor];
        self.currency.textColor = [UIColor redColor];
        self.num.textColor = [UIColor redColor];
    }
    self.addOrDel.frame = CGRectMake(15, 10, 40, 40);
    self.num.text = [NSString stringWithFormat:@"%.0f",self.cashNumStr.floatValue>0?self.cashNumStr.floatValue:(self.cashNumStr.floatValue*(-1))];
    CGSize numSize = [self.num.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:90]}];
    self.num.frame = CGRectMake(CGRectGetWidth(self.bounds)-5.f - numSize.width, 10.f, numSize.width, 100.f);
    CGPoint selfCenter = self.center;
    self.num.center = CGPointMake(self.num.center.x, selfCenter.y);
    self.currency.frame = CGRectMake(CGRectGetMinX(self.num.frame)-35.f, CGRectGetMinY(self.num.frame)+5.f, 30, 40);
    
    selfCenter.y -= 10.f;
    self.currency.center = CGPointMake(self.currency.center.x, selfCenter.y);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
