//
//  OrderConfirmViewController.m
//  Mode
//
//  Created by YedaoDEV on 15/6/8.
//  Copyright (c) 2015年 YedaoDEV. All rights reserved.
//

#import "OrderConfirmViewController.h"

@interface OrderConfirmViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *zipcodeTextField;

@end

@implementation OrderConfirmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)confirm:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(orderConfirmViewController:editFinishWithName:andZipCode:) ]) {
        [self.delegate orderConfirmViewController:self editFinishWithName:self.nameTextField.text andZipCode:self.zipcodeTextField.text];
    }
}
- (IBAction)dismiss:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(dismissOrderConfirmViewController:)]) {
        [self.delegate dismissOrderConfirmViewController:self];
    }
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
