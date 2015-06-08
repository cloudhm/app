//
//  WishlistView.h
//  Mode
//
//  Created by huangmin on 15/5/31.
//  Copyright (c) 2015年 YedaoDEV. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ModeGood,WishlistView;

//插入在WishlistScrollView中的视图
@interface WishlistView : UIView
@property (nonatomic, getter = isSelected) BOOL selected;
@property (nonatomic,strong) ModeGood* modeGood;
-(instancetype)initWithFrame:(CGRect)frame andModeGood:(ModeGood*)modeGood andWithoutBtn:(BOOL)withoutBtn;
@end
