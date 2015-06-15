//
//  LoginView.m
//  Mode
//
//  Created by YedaoDEV on 15/5/22.
//  Copyright (c) 2015年 YedaoDEV. All rights reserved.
//

#import "LoginView.h"
@interface LoginView()
@property (weak, nonatomic) UIImageView* bgImageView;
@property (weak, nonatomic) UILabel* label;
@property (weak, nonatomic) UIImageView *iv1;
@property (weak, nonatomic) UIImageView *iv2;
@property (weak, nonatomic) UITextField *tf1;
@property (weak, nonatomic) UITextField *tf2;
@property (weak, nonatomic) UIButton *btn;
@end
@implementation LoginView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        UIImageView* bgIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"secret_page.png"]];
        self.bgImageView = bgIV;
        [self addSubview:bgIV];
        
        UILabel *l = [[UILabel alloc]init];
        l.textColor = [UIColor blackColor];
        l.textAlignment = NSTextAlignmentCenter;
        l.font = [UIFont fontWithName:@"Verdana" size:21.f];
        l.text = @"WELCOME BACK";
        self.label = l;
        [self addSubview:self.label];
        
        UIImageView *firstIV = [[UIImageView alloc]init];
        firstIV.image = [UIImage imageNamed:@"new_secret_email.png"];
        self.iv1 = firstIV;
        [self addSubview:self.iv1];
        
        UIImageView *secondIV = [[UIImageView alloc]init];
        secondIV.image = [UIImage imageNamed:@"new_secret_password.png"];
        self.iv2 = secondIV;
        [self addSubview:self.iv2];
        
        UITextField *firstTF = [[UITextField alloc]init];
        firstTF.font = [UIFont systemFontOfSize:16.f];
        firstTF.borderStyle = UITextBorderStyleNone;
        firstTF.placeholder = @"JOIN WITH EMAIL";
        [firstTF setValue:[UIFont fontWithName:@"Helvetica" size:16.f] forKeyPath:@"_placeholderLabel.font"];
        firstTF.clearsOnBeginEditing = YES;
        firstTF.returnKeyType=UIReturnKeyNext;
        self.tf1 = firstTF;
        [self addSubview:self.tf1];
        
        UITextField *secondTF = [[UITextField alloc]init];
        secondTF.secureTextEntry = YES;
        secondTF.placeholder = @"PASSWORD";
        secondTF.font = [UIFont systemFontOfSize:16.f];
        secondTF.borderStyle = UITextBorderStyleNone;
        [secondTF setValue:[UIFont fontWithName:@"Helvetica" size:16.f] forKeyPath:@"_placeholderLabel.font"];
        secondTF.clearsOnBeginEditing = YES;
        secondTF.returnKeyType=UIReturnKeyDone;
        self.tf2 = secondTF;
        [self addSubview: self.tf2];
        
        UIButton *b = [[UIButton alloc]init];
        [b setImage:[UIImage imageNamed:@"old_secret_login_normal.png"] forState:UIControlStateNormal];
        [b setImage:[UIImage imageNamed:@"old_secret_login_press.png"] forState:UIControlStateHighlighted];
        [b addTarget:self action:@selector(sendDelegateMethod) forControlEvents:UIControlEventTouchUpInside];
        self.btn = b;
        [self addSubview:self.btn];
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.bgImageView.frame = self.bounds;
    
    float toppadding = 10.f;
    self.label.frame = CGRectMake(0, toppadding, self.bounds.size.width, 20.f);
    float padding = 10.f;
    float ivX = 55.f;
    float ivH = 40.f;
    self.iv1.frame = CGRectMake(ivX, CGRectGetMaxY(self.label.frame) + 20.f, self.bounds.size.width - 2 * ivX, ivH);
    self.iv2.frame = CGRectMake(ivX, CGRectGetMaxY(self.iv1.frame) + padding, self.iv1.bounds.size.width, ivH);
    self.btn.frame = CGRectMake(ivX+5.f, CGRectGetMaxY(self.iv2.frame) + padding, self.iv2.frame.size.width-15.f, ivH);
    
    
    self.tf1.frame = CGRectMake(ivX + 50.f, CGRectGetMinY(self.iv1.frame) + 2.5f, self.iv1.frame.size.width - 50.f - 10.f, 35.f);
    self.tf2.frame = CGRectMake(ivX + 50.f, CGRectGetMinY(self.iv2.frame) + 2.5f, self.iv2.frame.size.width - 50.f - 10.f, 35.f);
    
}
-(void)sendDelegateMethod{
    if ((![self.tf1.text isEqualToString:@""])&&
        (![self.tf1.text isEqualToString:@"JOIN WITH EMAIL"])&&
        (![self.tf2.text isEqualToString:@""])&&
        [self.delegate respondsToSelector:@selector(loginView:withAttributes:)]) {
        [self.delegate loginView:self withAttributes:@{@"username":self.tf1.text,@"password":self.tf2.text}];
    }
}
@end
