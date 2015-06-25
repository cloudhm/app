//
//  BrandIntroduceHeaderView.m
//  Mode
//
//  Created by YedaoDEV on 15/5/26.
//  Copyright (c) 2015年 YedaoDEV. All rights reserved.
//

#import "BrandIntroduceHeaderView.h"
#import "UIImageView+WebCache.h"
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
    l1.numberOfLines = 0;
    [self addSubview:l1];
    self.brandDetail = l1;
    
    UILabel* l2 = [[UILabel alloc]init];
    l2.textAlignment = NSTextAlignmentCenter;
    l2.font = [UIFont fontWithName:@"Verdana" size:17];
    [self addSubview: l2];
    self.brandStyle = l2;
    
    UIView* v = [[UIView alloc]init];
//    v.backgroundColor = [UIColor colorWithRed:75/255.f green:75/255.f blue:75/255.f alpha:1];
    v.backgroundColor = [UIColor blackColor];
    [self addSubview: v];
    self.bottomLine = v;
}

-(void)setBrandInfo:(BrandInfo *)brandInfo{
    _brandInfo = brandInfo;
//    self.brandDetail.text = _brandInfo.brandDescription;
    [self layoutSubviews];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    CGRect currentDeviceFrame = [UIScreen mainScreen].applicationFrame;
    float padding = 10.f;
    float brandIVW = 60.f;
    float brandIVH = 60.f;
    float brandIVX = (CGRectGetWidth(currentDeviceFrame) - brandIVW)/2;
    float brandIVY = 10.f;
    self.brandImageView.frame = CGRectMake(brandIVX, brandIVY, brandIVW, brandIVH);
    self.brandImageView.layer.cornerRadius = CGRectGetWidth(self.brandImageView.bounds)/2;
    self.brandImageView.layer.borderWidth = 1.f;
    self.brandImageView.layer.borderColor = [UIColor lightGrayColor].CGColor;

    self.brandImageView.layer.masksToBounds = YES;

    [self.brandImageView sd_setImageWithURL:[NSURL URLWithString:self.brandInfo.brandLogo] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [[SDImageCache sharedImageCache]storeImage:image forKey:[self.brandInfo.brandLogo lastPathComponent] toDisk:YES];
    }];
    
    float brandDetailW = CGRectGetWidth(currentDeviceFrame) - 4 * padding;
    float brandDetailH = [self.brandInfo getBrandDetailHeigthtByWidth:brandDetailW];
    float brandDetailX = padding*2;
    float brandDetailY = CGRectGetMaxY(self.brandImageView.frame) + padding;
    if (self.brandInfo.brandDescription) {
        NSMutableAttributedString* attributedStr = [[NSMutableAttributedString alloc]initWithString:self.brandInfo.brandDescription];
        NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        [paragraphStyle setLineSpacing:2.f];
        [attributedStr setAttributes:@{NSParagraphStyleAttributeName:paragraphStyle,NSFontAttributeName:[UIFont fontWithName:@"TimesNewRomanPS-ItalicMT" size:14],NSForegroundColorAttributeName:[UIColor colorWithRed:74/255.f green:74/255.f blue:74/255.f alpha:1]} range:NSMakeRange(0,[self.brandInfo.brandDescription length])];
        [self.brandDetail setAttributedText:attributedStr];
        self.brandDetail.textAlignment = NSTextAlignmentCenter;
    }
    self.brandDetail.frame = CGRectMake(brandDetailX, brandDetailY, brandDetailW, brandDetailH+10);
#warning 以下两个控件如果brandInfo-runwayItems为空或0  则不显示
    float brandStyleX = 0;
    float brandStyleY = CGRectGetMaxY(self.brandDetail.frame) + padding;
    float brandStyleW = CGRectGetWidth(currentDeviceFrame);
    float brandStyleH = 20;
    self.brandStyle.frame = CGRectMake(brandStyleX, brandStyleY, brandStyleW, brandStyleH);
    self.brandStyle.text = @"Runway";
    
    float bottomLineW = 40.f;
    float bottomLineH = 1.f;
    float bottomLineY = CGRectGetMaxY(self.brandStyle.frame) + 1.5 * padding;
    float bottomLineX = (CGRectGetWidth(currentDeviceFrame) - bottomLineW)/2;
    self.bottomLine.frame = CGRectMake(bottomLineX, bottomLineY, bottomLineW, bottomLineH);
}
-(CGFloat)getTotalHeight{
//    if () {
//        <#statements#>
//    }
    return CGRectGetMaxY(self.bottomLine.frame);
}
@end
