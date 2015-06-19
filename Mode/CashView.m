//
//  CashView.m
//  Mode
//
//  Created by YedaoDEV on 15/6/11.
//  Copyright (c) 2015年 YedaoDEV. All rights reserved.
//

#import "CashView.h"

#import "UIColor+HexString.h"
@interface CashView()
@property (weak, nonatomic) UILabel *addOrDel;
@property (weak, nonatomic) UILabel *currency;
@property (weak, nonatomic) UILabel *num;
@property (weak, nonatomic) UILabel *ctime;
@property (weak, nonatomic) UIImageView *bgIV;
@end
@implementation CashView
-(instancetype)init{
    self = [super init];
    if (self) {
        
        UIImageView* imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cash_big_box.png"]];
        imageView.contentMode = UIViewContentModeScaleToFill;
        imageView.userInteractionEnabled = YES;
        self.bgIV = imageView;
        [self addSubview:imageView];
        
        UILabel* l1 = [[UILabel alloc]init];
        l1.font = [UIFont fontWithName:@"Helvetica" size:20];
        self.addOrDel = l1;
        [self addSubview:l1];
        
        UILabel* l2 = [[UILabel alloc]init];
        l2.font = [UIFont fontWithName:@"Helvetica" size:25];
        self.currency = l2;
        [self addSubview:l2];
        
        UILabel* l3 = [[UILabel alloc]init];
        l3.font = [UIFont fontWithName:@"Helvetica" size:40];
        l3.textAlignment = NSTextAlignmentRight;
        self.num = l3;
        [self addSubview:l3];
        
        UILabel* l4 = [[UILabel alloc]init];
        l4.font = [UIFont fontWithName:@"Helvetica" size:16];
        l4.textAlignment = NSTextAlignmentLeft;
        l4.textColor = [UIColor colorWithHexString:@"#595858"];
        self.ctime = l4;
        [self addSubview:l4];
        
    }
    return self;
}
-(void)setTransaction:(Transaction *)transaction{
    _transaction = transaction;
    [self layoutSubviews];
}
//-(void)setCashNumStr:(NSString *)cashNumStr{
//    _cashNumStr = cashNumStr;
//    [self layoutSubviews];
//}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.bgIV.frame = self.bounds;
    self.currency.text = @"$";
    if (self.transaction.amount.floatValue>=0) {
        
        self.addOrDel.text = @"＋";
        self.addOrDel.textColor = [UIColor colorWithHexString:@"#5a5959"];
        self.currency.textColor = [UIColor colorWithHexString:@"#5a5959"];
        self.num.textColor = [UIColor colorWithHexString:@"#5a5959"];
        
    } else {
        self.addOrDel.text = @"－";
        self.addOrDel.textColor = [UIColor colorWithHexString:@"#e43a71"];
        self.currency.textColor = [UIColor colorWithHexString:@"#e43a71"];
        self.num.textColor = [UIColor colorWithHexString:@"#e43a71"];
    }
    self.addOrDel.frame = CGRectMake(15.f, 0.f, 30.f, 30.f);
    self.num.text = [NSString stringWithFormat:@"%.2f",self.transaction.amount.floatValue>=0?self.transaction.amount.floatValue:(self.transaction.amount.floatValue*(-1))];
    CGSize numSize = [self.num.text sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:40]}];
    self.num.frame = CGRectMake(CGRectGetWidth(self.bounds)-5.f - numSize.width -10.f, 10.f, numSize.width, numSize.height);
    
    
    self.currency.frame = CGRectMake(CGRectGetMinX(self.num.frame)-20.f, CGRectGetMinY(self.num.frame), 30, 40);
    
//    NSString* cStr = [NSString stringWithFormat:@"%02d/%02d/%04d",arc4random()%30+1,arc4random()%12+1,arc4random()%2+2014];
    self.ctime.text = self.transaction.ctimeStr;
    
    
    
    
    self.ctime.frame = CGRectMake(15.f, self.bounds.size.height - 25.f, 100.f, 14.f);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
