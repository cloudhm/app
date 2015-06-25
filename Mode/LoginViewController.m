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
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

#import "TAlertView.h"

@interface LoginViewController ()<RegisterViewDelegate,LoginViewDelegate,UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *backgroundView;
@property (strong, nonatomic) LoginView *lvc;
@property (strong, nonatomic) RegisterView *rvc;
@property (weak, nonatomic) AppDelegate *delegate;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, strong) NSString *userID;
@property(nonatomic,retain) UITableView *tableView;







@end



@implementation LoginViewController
{
    NSIndexPath *_currentIndexPath;

}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



-(void)viewDidAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changePosition:) name:UIKeyboardWillChangeFrameNotification object:nil];
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    
    if ([ud objectForKey:@"token"]) {//token存在则确定是否在有效期内
        NSTimeInterval utime  = [ud doubleForKey:@"utime"];
        NSTimeInterval currentTime = [NSDate date].timeIntervalSince1970;
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

#pragma mark - Actions

- (IBAction)showLogin:(UIStoryboardSegue *)segue
{
    // This method exists in order to create an unwind segue to this controller.
}

#pragma mark - FBSDKLoginButtonDelegate


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:214/255.f green:214/255.f  blue:214/255.f  alpha:1];

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


- (IBAction)gotoFacebook:(FBSDKLoginButton *)sender {
    

    [self loginFB];
    
    
}
- (void)loginFB
{

    //登录 添加参数 允许获取好友信息
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
      login.loginBehavior = FBSDKLoginBehaviorWeb;
    //获取授权
    [login logInWithReadPermissions:@[@"user_friends",@"email"]
                            handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                             NSLog(@"用户信息 111:%@", result.token);
                                NSLog(@"%@",result.token.tokenString);
                                
                                        NSLog(@"---%@",result.grantedPermissions);
                                BOOL isHaveEmail =[result.grantedPermissions containsObject:@"email"];
                                
                                
                                if (result.token) {
                                                [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil]
                                                 startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                                                     
                                                      NSLog(@"用户信息2" );
                                                     if (error) {
                                                          NSLog(@"%@",error);
                                                        
                                    
                                                     }else{
                                                          NSLog(@"用户信息:%@", result);
                                                         _userID = result[@"id"];
                                                         if (_userID) {
                                                             
                                                             if (isHaveEmail) {
                                                                 NSLog(@"haha");
                                                                 [self fetchEmail];
                                                                 
                                                             }
                                                         }
                                                     }
                                                 }];
                                            }
                                if ([result.grantedPermissions containsObject:@"user_friends"]) {
                                    [self fetchData];
            
                                }else {
                                    [self dismissViewControllerAnimated:YES completion:NULL];
                                }
                            }];

}
//
- (void)fetchEmail
{

    //        初始化请求
 
    NSString *string = [NSString stringWithFormat:@"%@",_userID];
    
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                  initWithGraphPath:string
                                  parameters:@{@"fields":@"email"}];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                          id result,
                                          NSError *error) {
        
        if (!error) {
            NSLog(@"fetched email:%@", result);
            
        }else{
            NSLog(@"%@",error);
        }

    }];

   

}
//获取好友列表
- (void)fetchData
{
    
//        初始化请求
    
         FBSDKGraphRequest* request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me/taggable_friends?limit=100"
                                                       parameters:@{ @"fields" : @"id,name,picture.width(100).height(100)"
                                                                     }];
    
    
    //    发送请求
    
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        if (error) {
            NSLog(@"Picker loading error:%@", error);
            if (!error.userInfo[FBSDKErrorLocalizedDescriptionKey]) {
                [[[UIAlertView alloc] initWithTitle:@"Oops"
                                            message:@"There was a problem fetching the list"
                                           delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil] show];
            }
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            
            //请求成功
            
            NSArray *friendArray =  [NSArray arrayWithArray:result[@"data"]] ;
           
            NSLog(@"好友数量_______%ld",friendArray.count);
            
        }
    }];
}





- (IBAction)showLoginView:(UIButton *)sender {
#warning 暂时跳过此阶段
    [[NSUserDefaults standardUserDefaults]setObject:@"362" forKey:@"userId"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [self enterHostView];
    
    
    return;
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
        NSMutableDictionary* params = [attributes mutableCopy];
        [params removeObjectForKey:@"error"];
        [self.view bringSubviewToFront:self.activityIndicatorView];
        [self.activityIndicatorView startAnimating];
        [ModeAccountAPI signupWithParams:params andCallback:^(id obj) {
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
        NSMutableDictionary* params = [attributes mutableCopy];
        [params removeObjectForKey:@"error"];
        [self.view bringSubviewToFront:self.activityIndicatorView];
        [self.activityIndicatorView startAnimating];
        [ModeAccountAPI loginWithParams:params andCallback:^(id obj) {
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
//        [[AppDelegate globalDelegate]configureDrawerViewController];
        [AppDelegate globalDelegate].window.rootViewController = jvc;
    }) ;
}

-(void)viewWillAppear:(BOOL)animated{
    [AppDelegate globalDelegate].drawerViewController = nil;
    [AppDelegate globalDelegate].leftDrawerViewController = nil;
    [AppDelegate globalDelegate].homeViewController = nil;
    [AppDelegate globalDelegate].drawerAnimator = nil;

}


@end
