//
//  WishlistScrollView.h
//  Mode
//
//  Created by huangmin on 15/5/31.
//  Copyright (c) 2015年 YedaoDEV. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WishlistView.h"
@class WishlistScrollView;
@protocol WishlistScrollViewDelegate <NSObject>

@optional
-(void)wishlistScrollView:(WishlistScrollView*)wishlistScrollView didSelectedItemsAtIndex:(NSInteger)index;
@end
//横向滚动的视图
@interface WishlistScrollView : UIScrollView 
@property (nonatomic,strong) NSMutableArray* goodItems;//数据模型数组
@property (assign, nonatomic) NSInteger activeIndex;//激活的下标位置
@property (strong, nonatomic) WishlistView *currentView;//当前视图
@property (strong, nonatomic) NSMutableArray *goodeItemViews;//wishlistView的集合数组
-(instancetype)initWithFrame:(CGRect)frame WithWishlistArr:(NSArray*)wishlistArr;//初始化

@property (weak, nonatomic) id <WishlistScrollViewDelegate> myDelegate;
@end
