//
//  BrandIntroduceTableViewController.m
//  Mode
//
//  Created by YedaoDEV on 15/5/26.
//  Copyright (c) 2015年 YedaoDEV. All rights reserved.
//

#import "BrandRunwayTableViewController.h"
#import "BrandIntroduceHeaderView.h"
#import "AppDelegate.h"
#import "ModeBrandRunwayAPI.h"
#import "ModeBrandRunway.h"
#import "BrandRunwayTableViewCell.h"
@interface BrandRunwayTableViewController ()


@property (strong, nonatomic) UIToolbar *toolbar;
@property (strong, nonatomic) UIButton *toolbarBtn;
@property (strong, nonatomic) UILabel *toolbarLabel;
@property (assign, nonatomic) CGPoint lastScrollOffset;
@property (strong, nonatomic) NSMutableArray *brandRunwayList;
@property (strong, nonatomic) ModeBrandRunway *brandRunway;

@end

@implementation BrandRunwayTableViewController
- (BOOL)prefersStatusBarHidden
{
    return NO;
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
-(BrandInfo *)brandInfo{
    if (!_brandInfo) {
        _brandInfo = [[BrandInfo alloc]init];
        _brandInfo.brandIntroduce = @"BEIJING - The capsized Eastern Star cruise ship will be moved to allow divers to search for victims at the site.With eight victims still missing, the search and rescue headquarters will move the ship as soon as weather and water movements are favorable, Minister of Transport Yang Chuantang said Monday.\"A glimmer of hope deserves all-out efforts,\" he said.Ministry sources said on Saturday the search for the missing victims would be extended for nearly 1,300 km along the Yangtze River between Jianli in Hubei Province, where the ship sank, downstream to the Wusong Estuary in Shanghai.The Eastern Star with 456 people onboard was on an 11-day trip along the Yangtze when it was overturned by a tornado last Monday night.Fourteen people survived the disaster. As of Monday, rescuers had retrieved the bodies of 434 victims.";
    }
    return _brandInfo;
}

-(NSMutableArray *)brandRunwayList{
    if (!_brandRunwayList) {
        _brandRunwayList = [NSMutableArray array];
    }
    return _brandRunwayList;
}
//定义左上角的按钮  可以用ICViewPager  方便测试
- (IBAction)actionToggleLeftDrawer:(UIBarButtonItem *)sender {
    [[AppDelegate globalDelegate] toggleLeftDrawer:self animated:YES];
}

//开始加载数据
- (void)viewDidLoad {
    [super viewDidLoad];
    //设置状态栏为白色字体
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    
    [self initHeaderView];
    [self initNavigationBar];
//    //偏移量初始化，用来判断表向上或向下移动
//    self.lastScrollOffset = CGPointZero;
    [self updateRunwayList];
    [self createToolbar];
}
-(void)updateRunwayList{
    [ModeBrandRunwayAPI requestBrandRunwayListByBrandName:nil AndCallback:^(id obj) {
        if (![obj isKindOfClass:[NSNull class]]) {
            [self.brandRunwayList removeAllObjects];
            [self.brandRunwayList addObjectsFromArray:obj];
            
            [self.tableView reloadData];
        }
    }];
}
-(void)viewWillAppear:(BOOL)animated{
    
}
-(void)viewDidAppear:(BOOL)animated{
    
}
#pragma mark InitUI
-(void)initHeaderView{
    CGRect frame = [UIScreen mainScreen].applicationFrame;
    //设置表头视图
    BrandIntroduceHeaderView*headerView = (BrandIntroduceHeaderView*)self.tableView.tableHeaderView;
    headerView.brandInfo = self.brandInfo;
    frame = headerView.frame;
    frame.size.height = [self.brandInfo getBrandDetailHeigthtByWidth:(self.tableView.frame.size.width - 20.f)] + 137.f;
    self.tableView.tableHeaderView.frame = frame;
}
-(void)initNavigationBar{
    //导航栏设置
    self.tableView.showsVerticalScrollIndicator = NO;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:20/255.f green:21/255.f blue:20/255.f alpha:1];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
}
#pragma mark TableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"%d",self.brandRunwayList.count);
    NSLog(@"%@",self.brandRunwayList);
    return self.brandRunwayList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BrandRunwayTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.brandRunway = self.brandRunwayList[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 226;
}

#pragma mark addToolbar
-(void)createToolbar{
    
    self.toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, self.navigationController.view.bounds.size.height, self.view.bounds.size.width, 50)];
    UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width/2-70.f, 40.f)];//添加的
    self.toolbarBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.bounds.size.width/2-45.f, 5.f, 40.f, 40.f)];
    [self.toolbarBtn setImage:[UIImage imageNamed:@"_hollow.png"] forState:UIControlStateNormal];
    [self.toolbarBtn setImage:[UIImage imageNamed:@"_solid.png"] forState:UIControlStateSelected];
    self.toolbarBtn.backgroundColor = [UIColor clearColor];
    [self.toolbarBtn addTarget:self action:@selector(like:) forControlEvents:UIControlEventTouchUpInside];
    
    self.toolbarLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.bounds.size.width/2+5.f, 5, 100, 40)];
    self.toolbarLabel.font = [UIFont systemFontOfSize:20];
    self.toolbarLabel.textAlignment = NSTextAlignmentLeft;
    self.toolbarLabel.textColor = [UIColor redColor];
    self.toolbarLabel.text = @"1001";
    UIBarButtonItem* otherv =[[UIBarButtonItem alloc]initWithCustomView:v];
    UIBarButtonItem* btn = [[UIBarButtonItem alloc]initWithCustomView:self.toolbarBtn];
    UIBarButtonItem* l = [[UIBarButtonItem alloc]initWithCustomView:self.toolbarLabel];
    self.toolbar.items = @[otherv,btn,l];
    CGRect rect = self.toolbar.frame;
    rect.origin.y -= 50.f;
    self.toolbar.frame = rect;
    [self.navigationController.view addSubview:self.toolbar];

}

-(void)like:(UIButton*)btn{
    [btn setSelected:!btn.selected];
    NSInteger i = self.toolbarLabel.text.integerValue;
    if (btn.selected) {
        self.toolbarLabel.text = [NSString stringWithFormat:@"%ld",++i];
    } else {
        self.toolbarLabel.text = [NSString stringWithFormat:@"%ld",--i];
    }
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
