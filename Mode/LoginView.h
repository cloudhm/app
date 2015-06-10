//
//  LoginView.h
//  Mode
//
//  Created by YedaoDEV on 15/5/22.
//  Copyright (c) 2015年 YedaoDEV. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LoginView;
@protocol LoginViewDelegate <NSObject>

@optional
-(void)loginView:(LoginView*)loginView withAttributes:(NSDictionary*)attributes;

@end
@interface LoginView : UIView
@property (weak, nonatomic) id <LoginViewDelegate> delegate;
@end
