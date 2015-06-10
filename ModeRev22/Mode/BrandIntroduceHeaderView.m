//
//  BrandIntroduceHeaderView.m
//  Mode
//
//  Created by YedaoDEV on 15/5/26.
//  Copyright (c) 2015年 YedaoDEV. All rights reserved.
//

#import "BrandIntroduceHeaderView.h"
@interface BrandIntroduceHeaderView()

@property (weak, nonatomic) UIImageView*brandImageView;
@property (weak, nonatomic) UILabel *brandDetail;
@property (weak, nonatomic) UILabel *brandStyle;
@property (weak, nonatomic) UIView *bottomLine;
@end
@implementation BrandIntroduceHeaderView
-(void)awakeFromNib{
    self.clipsToBounds = YES;
    UIImageView* iv = [[UIImageView alloc]init];
    self.brandImageView = iv;
    [self addSubview: iv];
    
    UILabel* l1 = [[UILabel alloc]init];
    //        l1.font = [];
    l1.numberOfLines = 0;
    l1.textAlignment = NSTextAlignmentLeft;
    [self addSubview:l1];
    self.brandDetail = l1;
    
    UILabel* l2 = [[UILabel alloc]init];
    l2.textAlignment = NSTextAlignmentCenter;
    [self addSubview: l2];
    self.brandStyle = l2;
    
    UIView* v = [[UIView alloc]init];
    v.backgroundColor = [UIColor colorWithRed:75/255.f green:75/255.f blue:75/255.f alpha:1];
    [self addSubview: v];
    self.bottomLine = v;
}

-(void)setBrandInfo:(BrandInfo *)brandInfo{
    _brandInfo = brandInfo;
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    CGRect currentDeviceFrame = [UIScreen mainScreen].bounds;
    float padding = 10.f;
    float brandIVW = 60.f;
    float brandIVH = 60.f;
    float brandIVX = (CGRectGetWidth(currentDeviceFrame) - brandIVW)/2;
    float brandIVY = 10.f;
    self.brandImageView.frame = CGRectMake(brandIVX, brandIVY, brandIVW, brandIVH);
    self.brandImageView.layer.cornerRadius = CGRectGetWidth(self.brandImageView.bounds)/2;
    self.brandImageView.layer.borderWidth = 2.f;
    self.brandImageView.layer.borderColor = [UIColor blackColor].CGColor;
    
    
    float brandDetailW = CGRectGetWidth(currentDeviceFrame) - 2 * padding;
    
    float brandDetailH = [self.brandInfo getBrandDetailHeigthtByWidth:brandDetailW];
    float brandDetailX = padding;
    float brandDetailY = CGRectGetMaxY(self.brandImageView.frame) + padding;
    self.brandDetail.frame = CGRectMake(brandDetailX, brandDetailY, brandDetailW, brandDetailH+10);
    
    float brandStyleX = 0;
    float brandStyleY = CGRectGetMaxY(self.brandDetail.frame) + padding;
    float brandStyleW = CGRectGetWidth(currentDeviceFrame);
    float brandStyleH = 20;
    self.brandStyle.frame = CGRectMake(brandStyleX, brandStyleY, brandStyleW, brandStyleH);
    
    float bottomLineW = 50.f;
    float bottomLineH = 2.f;
    float bottomLineY = CGRectGetMaxY(self.brandStyle.frame) + 1.5 * padding;
    float bottomLineX = (CGRectGetWidth(currentDeviceFrame) - bottomLineW)/2;
    self.bottomLine.frame = CGRectMake(bottomLineX, bottomLineY, bottomLineW, bottomLineH);
}
-(CGFloat)getTotalHeight{
    return CGRectGetMaxY(self.bottomLine.frame);
}
@end
