//
//  RegisterView.h
//  Mode
//
//  Created by YedaoDEV on 15/5/22.
//  Copyright (c) 2015年 YedaoDEV. All rights reserved.
//

#import <UIKit/UIKit.h>
#define REGISTERVIEWFRAME CGRectMake (0, self.view.bounds.size.height,self.view.bounds.size.width,260)
@class RegisterView;
@protocol RegisterViewDelegate <NSObject>

@optional
-(void)registerView:(RegisterView*)registerView withAttributes:(NSDictionary*)attributes;

@end
@interface RegisterView : UIView
@property (weak, nonatomic) id <RegisterViewDelegate>delegate;
@end
