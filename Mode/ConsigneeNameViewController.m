//
//  ConsigneeNameViewController.m
//  Mode
//
//  Created by YedaoDEV on 15/6/23.
//  Copyright (c) 2015年 YedaoDEV. All rights reserved.
//

#import "ConsigneeNameViewController.h"

@interface ConsigneeNameViewController ()
@property (weak, nonatomic) IBOutlet UITextField *consigneeName;

@end

@implementation ConsigneeNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)confirmInput:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(consigneeNameViewController:comfirmInputConsigneeName:)]) {
        [self.delegate consigneeNameViewController:self comfirmInputConsigneeName:self.consigneeName.text];
    }
}

- (IBAction)cancelInput:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(dismissconsigneeNameViewController:)]) {
        [self.delegate dismissconsigneeNameViewController:self];
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
