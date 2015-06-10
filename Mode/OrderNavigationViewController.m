//
//  OrderNavigationViewController.m
//  Mode
//
//  Created by huangmin on 15/6/9.
//  Copyright (c) 2015年 YedaoDEV. All rights reserved.
//

#import "OrderNavigationViewController.h"
#import "AppDelegate.h"
#import "WishListViewController.h"
@interface OrderNavigationViewController ()

@end

@implementation OrderNavigationViewController

-(void)viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"gotoWishlistController" object:nil];
}
-(void)viewDidAppear:(BOOL)animated{//设置观察者  防止重复设置多个相同的观察者  每次页面显示先清除
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"gotoWishlistController" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(gotoWishlistController:) name:@"gotoWishlistController" object:nil];
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"gotoWishlistController"]) {
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"gotoWishlistController"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        WishListViewController*wlvc = [[AppDelegate globalDelegate].drawersStoryboard instantiateViewControllerWithIdentifier:@"WishListViewController"];
        [self pushViewController:wlvc animated:YES];
    }
}
//收到跳转通知 判断wishlist中有数据  就跳过去  没有就弹出alertView提醒用户先去做likeOrNope评测
-(void)gotoWishlistController:(NSNotification*)noti{
    if ([[noti.userInfo objectForKey:@"currentViewController"] isKindOfClass:[OrderNavigationViewController class]]
        &&(![[noti.userInfo objectForKey:@"count"]isEqualToString:@"0"])) {
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"gotoWishlistController"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    } else {
        UIAlertView* av = [[UIAlertView alloc]initWithTitle:@"Caution" message:@"Please choose some your liked fashion goods first" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        NSLog(@"order");
        [av show];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
}


@end
