//
//  OrderViewController.m
//  Mode
//
//  Created by YedaoDEV on 15/6/6.
//  Copyright (c) 2015年 YedaoDEV. All rights reserved.
//

#import "OrderViewController.h"
#import "AppDelegate.h"
#import "OrderTableViewCell.h"
#import "UIColor+HexString.h"
@interface OrderViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) NSInteger selectedIndex;
@end

@implementation OrderViewController
- (IBAction)actionToggleLeftDrawer:(UIBarButtonItem *)sender {
    [[AppDelegate globalDelegate] toggleLeftDrawer:self animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [[UIButton appearance] setTitleColor:[UIColor colorWithRed:188/255.f green:218/255.f blue:180/255.f alpha:1] forState:UIControlStateSelected];
    [[UIButton appearance] setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:@"#1b1b1b"];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self.tableView registerNib:[UINib nibWithNibName:@"OrderTableViewCell" bundle:nil] forCellReuseIdentifier:@"MyCell"];
    
    self.selectedIndex = 1;
}
-(void)viewDidAppear:(BOOL)animated{
    UIButton* btn = (UIButton*)[self.view viewWithTag:self.selectedIndex];
    btn.selected = YES;
}
-(void)setSelectedAtIndex:(NSInteger)selectedIndex{
    UIButton* btn = (UIButton*)[self.view viewWithTag:_selectedIndex];
    btn.selected = NO;
    _selectedIndex = selectedIndex;
    btn = (UIButton*)[self.view viewWithTag:_selectedIndex];
    btn.selected = YES;
}
- (IBAction)modifyState:(UIButton *)sender {
    [self setSelectedAtIndex:(NSInteger)sender.tag];
#warning 发出通知来让表格显示需要的内容
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"MyCell"];
    if (cell==nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"OrderTableViewCell" owner:nil options:nil]lastObject];
        
    }
    return cell;
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
