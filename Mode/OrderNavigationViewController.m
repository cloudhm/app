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
-(void)viewDidAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"gotoWishlistController" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(gotoWishlistController:) name:@"gotoWishlistController" object:nil];
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"gotoWishlistController"]) {
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"gotoWishlistController"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        WishListViewController*wlvc = [[AppDelegate globalDelegate].drawersStoryboard instantiateViewControllerWithIdentifier:@"WishListViewController"];
        [self pushViewController:wlvc animated:YES];
    }
}
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
    NSLog(@"%@",NSStringFromCGRect(self.view.frame));
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
