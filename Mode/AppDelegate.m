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

#import <AdSupport/AdSupport.h>
#import <StoreKit/StoreKit.h>



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
    

    
    // flurry 统计接口对接
    [Flurry startSession:@"YHN5SMSMQTNTNKB54MHS"];
    

    // appsflyer 实现应用用户跟踪
    // 获得APPid必须先去apple developer上的iTunes connect 添加一个新的应用 然后获取它的id 测试用
    [AppsFlyerTracker sharedTracker].appleAppID = @"1012183628";
    
    [AppsFlyerTracker sharedTracker].appsFlyerDevKey = @"SBmwGxPPexfY2Y7wHaGz2g";
    
    // 获取广告标示符
        NSString *IDFA = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
        NSLog(@"%@",IDFA);
    
    // 设置货币代码
    [AppsFlyerTracker sharedTracker].currencyCode = @"";
    
    // 设置自定义用户id(高级)
    [AppsFlyerTracker sharedTracker].customerUserID = @"";
    
    //设置 HTTP (高级)
    // AppsFlyer SDK 通过 HTTPS 与其服务器沟通。如果您选择禁止 HTTPS(不建议),您可以设置 isHTTPS 属性 至 NO。默认值为 YES:。
    [AppsFlyerTracker sharedTracker].isHTTPS = YES;
    
    //获得 AppsFlyer 专有设备 ID。AppsFlyer 设备 ID 是报告和 API 中 AppsFlyer 使用的主要 ID
    NSString *appsFlyerID = [[AppsFlyerTracker sharedTracker] getAppsFlyerUID];
    NSLog(@"appsFlyerID is %@",appsFlyerID);
    
    //    AppsFlyer 为您提供一种从 AppsFlyer 分析选择排除特定用户的方法。
    //    该方法满足最新的隐私要求,并符合 Facebook 数据和隐私政策。
    //     默认是否(NO),是指默认情况下启用跟踪。
    [AppsFlyerTracker sharedTracker].deviceTrackingDisabled = YES;
    
    //    只有您的项目中存在AdSupport.framework库时,AF SDK才会收集IDFA。不需要明确选择进入或退出。然而,
    //    如果您想明确选择排除 IDFA,在第 5 节中的 SDK 初始化期间,请使用以下 API:
    //除非另有指示,不建议使用。
    //     [AppsFlyerTracker sharedTracker].disableAppleAdSupportTracking = YES;
    
    //    在测试情况下,我们建议设置 useReceiptValidationSandbox 标记至 YES,由于这将重新将请求导入至 Apple 沙箱服务器(Apple sandbox servers)。
    [AppsFlyerTracker sharedTracker].useReceiptValidationSandbox = YES;
    
    //AppsFlyer SDK 可以提供应用内购买服务器验证。设定购买收据验证,您需要调用 SKstoreKit 的 completeTransaction:callback 中的 validateAndTrackInAppPurchase 方法。该调用将自动产生“af_purchase” 应用内事件
//    [[AppsFlyerTracker sharedTracker] validateAndTrackInAppPurchase:@"" eventNameIfFailed:@"" withValue:@"" withProduct:@"" price:nil currency:@"" success:^(NSDictionary *response) {
//        
//    } failure:^(NSError *error, id reponse) {
//        
//    }];
//    

    
    

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
    
    
    // load the conversion data
    [AppsFlyerTracker sharedTracker].delegate = self;
    
    // track launch 这个 API 可以启用 AppsFlyer,从而检测到安装、会话(应用程序打开)和更新
    // 安装事件(启用跟踪的最低要求 – 强制)
    [[AppsFlyerTracker sharedTracker] trackAppLaunch];
    
}

//跟踪忠实用户如何发现您的应用程序并将它们归因于特定的活动/来源
//- eventName 是定义事件名称的任何字符串。您可以在附录 A 中查看推荐常用事件名称列表。
//- values 是含有富事件的时间参数库。您可以在附录 A 中查看推荐参数列表。
- (void) trackEvent:(NSString *)eventName withValues:(NSDictionary*)values{
    
    //示例 1: 单一产品的“添加至购物车”(af_add_to_cart)值为 9.99 USD,content_id “234234” 且类型为 “category_a”:
    [[AppsFlyerTracker sharedTracker] trackEvent:AFEventAddToCart withValues:@{
                                                                               AFEventParamPrice: @9.99,
                                                                               AFEventParamContentType : @"category_a",
                                                                               AFEventParamContentId: @"234234",
                                                                               AFEventParamCurrency : @"USD",
                                                                               AFEventParamQuantity : @1
                                                                               }];
    
}






#pragma mark - appsflyer 实现应用用户跟踪
-(void)onConversionDataReceived:(NSDictionary*) installData {
    
    id status = [installData objectForKey:@"af_status"];
    
    if([status isEqualToString:@"Non-organic"]) {
        
        id sourceID = [installData objectForKey:@"media_source"];
        
        id campaign = [installData objectForKey:@"campaign"];
        
        NSLog(@"This is a none organic install. Media source: %@  Campaign: %@",sourceID,campaign);
        
    } else if([status isEqualToString:@"Organic"]) {
        
        NSLog(@"This is an organic install.");
        
    }
    
}



-(void)onConversionDataRequestFailure:(NSError *) error {
    
    NSLog(@"%@",error);
    
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
