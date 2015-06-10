//
//  RegisterView.h
//  Mode
//
//  Created by YedaoDEV on 15/5/22.
//  Copyright (c) 2015年 YedaoDEV. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RegisterView;
@protocol RegisterViewDelegate <NSObject>

@optional
-(void)registerView:(RegisterView*)registerView withAttributes:(NSDictionary*)attributes;

@end
@interface RegisterView : UIView
@property (weak, nonatomic) id <RegisterViewDelegate>delegate;
@end
