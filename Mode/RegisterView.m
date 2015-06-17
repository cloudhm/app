//
//  RegisterView.m
//  Mode
//
//  Created by YedaoDEV on 15/5/22.
//  Copyright (c) 2015年 YedaoDEV. All rights reserved.
//

#import "RegisterView.h"
@interface RegisterView()<UITextFieldDelegate>
@property (weak, nonatomic) UIImageView* bgImageView;
@property (weak, nonatomic)   UILabel* label;
@property (weak, nonatomic)  UIImageView *iv1;
@property (weak, nonatomic) UIImageView *iv2;
@property (weak, nonatomic) UIImageView *iv3;
@property (weak, nonatomic) UITextField *tf1;
@property (weak, nonatomic) UITextField *tf2;
@property (weak, nonatomic) UITextField *tf3;
@property (weak, nonatomic) UIButton *btn;
@end
@implementation RegisterView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView* bgIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"new_secret_box.png"]];
        self.bgImageView = bgIV;
        [self addSubview:bgIV];
        
        UILabel *l = [[UILabel alloc]init];
        l.textColor = [UIColor blackColor];
        l.textAlignment = NSTextAlignmentCenter;
        l.font = [UIFont fontWithName:@"Verdana" size:21.f];
        l.text = @"SIGN UP  ";
        self.label = l;
        [self addSubview:self.label];
        
        UIImageView *firstIV = [[UIImageView alloc]init];
        firstIV.image = [UIImage imageNamed:@"new_secret_name.png"];
        self.iv1 = firstIV;
        [self addSubview:self.iv1];
        
        UIImageView *secondIV = [[UIImageView alloc]init];
        secondIV.image = [UIImage imageNamed:@"new_secret_email.png"];
        self.iv2 = secondIV;
        [self addSubview:self.iv2];
        
        UIImageView *thirdIV = [[UIImageView alloc]init];
        thirdIV.image = [UIImage imageNamed:@"new_secret_password.png"];
        self.iv3 = thirdIV;
        [self addSubview:self.iv3];
        
        UITextField *firstTF = [[UITextField alloc]init];
        firstTF.font = [UIFont systemFontOfSize:16];
        firstTF.borderStyle = UITextBorderStyleNone;
        firstTF.placeholder = @"NICK NAME";
        [firstTF setValue:[UIFont fontWithName:@"Helvetica" size:16.f] forKeyPath:@"_placeholderLabel.font"];
        firstTF.clearsOnBeginEditing = NO;
        firstTF.returnKeyType=UIReturnKeyNext;
        self.tf1 = firstTF;
        self.tf1.tag = 1;
        self.tf1.delegate =self;
        [self addSubview:self.tf1];
        
        UITextField *secondTF = [[UITextField alloc]init];
        secondTF.placeholder = @"YOUR EMAIL";
        [secondTF setValue:[UIFont fontWithName:@"Helvetica" size:16.f] forKeyPath:@"_placeholderLabel.font"];
        secondTF.font = [UIFont systemFontOfSize:16];
        secondTF.borderStyle = UITextBorderStyleNone;
        secondTF.clearsOnBeginEditing = NO;
        secondTF.returnKeyType=UIReturnKeyNext;
        self.tf2 = secondTF;
        self.tf2.tag = 2;
        self.tf2.delegate =self;
        [self addSubview: self.tf2];
        
        UITextField *thirdTF = [[UITextField alloc]init];
        thirdTF.secureTextEntry = YES;
        thirdTF.placeholder = @"PASSWORD";
        [thirdTF setValue:[UIFont fontWithName:@"Helvetica" size:16.f] forKeyPath:@"_placeholderLabel.font"];
        thirdTF.font = [UIFont systemFontOfSize:16];
        thirdTF.borderStyle = UITextBorderStyleNone;
        thirdTF.clearsOnBeginEditing = YES;
        thirdTF.returnKeyType=UIReturnKeyDone;
        self.tf3 = thirdTF;
        self.tf3.tag = 3;
        self.tf3.delegate =self;
        [self addSubview: self.tf3];
        
        UIButton *b = [[UIButton alloc]init];
        [b setImage:[UIImage imageNamed:@"new_secret_login_normal.png"] forState:UIControlStateNormal];
        [b setImage:[UIImage imageNamed:@"new_secret_login_press.png"] forState:UIControlStateHighlighted];
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
    self.iv3.frame = CGRectMake(ivX, CGRectGetMaxY(self.iv2.frame) + padding, self.iv2.bounds.size.width, ivH);
    self.btn.frame = CGRectMake(ivX+5.f, CGRectGetMaxY(self.iv3.frame) + padding, self.iv3.frame.size.width-15.f, ivH);
    
    
    self.tf1.frame = CGRectMake(ivX + 50.f, CGRectGetMinY(self.iv1.frame) + 2.5f, self.iv1.frame.size.width - 50.f - 15.f, 35.f);
    self.tf2.frame = CGRectMake(ivX + 50.f, CGRectGetMinY(self.iv2.frame) + 2.5f, self.iv2.frame.size.width - 50.f - 15.f, 35.f);
    self.tf3.frame = CGRectMake(ivX + 50.f, CGRectGetMinY(self.iv3.frame) + 2.5f, self.iv3.frame.size.width - 50.f - 15.f, 35.f);
    
}
#pragma Button target Method
-(void)sendDelegateMethod{
    if ((![self.tf1.text isEqualToString:@""])&&
        (![self.tf1.text isEqualToString:@"NICK NAME"])&&
        (![self.tf2.text isEqualToString:@""])&&
        (![self.tf2.text isEqualToString:@"YOUR EMAIL"])&&
        ([self.tf2.text containsString:@"@"])&&
        (![self.tf3.text isEqualToString:@""])&&
        [self.delegate respondsToSelector:@selector(registerView:withAttributes:)]) {
        [self.delegate registerView:self withAttributes:@{@"nickname":self.tf1.text,@"username":self.tf2.text,@"password":self.tf3.text,@"error":[NSNull null]}];
    } else {
        [self.delegate registerView:self withAttributes:@{@"nickname":@"",@"username":@"",@"password":@"",@"error":@"error"}];
    }
}
#pragma UITextFieldDelegate

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    textField.text = @"";
}
//- (void)textFieldDidEndEditing:(UITextField *)textField{
//    if (textField.tag==1) {
//        [self.tf2 becomeFirstResponder];
//    } else if (textField.tag == 2) {
//        [self.tf3 becomeFirstResponder];
//    }
//}
@end
