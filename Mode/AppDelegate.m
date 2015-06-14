//
//  AppDelegate.m
//  Mode
//
//  Created by YedaoDEV on 15/5/22.
//  Copyright (c) 2015年 YedaoDEV. All rights reserved.
//

#import "AppDelegate.h"
#import <JVFloatingDrawer/JVFloatingDrawerViewController.h>
#import <JVFloatingDrawer/JVFloatingDrawerSpringAnimator.h>

static NSString * const kJVDrawersStoryboardName = @"Main";

static NSString * const kJVLeftDrawerStoryboardID = @"JVLeftDrawerTableViewController";


@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize drawersStoryboard = _drawersStoryboard;

//该方法暂时作为直接启动的显示页，以后需要在登录后实现跳转时要改写  注意：configureDrawerViewController 这个方法需要注意 今后如何调用
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    if (![[NSUserDefaults standardUserDefaults]boolForKey:@"notFirstTime"]) {
        self.window.rootViewController = [self.drawersStoryboard instantiateViewControllerWithIdentifier:@"ModeIntroduceViewController"];
    } else {
        self.window.rootViewController = [self.drawersStoryboard instantiateViewControllerWithIdentifier:@"LaunchViewController"];
    }
    [self.window makeKeyAndVisible];
    return YES;
}

#pragma mark - Drawer View Controllers

- (JVFloatingDrawerViewController *)drawerViewController {
    if (!_drawerViewController) {
        _drawerViewController = [[JVFloatingDrawerViewController alloc] init];
        
    }
    
    return _drawerViewController;
}

#pragma mark Sides

- (UITableViewController *)leftDrawerViewController {
    if (!_leftDrawerViewController) {
        _leftDrawerViewController = [self.drawersStoryboard instantiateViewControllerWithIdentifier:kJVLeftDrawerStoryboardID];
    }
    
    return _leftDrawerViewController;
}

- (UIStoryboard *)drawersStoryboard {
    if(!_drawersStoryboard) {
        _drawersStoryboard = [UIStoryboard storyboardWithName:kJVDrawersStoryboardName bundle:nil];
    }
    return _drawersStoryboard;
}

#pragma mark Center

- (UIViewController *)homeViewController {
    if (!_homeViewController) {
        _homeViewController = [self.drawersStoryboard instantiateViewControllerWithIdentifier:@"HomeNavigationController"];
    }
    return _homeViewController;
}

-(UIViewController *)wishlistViewController{
    if (!_wishlistViewController) {
        _wishlistViewController = [self.drawersStoryboard instantiateViewControllerWithIdentifier:@"WishlistViewController"];
    }
    return _wishlistViewController;
}
-(UITableViewController *)wishlistTableViewController{
    if (!_wishlistTableViewController) {
        _wishlistTableViewController = [self.drawersStoryboard instantiateViewControllerWithIdentifier:@"WishlistNavigationController"];
    }
    return _wishlistTableViewController;
}

-(UIViewController *)passbookViewController{
    if (!_passbookViewController) {
        _passbookViewController = [self.drawersStoryboard instantiateViewControllerWithIdentifier:@"PassbookNavigationController"];
    }
    return _passbookViewController;
}
-(UIViewController *)orderViewController{
    if (!_orderViewController) {
        _orderViewController = [self.drawersStoryboard instantiateViewControllerWithIdentifier:@"OrderNavigationController"];
    }
    return _orderViewController;
}
- (JVFloatingDrawerSpringAnimator *)drawerAnimator {
    if (!_drawerAnimator) {
        _drawerAnimator = [[JVFloatingDrawerSpringAnimator alloc] init];
    }
    
    return _drawerAnimator;
}
-(UIViewController *)settingViewController{
    if (!_settingViewController) {
        _settingViewController = [self.drawersStoryboard instantiateViewControllerWithIdentifier:@"SettingNavigationController"];
    }
    return _settingViewController;
}
-(UIViewController *)feedbackViewController{
    if (!_feedbackViewController) {
        _feedbackViewController = [self.drawersStoryboard instantiateViewControllerWithIdentifier:@"FeedbackNavigationController"];
    }
    return _feedbackViewController;
}

//配置抽屉控制器
- (void)configureDrawerViewController {
    self.drawerViewController.leftViewController = self.leftDrawerViewController;
    self.drawerViewController.centerViewController = self.homeViewController;
    self.drawerViewController.animator = self.drawerAnimator;
    self.drawerViewController.backgroundImage = [UIImage imageNamed:@"sky"];
}

#pragma mark - Global Access Helper

+ (AppDelegate *)globalDelegate {
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (void)toggleLeftDrawer:(id)sender animated:(BOOL)animated {
    [self.drawerViewController toggleDrawerWithSide:JVFloatingDrawerSideLeft animated:animated completion:nil];
}


@end
