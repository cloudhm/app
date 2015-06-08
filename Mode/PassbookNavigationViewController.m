//
//  PassbookNavigationViewController.m
//  Mode
//
//  Created by huangmin on 15/6/9.
//  Copyright (c) 2015年 YedaoDEV. All rights reserved.
//

#import "PassbookNavigationViewController.h"
#import "WishListViewController.h"
#import "AppDelegate.h"
@interface PassbookNavigationViewController ()

@end

@implementation PassbookNavigationViewController
-(void)viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"gotoWishlistController" object:nil];
}
-(void)viewDidAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(gotoWishlistController:) name:@"gotoWishlistController" object:nil];
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"gotoWishlistController"]) {
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"gotoWishlistController"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        WishListViewController*wlvc = [[AppDelegate globalDelegate].drawersStoryboard instantiateViewControllerWithIdentifier:@"WishListViewController"];
        [self pushViewController:wlvc animated:YES];
    }
}
-(void)gotoWishlistController:(NSNotification*)noti{
    if ([[noti.userInfo objectForKey:@"currentViewController"] isKindOfClass:[PassbookNavigationViewController class]]) {
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"gotoWishlistController"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationBar.barTintColor = [UIColor colorWithRed:20/255.f green:21/255.f blue:20/255.f alpha:1];
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
