//
//  LoginViewController.m
//  Mode
//
//  Created by YedaoDEV on 15/5/22.
//  Copyright (c) 2015年 YedaoDEV. All rights reserved.
//


#import "LoginViewController.h"
#import "LoginView.h"
#import "RegisterView.h"
#import "AppDelegate.h"
#import "ModeAccountAPI.h"
#import "JVFloatingDrawerViewController.h"
#import "TAlertView.h"
@interface LoginViewController ()<RegisterViewDelegate,LoginViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *backgroundView;
@property (strong, nonatomic) LoginView *lvc;
@property (strong, nonatomic) RegisterView *rvc;
@property (weak, nonatomic) AppDelegate *delegate;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;

@end

@implementation LoginViewController

-(void)viewDidAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changePosition:) name:UIKeyboardWillChangeFrameNotification object:nil];
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    
    if ([ud objectForKey:@"token"]) {
        NSInteger utime  = [[ud objectForKey:@"utime"] integerValue];
        NSInteger currentTime = (NSInteger)[NSDate date].timeIntervalSince1970;
        if (utime>=currentTime) {
            self.view.userInteractionEnabled = NO;//如果已有登录记录，则关掉屏幕的交互
            [self.activityIndicatorView startAnimating];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [NSThread sleepForTimeInterval:3.f];
                [self enterHostView];
            });
        } else {
            NSString* errorInfo = @"Please relogin and regrant.";
            [self showAlertViewWithErrorInfo:errorInfo];
        }
        
    }
}
-(void)viewDidDisappear:(BOOL)animated{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
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
    if ([[attributes objectForKey:@"error"]isKindOfClass:[NSNull class]]) {
        [self.view bringSubviewToFront:self.activityIndicatorView];
        [self.activityIndicatorView startAnimating];
        [ModeAccountAPI signupWithParams:attributes andCallback:^(id obj) {
            [self.activityIndicatorView stopAnimating];
            if ([obj isKindOfClass:[NSNull class]]) {//返回空 网络问题
                NSString* errorInfo = @"Net error!Cannot connect host servers.";
                [self showAlertViewWithErrorInfo:errorInfo];
            } else {
                BOOL flag = [obj boolValue];
                if (flag) {//返回yes 成功获得token 并且登陆
                    [self enterHostView];
                } else {//用户名或密码问题
                    NSString* errorInfo = @"Email has exist. Please try it again.";
                    [self showAlertViewWithErrorInfo:errorInfo];
                }
            }
        }];
    } else {
        [self showAlertViewWithErrorInfo:@"Error input."];
    }
    
}
#pragma mark LoginViewDelegate
-(void)loginView:(LoginView *)loginView withAttributes:(NSDictionary *)attributes{
    if ([[attributes objectForKey:@"error"]isKindOfClass:[NSNull class]]) {
        [self.view bringSubviewToFront:self.activityIndicatorView];
        [self.activityIndicatorView startAnimating];
        [ModeAccountAPI loginWithParams:attributes andCallback:^(id obj) {
            [self.activityIndicatorView stopAnimating];
            if ([obj isKindOfClass:[NSNull class]]) {
                NSString* errorInfo = @"Net error!Fail to connect host servers.";
                [self showAlertViewWithErrorInfo:errorInfo];
            } else {
                BOOL flag = [obj boolValue];
                if (flag) {//返回yes 成功获得token 并且登陆
                    [self enterHostView];
                } else {//用户名或密码问题
                    NSString* errorInfo = @"Email or Password error.";
                    [self showAlertViewWithErrorInfo:errorInfo];
                }
            }
        }];
    } else {
        [self showAlertViewWithErrorInfo:@"Error input."];
    }
    
    
    
    
}


#pragma mark ShowAlertView
-(void)showAlertViewWithErrorInfo:(NSString*)errorInfo{
    TAlertView *alert = [[TAlertView alloc] initWithTitle:errorInfo andMessage:nil];
    alert.alertBackgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.8];
    alert.titleFont = [UIFont fontWithName:@"Baskerville-SemiBoldItalic" size:14];
    [alert setTitleColor:[UIColor whiteColor] forAlertViewStyle:TAlertViewStyleInformation];
    alert.tapToClose = NO;
    alert.timeToClose = 1.f;
    alert.buttonsAlign = TAlertViewButtonsAlignHorizontal;
    alert.style = TAlertViewStyleInformation;
    [alert showAsMessage];
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
