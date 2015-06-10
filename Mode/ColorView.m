//
//  ColorView.m
//  Mode
//
//  Created by YedaoDEV on 15/6/2.
//  Copyright (c) 2015年 YedaoDEV. All rights reserved.
//

#import "ColorView.h"
#import "UIColor+HexString.h"

@interface ColorView()

@property (weak, nonatomic) UILabel *nullLabel;

@end
@implementation ColorView
//初始化时给每个边框加上颜色，如果传入的颜色不为空  即用UIBezierPath描绘中间颜色
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.borderWidth = 1.f;
        self.layer.borderColor = [UIColor colorWithRed:189/255.f green:189/255.f blue:189/255.f alpha:1].CGColor;
        self.backgroundColor = [UIColor whiteColor];
        UILabel* label = [[UILabel alloc]init];
        label.text = @"...";
        
        label.textAlignment = NSTextAlignmentCenter;
        label.adjustsFontSizeToFitWidth = YES;
        label.alpha = 1.f;
        self.nullLabel = label;
        [self addSubview:label];
        
    }
    return self;
}
-(void)setColorStr:(NSString *)colorStr{
    _colorStr = colorStr;
    [self setNeedsLayout];
    [self setNeedsDisplay];
}
-(void)layoutSubviews{
    [super layoutSubviews];
    self.nullLabel.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)/2);
    if ([self.colorStr isEqualToString:@""]) {
        self.nullLabel.alpha = 1.f;
    } else {
        self.nullLabel.alpha = 0.f;
    }
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    if (![self.colorStr isEqualToString:@""]) {
        UIBezierPath * bezierPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(10.f, 10.f) radius:5.f startAngle:0 endAngle:M_PI*2 clockwise:YES];
        [[UIColor colorWithHexString:self.colorStr]setFill];
        [[UIColor colorWithHexString:self.colorStr]setStroke];
        [bezierPath fill];
        [bezierPath stroke];
    }
}


@end
