//
//  BrandIntroduceViewController.m
//  Mode
//
//  Created by YedaoDEV on 15/5/26.
//  Copyright (c) 2015年 YedaoDEV. All rights reserved.
//

#import "BrandIntroduceViewController.h"

#import "BrandIntroduceHeaderView.h"
#import "ModeSys.h"
@interface BrandIntroduceViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *brandList;
@end

@implementation BrandIntroduceViewController
-(NSMutableArray *)brandList{
    if (!_brandList) {
        _brandList = [NSMutableArray array];
    }
    return _brandList;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
     if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    CGRect frame = [UIScreen mainScreen].bounds;
    NSLog(@"%@",NSStringFromCGRect(frame));
    UITableView *tv = [[UITableView alloc]initWithFrame:frame style:UITableViewStylePlain];
    tv.delegate = self;
    tv.dataSource = self;
    [self.view addSubview:tv];
    self.tableView = tv;
    
    BrandIntroduceHeaderView* v = [[BrandIntroduceHeaderView alloc]init];
    self.tableView.tableHeaderView = v;
    v.brandInfo = self.brandInfo;
    frame = v.frame;
    frame.size.height = [v.brandInfo getBrandDetailHeigthtWithWidth:(self.tableView.frame.size.width - 20.f)] + 117.f;
    self.tableView.tableHeaderView.frame = frame;
    
    self.tableView.tableHeaderView.backgroundColor = [UIColor redColor];
    self.title = self.brandName;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:20/255.f green:21/255.f blue:20/255.f alpha:1];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
}

#pragma TableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:1 reuseIdentifier:@"cell"];
        cell.textLabel.text = @"Hello";
        cell.detailTextLabel.text = @"Hi";
    }
    return cell;
}


#pragma TableViewDelegate



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
