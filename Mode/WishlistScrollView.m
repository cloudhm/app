//
//  WishlistScrollView.m
//  Mode
//
//  Created by huangmin on 15/5/31.
//  Copyright (c) 2015年 YedaoDEV. All rights reserved.
//

#import "WishlistScrollView.h"
#import "ModeGood.h"

#define INTERVIEW_WIDTH 100.f//每个wishlistView的宽度
@implementation WishlistScrollView 

-(instancetype)initWithFrame:(CGRect)frame WithWishlistArr:(NSArray*)wishlistArr{
    self = [super initWithFrame:frame];
    if (self) {
        _wishlists = [wishlistArr mutableCopy];//控制器里把数据库里的数据读取出来  用来创建scrollView
//        self.backgroundColor = [UIColor yellowColor];
        self.bounces = NO;
        _wishlistViews = [NSMutableArray array];
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
    __block NSUInteger index = [self.wishlistViews indexOfObject:wishlistView];
    
    //if Tap is not selected Tab(new Tab)
    if (self.activeIndex != index) {
        // Select the tab
        [self selectAtIndex:index];
        
    }
}
//设置下标
- (void)selectAtIndex:(NSUInteger)index {
    if (index >= self.wishlists.count) {
        return;
    }
    // Set activeTabIndex
    self.activeIndex = index;
    ModeGood* modeGood = self.wishlists[self.activeIndex];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"selectGood_id" object:nil userInfo:@{@"goods_id":modeGood.goods_id}];
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
    
    if (index >= self.wishlistViews.count) {
        return nil;
    }
    return [self.wishlistViews objectAtIndex:index];
}

//添加子视图
-(void)addInnerView {
    float totalWidth = 5.f;
    BOOL withoutBtn = (self.wishlists.count==9)?YES:NO;
    for (ModeGood*modeGood in _wishlists) {
        WishlistView* wishlistView = [[WishlistView alloc]initWithFrame:CGRectMake(totalWidth, 0, INTERVIEW_WIDTH, CGRectGetHeight(self.bounds)) andModeGood:modeGood andWithoutBtn:withoutBtn];
        [self addSubview:wishlistView];
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        [wishlistView addGestureRecognizer:tapGestureRecognizer];
        totalWidth += (INTERVIEW_WIDTH +5.f);
        [_wishlistViews addObject:wishlistView];
    }
    self.contentSize = CGSizeMake(totalWidth, 0);
}

//当有内容更新时 刷新子视图
-(void)layoutSubviews{
    [super layoutSubviews];
    float newContentWidth = 5.f;
    for (int i = 0 ;i<self.wishlistViews.count ; i++) {
        WishlistView* wishlistView = self.wishlistViews[i];
        CGRect frame = wishlistView.frame;
        frame.origin.x = (i+1) * 5.f + i*INTERVIEW_WIDTH;
        newContentWidth += (5.f+ INTERVIEW_WIDTH);
        [UIView animateWithDuration:0.5 animations:^{
            wishlistView.frame = frame;
        } completion:nil];
    }
    self.contentSize = CGSizeMake(newContentWidth, 0);
    if (self.wishlistViews.count>0) {
        if (self.activeIndex<self.wishlistViews.count) {
            [self setActiveIndex:self.activeIndex];
        } else {
            [self setActiveIndex:--self.activeIndex];
        }
    }
}


@end
