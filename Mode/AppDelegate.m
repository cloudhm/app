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
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import "Flurry.h"


static NSString * const kJVDrawersStoryboardName = @"Main";

static NSString * const kJVLeftDrawerStoryboardID = @"JVLeftDrawerTableViewController";


@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize drawersStoryboard = _drawersStoryboard;


//该方法暂时作为直接启动的显示页，以后需要在登录后实现跳转时要改写  注意：configureDrawerViewController 这个方法需要注意 今后如何调用
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Facebook的登录分享
    [FBSDKProfile enableUpdatesOnAccessTokenChange:YES];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    if (![[NSUserDefaults standardUserDefaults]boolForKey:@"notFirstTime"]) {
        self.window.rootViewController = [self.drawersStoryboard instantiateViewControllerWithIdentifier:@"ModeIntroduceViewController"];
    } else {
        self.window.rootViewController = [self.drawersStoryboard instantiateViewControllerWithIdentifier:@"LaunchViewController"];
    }
    
    [self.window makeKeyAndVisible];
    
    // 注册推送
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }  else {
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
    }
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    

//    // 友盟统计接口对接
//    //将startWithAppkey:@"xxxxxxxxxxxxxxx"中的xxxxxxxxxxxxxxx替换为您在友盟后台申请的应用Appkey
//    //将channelId:@"Web" 中的Web 替换为您应用的推广渠道。channelId为nil或@""时，默认会被当作@"App Store"渠道。
//    //数据发送策略包括BATCH（启动时发送）和SEND_INTERVAL（按间隔发送）两种
//    [MobClick startWithAppkey:@"558008cc67e58e9e3b0010e8" reportPolicy:BATCH channelId:@"Web"];
//    
//    //友盟SDK为了兼容Xcode3的工程，默认取的是Build号，如果需要取Xcode4及以上版本的Version，可以使用下面的方法；
//    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
//    [MobClick setAppVersion:version];
//
    
    
    // flurry 统计接口对接
    [Flurry startSession:@"YHN5SMSMQTNTNKB54MHS"];
    
    
    // Facebook的登录分享
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                    didFinishLaunchingWithOptions:launchOptions];
}





 //收到推送通知触发的操作
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    
    NSLog(@"userInfo == %@",userInfo);
    NSString *message = [[userInfo objectForKey:@"aps"]objectForKey:@"alert"];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    [alert show];
    
}

// 注册推送成功返回Token
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"%s__%d__| Token = %@", __FUNCTION__, __LINE__, [[deviceToken description] stringByReplacingOccurrencesOfString:@" " withString:@""]);
    
//    NSLog(@"%@", deviceToken);
}


// 注册通知失败
-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"%s__%d__| ,Error = %@", __FUNCTION__, __LINE__, [error description]);
    
}
// 推送
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [application registerForRemoteNotifications];
}


// Facebook登录
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

// Facebook
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
        [self configureDrawerViewController];
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
        _wishlistViewController = [self.drawersStoryboard instantiateViewControllerWithIdentifier:@"WishlistNavigationController"];
    }
    return _wishlistViewController;
}
-(UITableViewController *)wishlistTableViewController{
    if (!_wishlistTableViewController) {
        _wishlistTableViewController = [self.drawersStoryboard instantiateViewControllerWithIdentifier:@"WishlistTableNavigationController"];
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
