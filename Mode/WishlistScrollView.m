//
//  WishlistScrollView.m
//  Mode
//
//  Created by huangmin on 15/5/31.
//  Copyright (c) 2015年 YedaoDEV. All rights reserved.
//

#import "WishlistScrollView.h"
//#import "ModeGood.h"
#import "GoodItem.h"
//#define INTERVIEW_WIDTH 100.f//每个wishlistView的宽度
@implementation WishlistScrollView

-(instancetype)initWithFrame:(CGRect)frame WithWishlistArr:(NSArray*)wishlistArr{
    self = [super initWithFrame:frame];
    if (self) {
        _goodItems = [wishlistArr mutableCopy];//控制器里把数据库里的数据读取出来  用来创建scrollView
//        self.backgroundColor = [UIColor yellowColor];
        self.bounces = NO;
        _goodeItemViews = [NSMutableArray array];
        self.showsHorizontalScrollIndicator = NO;
        [self addInnerView];
        [self selectAtIndex:0];
    }
    return self;
}
//tap手势触发事件
#pragma mark - IBAction
- (IBAction)handleTapGesture:(id)sender {
    
    // Get the desired page's index
    UITapGestureRecognizer *tapGestureRecognizer = (UITapGestureRecognizer *)sender;
    WishlistView *wishlistView = (WishlistView*)tapGestureRecognizer.view;
    __block NSUInteger index = [self.goodeItemViews indexOfObject:wishlistView];
    
    //if Tap is not selected Tab(new Tab)
    if (self.activeIndex != index) {
        // Select the tab
        [self selectAtIndex:index];
        
    }
}
//设置下标
- (void)selectAtIndex:(NSUInteger)index {
    if (index >= self.goodItems.count) {
        return;
    }
    // Set activeTabIndex
    self.activeIndex = index;
    if ([self.myDelegate respondsToSelector:@selector(wishlistScrollView:didSelectedItemsAtIndex:)]) {
        [self.myDelegate wishlistScrollView:self didSelectedItemsAtIndex:self.activeIndex];
    }
}
//切换激活的下标
- (void)setActiveIndex:(int)activeIndex {
    
    WishlistView *activeView;
    // Set to-be-inactive tab unselected
    activeView = [self wishlistViewAtIndex:self.activeIndex];
    
    activeView.selected = NO;
    
    // Set to-be-active tab selected
    activeView = [self wishlistViewAtIndex:activeIndex];
  
    activeView.selected = YES;
    
    // Set current activeTabIndex
    _activeIndex = activeIndex;
    
}
//根据下标返回wishlistView
- (WishlistView *)wishlistViewAtIndex:(NSUInteger)index {
    
    if (index >= self.goodeItemViews.count) {
        return nil;
    }
    return [self.goodeItemViews objectAtIndex:index];
}

//添加子视图
-(void)addInnerView {
    float totalWidth = 5.f;
    BOOL withoutBtn = (self.goodItems.count==9)?YES:NO;
    for (GoodItem* goodItem in _goodItems) {
        WishlistView* wishlistView = [[WishlistView alloc]initWithFrame:CGRectMake(totalWidth, 0, CGRectGetHeight(self.bounds)*3/4, CGRectGetHeight(self.bounds)) andGoodItem:goodItem andWithoutBtn:withoutBtn];
        [self addSubview:wishlistView];
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        [wishlistView addGestureRecognizer:tapGestureRecognizer];
        totalWidth += (CGRectGetHeight(self.bounds)*3/4 +5.f);
        [_goodeItemViews addObject:wishlistView];
    }
    self.contentSize = CGSizeMake(totalWidth, 0);
}

//当有内容更新时 刷新子视图
-(void)layoutSubviews{
    [super layoutSubviews];
    float newContentWidth = 5.f;
    for (int i = 0 ;i<self.goodeItemViews.count ; i++) {
        WishlistView* wishlistView = self.goodeItemViews[i];
        CGRect frame = wishlistView.frame;
        frame.origin.x = (i+1) * 5.f + i*CGRectGetHeight(self.bounds)*3/4;
        newContentWidth += (5.f+ CGRectGetHeight(self.bounds)*3/4);
        [UIView animateWithDuration:0.5 animations:^{
            wishlistView.frame = frame;
        } completion:nil];
    }
    self.contentSize = CGSizeMake(newContentWidth, 0);
    if (self.goodeItemViews.count>0) {
        if (self.activeIndex<self.goodeItemViews.count) {
            [self setActiveIndex:self.activeIndex];
        } else {
            [self setActiveIndex:--self.activeIndex];
        }
    }
}


@end
