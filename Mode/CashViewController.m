//
//  CashViewController.m
//  Mode
//
//  Created by YedaoDEV on 15/6/11.
//  Copyright (c) 2015年 YedaoDEV. All rights reserved.
//

#import "CashViewController.h"
#import "CashTableViewCell.h"
#import "UIColor+HexString.h"
#import "AppDelegate.h"
#import "Common.h"
#import "ModeTransactionsAPI.h"
#import "QBArrowRefreshControl.h"
#import "TAlertView.h"
@interface CashViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,QBRefreshControlDelegate>
@property (strong, nonatomic) UITableView *cashTableView;
@property (strong, nonatomic) UIView *bottomView;
@property (strong, nonatomic) NSMutableArray *allData;
@property (strong, nonatomic) UIView *topView;
@property (strong, nonatomic) UILabel* mysaveCount;
@property (strong, nonatomic) UILabel* currency;
@property (strong, nonatomic) QBArrowRefreshControl *myRefreshControl;
@end

@implementation CashViewController
static NSString* reusedIdentifier = @"MyCell";

-(NSMutableArray *)allData{
    if (!_allData) {
        _allData = [NSMutableArray array];
    }
    return _allData;
}
#pragma mark View DidAppear And DidDisappear
-(void)viewDidAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeViewFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}
-(void)viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}
#pragma mark Notification
-(void)changeViewFrame:(NSNotification*)noti{
    CGRect endRect = [[noti.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue];
    float timeDuration = [[noti.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey]floatValue];
    
    
    CGRect bottomViewFrame = self.bottomView.frame;
    bottomViewFrame.origin.y = endRect.origin.y - CGRectGetHeight(self.bottomView.frame);
    
    CGRect tableViewFrame = self.cashTableView.frame;
    tableViewFrame.size.height = endRect.origin.y - CGRectGetHeight(self.bottomView.frame) - CGRectGetMinY(self.cashTableView.frame);
    
    
    [UIView animateWithDuration:timeDuration animations:^{
        self.bottomView.frame = bottomViewFrame;
        self.cashTableView.frame = tableViewFrame;
    } completion:^(BOOL finished) {
        [self.cashTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.allData.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }];
}
#pragma mark ScrollView
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}
#pragma mark createElements
-(void)createTopView{
    
    UIView* tview = [[UIView alloc]initWithFrame:CGRectMake(0, kStatusNaviBarH, KScreenWidth, 60.f)];
    tview.backgroundColor = [UIColor colorWithHexString:@"#3c3938"];
    tview.clipsToBounds = YES;
    self.topView = tview;
    [self.view addSubview:tview];
    
    UIImageView * iv = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cash_purse.png"]];
    float ivX = 15.f;
    float ivY = 15.f;
    float ivW = 45.f;
    float ivH = 45.f;
    iv.frame = CGRectMake(ivX, ivY, ivW, ivH);
    iv.backgroundColor = [UIColor clearColor];
    [self.topView addSubview:iv];
    
    UILabel* l1 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(iv.frame), CGRectGetMinY(iv.frame)+20.f, 80.f, 14.f)];
    l1.text = @"MY SAVING :";
    l1.textColor = [UIColor whiteColor];
    l1.font = [UIFont fontWithName:@"Helvetica" size:12];
    [self.topView addSubview:l1];
    
    UILabel* l2 = [[UILabel alloc]init];
    l2.text = self.currentCash;
    l2.textAlignment = NSTextAlignmentRight;
    l2.textColor = [UIColor colorWithHexString:@"#dddcdc"];
    l2.font = [UIFont fontWithName:@"Helvetica" size:55];
    CGSize l2Size = [l2.text sizeWithAttributes:@{NSFontAttributeName:l2.font,NSForegroundColorAttributeName:l2.textColor}];
    l2.frame = CGRectMake(KScreenWidth - l2Size.width - 5.f, 0.f, l2Size.width, l2Size.height);
    self.mysaveCount = l2;
    [self.topView addSubview:l2];
    
    UILabel* l3 = [[UILabel alloc]init];
    l3.text = @"$";
    l3.textColor = [UIColor colorWithHexString:@"#dddcdc"];
    l3.font = [UIFont fontWithName:@"Helvetica" size:24];
    l3.frame = CGRectMake(CGRectGetMinX(self.mysaveCount.frame) - 15.f, CGRectGetMinY(self.mysaveCount.frame), 30.f, 50.f);
    self.mysaveCount = l3;
    [self.topView addSubview:l3];
}
-(void)createTableViewAndBackImageView{
    UIImageView* imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cash_page.png"]];
    imageView.contentMode = UIViewContentModeScaleToFill;
    imageView.userInteractionEnabled = YES;
    imageView.frame = CGRectMake(0, CGRectGetMaxY(self.topView.frame), KScreenWidth, KScreenHeight - CGRectGetHeight(self.topView.frame) - kStatusNaviBarH);
    [self.view addSubview:imageView];
    
    UITableView* tableView = [[UITableView alloc]initWithFrame:CGRectMake(imageView.frame.origin.x, imageView.frame.origin.y, imageView.frame.size.width, imageView.frame.size.height - 50.f) style:UITableViewStylePlain];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    self.cashTableView = tableView;
    [self.view addSubview:tableView];
}
-(void)createBottomView{
    UIView* bView = [[UIView alloc]initWithFrame:CGRectMake(0, KScreenHeight - 50.f, KScreenWidth, 50.f)];
    bView.backgroundColor = [UIColor whiteColor];
    self.bottomView = bView;
    [self.view addSubview:bView];
    
    UIView* tline = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 1.f)];
    tline.backgroundColor = [UIColor colorWithHexString:@"#888888" withAlpha:0.7];
    [bView addSubview:tline];
    
    UIButton* btn = [[UIButton alloc]initWithFrame:CGRectMake(KScreenWidth-100.f, 5.f, 100.f, 40.f)];
    [btn setImage:[UIImage imageNamed:@"cash_normal.png"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"cash_press.png"] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(getCash:) forControlEvents:UIControlEventTouchUpInside];
    [bView addSubview:btn];
    
    UIImageView* tfBgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cash_enter_the_total_amount.png"]];
    tfBgView.frame = CGRectMake(5.f, 5.f, KScreenWidth - CGRectGetWidth(btn.frame), CGRectGetHeight(btn.frame));
    tfBgView.userInteractionEnabled =YES;
    [bView addSubview:tfBgView];
    
    UITextField* tf = [[UITextField alloc]initWithFrame:CGRectMake(15.f, 10.f, KScreenWidth - CGRectGetWidth(btn.frame) - 5.f, 30.f)];
    tf.borderStyle = UITextBorderStyleNone;
    tf.placeholder = @"Enter the total amount...";
    [tf setValue:[UIFont systemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
    tf.clearsOnBeginEditing = YES;
    tf.keyboardType =UIKeyboardTypeNumbersAndPunctuation;
    tf.delegate = self;
    [bView addSubview:tf];
    
}
#pragma mark UITextFieldDelegate

#pragma mark UIButton - action
-(void)getCash:(UIButton*)btn{//提现接口
    NSLog(@"cash");
    [self.view endEditing:YES];
}



- (void)viewDidLoad {
    [super viewDidLoad];

    [self createTopView];
    [self createTableViewAndBackImageView];
    [self createBottomView];
    self.title = @"Cash";
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue" size:20],NSForegroundColorAttributeName:[UIColor whiteColor]};
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:@"#1b1b1b"];
    
    [self.cashTableView registerClass:[CashTableViewCell class] forCellReuseIdentifier:reusedIdentifier];
    
    [self getTransactionArr];
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, -400, 320, 400)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.cashTableView addSubview:bgView];
    QBArrowRefreshControl *refreshControl = [[QBArrowRefreshControl alloc] init];
    refreshControl.delegate = self;
    [self.cashTableView addSubview:refreshControl];
    self.myRefreshControl = refreshControl;
}
#pragma mark - QBRefreshControlDelegate

- (void)refreshControlDidBeginRefreshing:(QBRefreshControl *)refreshControl
{
    [self getTransactionArr];
}
-(void)getTransactionArr{
    [ModeTransactionsAPI requestTransactionsAndCallback:^(id obj) {
        [self.myRefreshControl endRefreshing];
        if (![obj isKindOfClass:[NSNull class]]) {
            [self.allData removeAllObjects];
            [self.allData addObjectsFromArray:obj];
            [self.cashTableView reloadData];
        } else {
            [self showAlertViewWithErrorInfo:@"Net error.Please try it again."];
        }
    }];
}
#pragma mark ShowAlertView
-(void)showAlertViewWithErrorInfo:(NSString*)errorInfo{
    TAlertView *alert = [[TAlertView alloc] initWithTitle:errorInfo andMessage:nil];
    alert.alertBackgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.8];
    alert.titleFont = [UIFont fontWithName:@"Baskerville-SemiBoldItalic" size:14];
    [alert setTitleColor:[UIColor whiteColor] forAlertViewStyle:TAlertViewStyleInformation];
    alert.tapToClose = NO;
    alert.timeToClose = 1.f;
    alert.buttonsAlign = TAlertViewButtonsAlignHorizontal;
    alert.style = TAlertViewStyleInformation;
    [alert showAsMessage];
}
#pragma mark UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.allData.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100.f;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CashTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:reusedIdentifier];
    cell.backgroundColor = [UIColor clearColor];
    if (!cell) {
        cell = [[CashTableViewCell alloc]init];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.transaction = self.allData[indexPath.row];
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
