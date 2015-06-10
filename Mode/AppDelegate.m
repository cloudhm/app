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
#import <FBSDKCoreKit/FBSDKCoreKit.h>

static NSString * const kJVDrawersStoryboardName = @"Main";

static NSString * const kJVLeftDrawerStoryboardID = @"JVLeftDrawerTableViewController";


@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize drawersStoryboard = _drawersStoryboard;

//该方法暂时作为直接启动的显示页，以后需要在登录后实现跳转时要改写  注意：configureDrawerViewController 这个方法需要注意 今后如何调用
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    if (![[NSUserDefaults standardUserDefaults]boolForKey:@"notFirstTime"]) {
        self.window.rootViewController = [self.drawersStoryboard instantiateViewControllerWithIdentifier:@"ModeIntroduceViewController"];
    } else {
        self.window.rootViewController = [self.drawersStoryboard instantiateViewControllerWithIdentifier:@"LaunchViewController"];
    }
    
//    self.window.rootViewController = self.drawerViewController;
//    [self configureDrawerViewController];
    
    [self.window makeKeyAndVisible];
    
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                           didFinishLaunchingWithOptions:launchOptions];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [FBSDKAppEvents activateApp];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
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
//-(UITableViewController *)profileViewController{
//    if (!_profileViewController) {
//        _profileViewController = [self.drawersStoryboard instantiateViewControllerWithIdentifier:@"pvc"];
//    }
//    return _profileViewController;
//}
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
-(UITableViewController *)brandRunwayViewController{
    if (!_brandRunwayViewController) {
        _brandRunwayViewController = [self.drawersStoryboard instantiateViewControllerWithIdentifier:@"BrandRunwayNavigationController"];
    }
    return _brandRunwayViewController;
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
