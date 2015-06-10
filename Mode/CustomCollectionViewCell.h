//
//  CustomCollectionViewCell.h
//  Mode
//
//  Created by huangmin on 15/5/28.
//  Copyright (c) 2015年 YedaoDEV. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic)  UIImageView *bgImageView;
@property (weak, nonatomic)  UILabel *name;
@property (nonatomic,weak) UIButton* button;
-(void)click:(UIButton*)btn;
@end
