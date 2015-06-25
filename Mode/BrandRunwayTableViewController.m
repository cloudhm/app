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
#import "BrandRunwayTableViewCell.h"
#import "UIColor+HexString.h"
#import "LikeOrNopeViewController.h"
#import "TAlertView.h"

@interface BrandRunwayTableViewController ()


@property (strong, nonatomic) UIToolbar *toolbar;
@property (strong, nonatomic) UIButton *toolbarBtn;
@property (strong, nonatomic) UILabel *toolbarLabel;
@property (assign, nonatomic) CGPoint lastScrollOffset;
@property (strong, nonatomic) NSMutableArray *brandRunwayList;
@property (strong, nonatomic) BrandInfo *brandInfo;
@end

@implementation BrandRunwayTableViewController
#pragma mark ShowAlertView
-(void)showAlertViewWithCautionInfo:(NSString*)cautionInfo{
    TAlertView *alert = [[TAlertView alloc] initWithTitle:cautionInfo andMessage:nil];
    alert.alertBackgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.8];
    alert.titleFont = [UIFont fontWithName:@"Baskerville-SemiBoldItalic" size:14];
    [alert setTitleColor:[UIColor whiteColor] forAlertViewStyle:TAlertViewStyleInformation];
    alert.tapToClose = NO;
    alert.timeToClose = 1.f;
    alert.buttonsAlign = TAlertViewButtonsAlignHorizontal;
    alert.style = TAlertViewStyleInformation;
    [alert showAsMessage];
}
//-(BrandInfo *)brandInfo{
//    if (!_brandInfo) {
//        _brandInfo = [[BrandInfo alloc]init];
//        _brandInfo.brandDescription = @"BEIJING - The capsized Eastern Star cruise ship will be moved to allow divers to search for victims at the site.With eight victims still missing, the search and rescue headquarters will move the ship as soon as weather and water movements are favorable, Minister of Transport Yang Chuantang said Monday.\"A glimmer of hope deserves all-out efforts,\" he said.Ministry sources said on Saturday the search for the missing victims would be extended for nearly 1,300 km along the Yangtze River between Jianli in Hubei Province, where the ship sank, downstream to the Wusong Estuary in Shanghai.The Eastern Star with 456 people onboard was on an 11-day trip along the Yangtze when it was overturned by a tornado last Monday night.Fourteen people survived the disaster. As of Monday, rescuers had retrieved the bodies of 434 victims.";
//    }
//    return _brandInfo;
//}

-(NSMutableArray *)brandRunwayList{
    if (!_brandRunwayList) {
        _brandRunwayList = [NSMutableArray array];
    }
    return _brandRunwayList;
}


//开始加载数据
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:@"#1b1b1b"];
    //设置状态栏为白色字体
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
    self.tableView.showsVerticalScrollIndicator = NO;
    [self initHeaderView];
//    [self initNavigationBar];
//    //偏移量初始化，用来判断表向上或向下移动
//    self.lastScrollOffset = CGPointZero;
    [self getBrandInfo];
    [self createToolbar];
    UIBarButtonItem* barItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(comeback:)];
    self.navigationItem.leftBarButtonItem = barItem;

    
    [ModeBrandRunwayAPI requestBrandListOfUserFellowAndCallback:^(id obj) {
        NSLog(@"%@",obj);
    }];
    

}
#pragma mark navigationItem.leftBarButtonItem Action
-(void)comeback:(UIBarButtonItem*)btn{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
-(void)getBrandInfo{

    [ModeBrandRunwayAPI requestBrandInfoByBrandId:self.brandId andCallback:^(id obj) {

        if ([obj isKindOfClass:[NSNull class]]) {
            [self showAlertViewWithCautionInfo:@"Try refresh it again."];
        } else {
            self.brandInfo = obj;
            self.toolbarLabel.text = [NSString stringWithFormat:@"%ld",(long)self.brandInfo.likes.integerValue];
            [self.tableView reloadData];
        }
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    
}
-(void)viewDidAppear:(BOOL)animated{
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [self.toolbar removeFromSuperview];
    self.toolbar = nil;
}
-(void)viewDidDisappear:(BOOL)animated{
    
}
#pragma mark InitUI
-(void)initHeaderView{
    CGRect frame = [UIScreen mainScreen].applicationFrame;
    //设置表头视图
    BrandIntroduceHeaderView*headerView = (BrandIntroduceHeaderView*)self.tableView.tableHeaderView;
    headerView.brandInfo = self.brandInfo;
    frame = headerView.frame;
    frame.size.height = [self.brandInfo getBrandDetailHeigthtByWidth:(self.tableView.frame.size.width - 40.f)] + 137.f;
    self.tableView.tableHeaderView.frame = frame;
}
-(void)setBrandInfo:(BrandInfo *)brandInfo{
    _brandInfo = brandInfo;
    [self initHeaderView];
    self.title = self.brandInfo.brandName;
}

#pragma mark TableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.brandRunwayList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BrandRunwayTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 226;
}

#pragma mark addToolbar
-(void)createToolbar{
    
    self.toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, self.navigationController.view.bounds.size.height, self.view.bounds.size.width, 50)];
    UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width/2-70.f, 40.f)];//添加的
    self.toolbarBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.bounds.size.width/2-30.f, 5.f, 40.f, 40.f)];
    [self.toolbarBtn setImage:[UIImage imageNamed:@"_hollow.png"] forState:UIControlStateNormal];
    [self.toolbarBtn setImage:[UIImage imageNamed:@"_solid.png"] forState:UIControlStateSelected];
    self.toolbarBtn.backgroundColor = [UIColor clearColor];
    [self.toolbarBtn addTarget:self action:@selector(like:) forControlEvents:UIControlEventTouchUpInside];
    
    self.toolbarLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.bounds.size.width/2+10.f, 5, 100, 40)];
    self.toolbarLabel.font = [UIFont systemFontOfSize:20];
    self.toolbarLabel.textAlignment = NSTextAlignmentCenter;
    self.toolbarLabel.textColor = [UIColor redColor];
    self.toolbarLabel.text = @"0";
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
        i++;
        self.toolbarLabel.text = [NSString stringWithFormat:@"%d",i];
    } else {
        i--;
        self.toolbarLabel.text = [NSString stringWithFormat:@"%d",i];
    }
    NSString* likeNope = (btn.selected == YES?@"true":@"false");
    [ModeBrandRunwayAPI setBrandFeedbackWithParams:@{@"brandId":self.brandId,@"like":likeNope} andCallback:^(id obj) {
        //do nothing here.
    }];
}

#pragma mark UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"brandRunwayToLikeNope" sender:@{@"title":@"aaaa",@"intro_desc":@"bbbbb",@"intro_title":@"ccccccc",@"params":@{@"mode":@"style",@"mode_val":@"dddd"}}];
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    LikeOrNopeViewController* ln=[segue destinationViewController];
    ln.receiveArr = sender;
}


@end
