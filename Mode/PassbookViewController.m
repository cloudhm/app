//
//  PassbookViewController.m
//  Mode
//
//  Created by YedaoDEV on 15/6/6.
//  Copyright (c) 2015年 YedaoDEV. All rights reserved.
//

#import "PassbookViewController.h"
#import "AppDelegate.h"
#import "ConvertTime.h"
#import "PassbookTableViewCell.h"
#import "WebViewViewController.h"
#import "OrderConfirmViewController.h"
#import "UIViewController+CWPopup.h"
#import "UIColor+HexString.h"

#import "WishListViewController.h"
@interface PassbookViewController ()<UITableViewDataSource,UITableViewDelegate,OrderConfirmViewControllerDelegate>
@property (strong, nonatomic) NSMutableArray* timeArr;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) CADisplayLink *gameTimer;
@property (strong, nonatomic) OrderConfirmViewController *orderConfirmViewController;
@end

@implementation PassbookViewController
- (BOOL)prefersStatusBarHidden
{
    return NO;
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
-(void)dealloc{
    NSLog(@"passbook dealloc");
}
-(void)viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"gotoWishlistController" object:nil];
}
//设置CADisplayLink 并加入事件循环
-(void)viewDidAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"gotoWishlistController" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(gotoWishlistController:) name:@"gotoWishlistController" object:nil];
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"gotoWishlistController"]) {
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"gotoWishlistController"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        WishListViewController*wlvc = [[AppDelegate globalDelegate].drawersStoryboard instantiateViewControllerWithIdentifier:@"WishListViewController"];
        [self.navigationController pushViewController:wlvc animated:YES];
    }
    if (!self.gameTimer) {
        self.gameTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateDisplay:)];
        self.gameTimer.frameInterval = 60.f;//该控件默认1分钟刷新60次，设置为60 则1秒钟刷新1次
        [self.gameTimer addToRunLoop:[NSRunLoop currentRunLoop]forMode:NSDefaultRunLoopMode];
    }
}
-(void)gotoWishlistController:(NSNotification*)noti{
    if ([[noti.userInfo objectForKey:@"currentViewController"] isKindOfClass:[self.parentViewController class]]
        && (![[noti.userInfo objectForKey:@"count"]isEqualToString:@"0"])) {
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"gotoWishlistController"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    } else {
        UIAlertView* av = [[UIAlertView alloc]initWithTitle:@"Caution" message:@"Please choose some your liked fashion goods first" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        NSLog(@"passbook");
        [av show];
    }
}
-(NSMutableArray *)timeArr{
    if (!_timeArr) {
        _timeArr = [NSMutableArray array];
    }
    return _timeArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Passbook";
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue" size:20],NSForegroundColorAttributeName:[UIColor whiteColor]};
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:@"#1b1b1b"];
    
    self.tableView.backgroundColor = [UIColor clearColor];//使tableView变透明背景
    
#warning 虚拟数据从plist文件中倒入
    NSString* filePath = [[NSBundle mainBundle]pathForResource:@"times" ofType:@"plist"];
    self.timeArr = [[NSArray arrayWithContentsOfFile:filePath]mutableCopy];
 
    [self.tableView registerNib:[UINib nibWithNibName:@"PassbookTableViewCell" bundle:nil] forCellReuseIdentifier:@"MyCell"];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
//CADisplayLink刷新数据
-(void)updateDisplay:(CADisplayLink*)caDisplayLink{
    for (int i = 0; i<self.timeArr.count; i++) {
        NSNumber* timeNum = self.timeArr[i];
        NSInteger newTime = timeNum.integerValue - 1;
        timeNum = [NSNumber numberWithInteger:newTime];
    }
    [self.tableView reloadData];
}
//定义左上角的按钮  可以用ICViewPager  方便测试
- (IBAction)actionToggleLeftDrawer:(UIBarButtonItem *)sender {
    [[AppDelegate globalDelegate] toggleLeftDrawer:self animated:YES];
}




#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.timeArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PassbookTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"PassbookTableViewCell" owner:nil options:nil]lastObject];

    }
    
    cell.timeDic = [ConvertTime convertLastTimeByTimeInterval:self.timeArr[indexPath.row]];
    
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 220.f;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderConfirmViewController* orderConfirmViewController = [[OrderConfirmViewController alloc]initWithNibName:@"OrderConfirmViewController" bundle:nil];
    orderConfirmViewController.delegate = self;
    [self presentPopupViewController:orderConfirmViewController animated:YES completion:nil];
    
#warning 这个是跳准时传递的数据 暂时写死为www.baidu.com
    NSString* website = @"http://www.baidu.com";
    [self performSegueWithIdentifier:@"gotoWebViewViewController" sender:website];
}
#pragma mark OrderConfirmViewControllerDelegate
-(void)dismissOrderConfirmViewController:(OrderConfirmViewController *)orderConfirmViewController{
    [self dismissPopupViewControllerAnimated:YES completion:nil];
}
-(void)orderConfirmViewController:(OrderConfirmViewController *)orderConfirmViewController editFinishWithName:(NSString *)name andZipCode:(NSString *)zipcode beginAnimation:(UIActivityIndicatorView *)activityView{
#warning 这个方法是发送信息给服务器端
    [activityView startAnimating];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [NSThread sleepForTimeInterval:5.f];
        dispatch_async(dispatch_get_main_queue(), ^{
            [activityView stopAnimating];
            [self dismissOrderConfirmViewController:orderConfirmViewController];
        });
    });
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    WebViewViewController* webView = segue.destinationViewController;
    webView.website = sender;
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
