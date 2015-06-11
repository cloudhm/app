//
//  ViewController.m
//  Mode
//
//  Created by YedaoDEV on 15/5/22.
//  Copyright (c) 2015年 YedaoDEV. All rights reserved.
//

#import "LaunchViewController.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
@interface LaunchViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *backgroundView;
@property (weak, nonatomic) AppDelegate *delegate;
@end

@implementation LaunchViewController

-(void)viewDidDisappear:(BOOL)animated{
    self.backgroundView = nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    self.view.backgroundColor = [UIColor colorWithRed:214/255.f green:214/255.f  blue:214/255.f  alpha:1];
}
-(void)viewWillAppear:(BOOL)animated{
    self.backgroundView.alpha = 0.f;
}

-(void)viewDidAppear:(BOOL)animated{
    [UIView animateWithDuration:2 animations:^{
        self.backgroundView.alpha = 1.f;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1 animations:^{
            self.backgroundView.alpha = 0.f;
        } completion:^(BOOL finished) {
            LoginViewController *lvc = [[AppDelegate globalDelegate].drawersStoryboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
            [AppDelegate globalDelegate].window.rootViewController = lvc;
        }];
    }];
}


@end
