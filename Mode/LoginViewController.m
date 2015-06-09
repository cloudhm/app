//
//  LoginViewController.m
//  Mode
//
//  Created by YedaoDEV on 15/5/22.
//  Copyright (c) 2015年 YedaoDEV. All rights reserved.
//
#define LOGINVIEWFRAME CGRectMake (0, self.view.bounds.size.height,self.view.bounds.size.width,210)
#define REGISTERVIEWFRAME CGRectMake (0, self.view.bounds.size.height,self.view.bounds.size.width,260)
#import "LoginViewController.h"
#import "LoginView.h"
#import "RegisterView.h"
#import "AppDelegate.h"
#import "ModeAccountAPI.h"
#import "JVFloatingDrawerViewController.h"
@interface LoginViewController ()<RegisterViewDelegate,LoginViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *backgroundView;
@property (strong, nonatomic) LoginView *lvc;
@property (strong, nonatomic) RegisterView *rvc;
@property (weak, nonatomic) AppDelegate *delegate;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;

@end

@implementation LoginViewController
#warning 暂时无法隐藏状态栏
-(BOOL)prefersStatusBarHidden{
    return YES;
}
-(void)viewDidAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changePosition:) name:UIKeyboardWillChangeFrameNotification object:nil];
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"token"]) {
        [self.activityIndicatorView startAnimating];
        [NSThread sleepForTimeInterval:3.f];
        [self enterHostView];
    }
}
-(void)viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:214/255.f green:214/255.f  blue:214/255.f  alpha:1];
    
}
-(void)click{
    NSLog(@"...");
}
-(void)changePosition:(NSNotification*)noti {
    NSDictionary *dic = noti.userInfo;
    float t = [[dic objectForKey:UIKeyboardAnimationDurationUserInfoKey]floatValue];
    CGRect endPosition = [[dic objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue];
    if (self.lvc != nil) {
        CGRect frame = self.lvc.frame;
        float del = endPosition.origin.y - CGRectGetHeight(LOGINVIEWFRAME);
        frame.origin.y = del;
        [UIView animateWithDuration:t animations:^{
            self.lvc.frame = frame;
        }];
    }
    if (self.rvc != nil) {
        CGRect frame = self.rvc.frame;
        float del = endPosition.origin.y - CGRectGetHeight(REGISTERVIEWFRAME);
        frame.origin.y = del;
        [UIView animateWithDuration:t animations:^{
            self.rvc.frame = frame;
        }];
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)gotoFacebook:(UIButton *)sender {
    NSLog(@"1");
    
}
#warning 登录接口暂时未开放
- (IBAction)showLoginView:(UIButton *)sender {
    NSLog(@"2");
    if (self.lvc == nil) {
        self.lvc = [[LoginView alloc]init];
        self.lvc.delegate = self;
        CGRect frame = LOGINVIEWFRAME;
        self.lvc.frame = frame;
        [self.view addSubview: self.lvc];
        frame.origin.y -= CGRectGetHeight(self.lvc.frame);
        [UIView animateWithDuration:.5 animations:^{
            self.lvc.frame = frame;
        } completion:nil];
    }
    
}
- (IBAction)showRegisterView:(UIButton *)sender {
    if (self.rvc == nil) {
        self.rvc = [[RegisterView alloc]init];
        self.rvc.delegate = self;
        CGRect frame = REGISTERVIEWFRAME;
        self.rvc.frame = frame;
        [self.view addSubview: self.rvc];
        frame.origin.y -= CGRectGetHeight(self.rvc.frame);
        [UIView animateWithDuration:.5 animations:^{
            self.rvc.frame = frame;
        } completion:nil];
    }
}
#pragma mark Remove subView like LoginView and RegisterView
-(void)removeView:(UIView*)view{
    CGRect frame = view.frame;
    frame.origin.y += CGRectGetHeight(view.frame);
    [UIView animateWithDuration:.5f animations:^{
        view.frame = frame;
    } completion:^(BOOL finished) {
        [view removeFromSuperview];
    }];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if (self.lvc != nil && CGRectGetMaxY(self.lvc.frame)+10.f >= self.view.bounds.size.height ) {
        [self removeView:self.lvc];
        self.lvc = nil;
    }else if (self.lvc != nil && self.lvc.frame.origin.y<self.view.bounds.size.height) {
        [self.view endEditing:YES];
    }
    if (self.rvc != nil && CGRectGetMaxY(self.rvc.frame)+10.f >= self.view.bounds.size.height ) {
        [self removeView:self.rvc];
        self.rvc = nil;
    }else if (self.rvc != nil && self.rvc.frame.origin.y<self.view.bounds.size.height) {
        [self.view endEditing:YES];
    }
}

#pragma mark RegisterViewDelegate
-(void)registerView:(RegisterView *)registerView withAttributes:(NSDictionary *)attributes{
    [self.view bringSubviewToFront:self.activityIndicatorView];
    [self.activityIndicatorView startAnimating];
    [ModeAccountAPI signupWithParams:attributes andCallback:^(id obj) {
        if (![obj isKindOfClass:[NSNull class]]) {
            [self.activityIndicatorView stopAnimating];
            NSString* token = [obj objectForKey:@"token"];
            NSNumber* user_id = [obj objectForKey:@"user_id"];
            NSString* utime = [obj objectForKey:@"utime"];
            NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
            [ud setObject:token forKey:@"token"];
            [ud setObject:user_id forKey:@"user_id"];
            [ud setObject:utime forKey:@"token_utime"];
            [ud synchronize];
            [NSThread sleepForTimeInterval:2.f];
            [self enterHostView];
            
            
        } else {
#warning 这里要根据错误error信息来判断提示用户出现什么类型的错误
            [self.activityIndicatorView stopAnimating];
            UILabel* label = [[UILabel alloc]init];
            label.bounds = CGRectMake(0, 0, 150, 30);
            label.text = @"请检查网络／已有相同账号";
            label.alpha = 0.f;
            label.textColor = [UIColor redColor];
            [self.view addSubview: label];
            [UIView animateWithDuration:.5f animations:^{
                label.alpha = 1.f;
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:.5f animations:^{
                    label.alpha = 0.f;
                } completion:^(BOOL finished) {
                    [label removeFromSuperview];
                }];
            }];
            
        }
        
    }];
}
-(void)enterHostView{
    dispatch_async(dispatch_get_main_queue(), ^{
        JVFloatingDrawerViewController*jvc =[AppDelegate globalDelegate].drawerViewController;
        [[AppDelegate globalDelegate]configureDrawerViewController];
        [AppDelegate globalDelegate].window.rootViewController = jvc;
    }) ;
}
-(void)dealloc{
    
    
    NSLog(@"loginVc dealloc");
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
