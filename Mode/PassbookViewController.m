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

@interface PassbookViewController ()<UITableViewDataSource,UITabBarDelegate>
@property (strong, nonatomic) NSMutableArray* timeArr;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) CADisplayLink *gameTimer;
@end

@implementation PassbookViewController

-(void)dealloc{
    NSLog(@"passbook dealloc");
}
//-(void)viewDidDisappear:(BOOL)animated{
//    NSLog(@"self.gameTimer remove");
//    [self.gameTimer invalidate];
//}
-(void)viewDidAppear:(BOOL)animated{
    if (!self.gameTimer) {
        self.gameTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateDisplay:)];
        self.gameTimer.frameInterval = 60.f;//该控件默认1分钟刷新60次，设置为60 则1秒钟刷新1次
        [self.gameTimer addToRunLoop:[NSRunLoop currentRunLoop]forMode:NSDefaultRunLoopMode];
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
    self.tableView.backgroundColor = [UIColor clearColor];//使tableView变透明背景
    
    
    
    NSString* filePath = [[NSBundle mainBundle]pathForResource:@"times" ofType:@"plist"];
    self.timeArr = [[NSArray arrayWithContentsOfFile:filePath]mutableCopy];
    
    //    self.gameTimer = [CADisplayLink displayLinkWithTarget:self
    //                                            selector:@selector(updateDisplay:)];
    //    self.gameTimer.frameInterval = 60.f;//该控件默认1分钟刷新60次，设置为60 则1秒钟刷新1次
    //    [self.gameTimer addToRunLoop:[NSRunLoop currentRunLoop]forMode:NSDefaultRunLoopMode];
    [self.tableView registerNib:[UINib nibWithNibName:@"PassbookTableViewCell" bundle:nil] forCellReuseIdentifier:@"MyCell"];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:20/255.f green:21/255.f blue:20/255.f alpha:1];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return 189.f;
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
