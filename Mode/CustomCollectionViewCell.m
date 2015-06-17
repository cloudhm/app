//
//  CustomCollectionViewCell.m
//  Mode
//
//  Created by huangmin on 15/5/28.
//  Copyright (c) 2015年 YedaoDEV. All rights reserved.
//

#import "CustomCollectionViewCell.h"
#import "UIColor+HexString.h"
@implementation CustomCollectionViewCell
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {

       
        float labelH = 20.f;
        float labelW = CGRectGetWidth(frame);
        float labelX = 0;
        float labelY = CGRectGetHeight(frame) - labelH -20.f;
        UILabel *namelabel = [[UILabel alloc]initWithFrame:CGRectMake(labelX,labelY,labelW,labelH)];
        namelabel.textAlignment = NSTextAlignmentCenter;
        namelabel.textColor = [UIColor blackColor];
        namelabel.alpha = 0.9;
        namelabel.font = [UIFont fontWithName:@"Verdana" size:14];
//        namelabel.adjustsFontSizeToFitWidth = YES;
        self.name = namelabel;
        
        [self.contentView addSubview:self.name];

        float btnW = MIN(self.bounds.size.width,self.bounds.size.height-35.f)-20.f;
        float btnH = btnW;
        float btnX = (self.bounds.size.height-30.f)>=self.bounds.size.width?10.f:(self.bounds.size.width-self.bounds.size.height+30.f)/2 +10.f;
        float btnY = 10.f;
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(btnX, btnY, btnW , btnH)];
        [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        self.button = btn;
        self.button.layer.shadowOffset = CGSizeMake(2, 2);
        self.button.layer.shadowColor = [UIColor redColor].CGColor;
        self.button.layer.cornerRadius = CGRectGetWidth(self.button.bounds)/2;
        self.button.layer.borderWidth = 1.f;
        self.button.layer.borderColor = [UIColor colorWithHexString:@"#dbdbdb"].CGColor;
        self.button.layer.masksToBounds = YES;
//        CALayer* imageLayer = [CALayer new];
//        imageLayer.frame = CGRectMake(btnX - 1.f, btnY - 1.f, btnW + 2.f, btnH + 2.f);
//        imageLayer.contents = (id)[UIImage imageNamed:@"homeShadow.png"];
//        [self.button.layer addSublayer:imageLayer];
        
        [self.contentView addSubview:btn];
    }
    return self;
}

-(void)click:(UIButton*)btn{
    
}
@end
