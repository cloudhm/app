//
//  AppDelegate.h
//  Mode
//
//  Created by YedaoDEV on 15/5/22.
//  Copyright (c) 2015年 YedaoDEV. All rights reserved.
//

#import <UIKit/UIKit.h>



@class JVFloatingDrawerViewController;//分栏控制器
@class JVFloatingDrawerSpringAnimator;//主页面
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

//抽屉视图控制器及弹簧动画
@property (nonatomic, strong) JVFloatingDrawerViewController *drawerViewController;
@property (nonatomic, strong) JVFloatingDrawerSpringAnimator *drawerAnimator;

//视图控制器（在实现里用懒加载）
@property (nonatomic, strong) UITableViewController *leftDrawerViewController;
@property (nonatomic, strong) UIViewController *homeViewController;
//@property (nonatomic, strong) UITableViewController *profileViewController;
@property (strong, nonatomic) UITableViewController *brandRunwayViewController;
@property (strong, nonatomic) UIViewController *wishlistViewController;
@property (strong, nonatomic) UITableViewController *wishlistTableViewController;
@property (strong, nonatomic) UIViewController *passbookViewController;
@property (nonatomic,strong) UIViewController* launchViewController;
@property (nonatomic, strong, readonly) UIStoryboard *drawersStoryboard;
@property (strong, nonatomic) UIViewController *orderViewController;
// ModeDelegate 的单例
+ (AppDelegate *)globalDelegate;

//实现该方法  可以展示左边抽屉视图
- (void)toggleLeftDrawer:(id)sender animated:(BOOL)animated;
//配置抽屉控制器
-(void)configureDrawerViewController;
@end

