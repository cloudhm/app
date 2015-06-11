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
@interface CashViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) UITableView *cashTableView;
@property (strong, nonatomic) UIView *bottomView;
@property (strong, nonatomic) NSMutableArray *allData;
@property (strong, nonatomic) UILabel* mysaveCount;
@property (strong, nonatomic) UILabel* currency;
@end
#define APPLICATION_FRAME [UIScreen mainScreen].applicationFrame
@implementation CashViewController
static NSString* reusedIdentifier = @"MyCell";
- (IBAction)actionToggleLeftDrawer:(UIBarButtonItem *)sender {
    [[AppDelegate globalDelegate] toggleLeftDrawer:self animated:YES];
}
-(NSMutableArray *)allData{
    if (!_allData) {
        _allData = [NSMutableArray array];
    }
    return _allData;
}

-(void)viewDidAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeViewFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}
-(void)viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}
-(void)changeViewFrame:(NSNotification*)noti{
    CGRect endRect = [[noti.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue];
    float timeDuration = [[noti.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey]floatValue];
    
    
    CGRect bottomViewFrame = self.bottomView.frame;
    bottomViewFrame.origin.y = endRect.origin.y - CGRectGetHeight(self.bottomView.frame);
    
    CGRect tableViewFrame = self.cashTableView.frame;
    tableViewFrame.size.height = endRect.origin.y - CGRectGetHeight(self.bottomView.frame) - CGRectGetMinY(self.cashTableView.frame);
    
    
    [UIView animateWithDuration:timeDuration animations:^{
        self.bottomView.frame = bottomViewFrame;
        
        NSLog(@"%f",self.bottomView.frame.origin.y);
        NSLog(@"%@",NSStringFromCGRect(self.bottomView.frame));
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.1f animations:^{
            self.cashTableView.frame = tableViewFrame;
            
        } completion:^(BOOL finished) {
            [self.cashTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.allData.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }];
        
    }];
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}
-(void)initTopView{
    UIView* topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, APPLICATION_FRAME.size.width, 60)];
    topView.backgroundColor = [UIColor colorWithHexString:@"#3c3938"];
    topView.clipsToBounds = YES;
    [self.view addSubview:topView];
    UIImageView * iv = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cash_purse.png"]];
    float ivX = 15.f;
    float ivY = 15.f;
    float ivW = 45.f;
    float ivH = 45.f;
    iv.frame = CGRectMake(ivX, ivY, ivW, ivH);
    iv.backgroundColor = [UIColor clearColor];
    [topView addSubview:iv];
    
    UILabel* l1 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(iv.frame), CGRectGetMinY(iv.frame)+20.f, 80, 14)];
    l1.text = @"MY SAVING :";
    l1.textColor = [UIColor whiteColor];
    l1.font = [UIFont fontWithName:@"Helvetica" size:12];
    [topView addSubview:l1];
    
    UILabel* l2 = [[UILabel alloc]init];
    l2.text = @"0.00";
    l2.textAlignment = NSTextAlignmentLeft;
    l2.textColor = [UIColor colorWithHexString:@"#dddcdc"];
    l2.font = [UIFont fontWithName:@"Helvetica" size:55];
    CGSize l2Size = [l2.text sizeWithAttributes:@{NSFontAttributeName:l2.font,NSForegroundColorAttributeName:l2.textColor}];
    l2.frame = CGRectMake(APPLICATION_FRAME.size.width - l2Size.width -5.f, 0.f, l2Size.width, l2Size.height);
    l2.backgroundColor = [UIColor yellowColor];
    self.mysaveCount = l2;
    [topView addSubview:l2];
    
    UILabel* l3 = [[UILabel alloc]init];
    l3.text = @"$";
    l3.textColor = [UIColor colorWithHexString:@"#dddcdc"];
    l3.font = [UIFont fontWithName:@"Helvetica" size:30];
    l3.frame = CGRectMake(CGRectGetMidX(l2.frame), CGRectGetMinY(l2.frame) +5.f, 30.f, 50.f);
    [topView addSubview:l3];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [self initTopView];
    self.title = @"Cash";
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue" size:20],NSForegroundColorAttributeName:[UIColor whiteColor]};
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:@"#1b1b1b"];
    self.cashTableView.delegate = self;
    self.cashTableView.dataSource = self;
    
    [self.cashTableView registerClass:[CashTableViewCell class] forCellReuseIdentifier:reusedIdentifier];
    
    for (int i = 0; i<100; i++) {
        int j = arc4random()%200 - 100;
        NSString* str = [NSString stringWithFormat:@"%d",j];
        [self.allData addObject:str];
    }
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
    return self.allData.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 135;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CashTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:reusedIdentifier];
    if (!cell) {
        cell = [[CashTableViewCell alloc]init];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.cashNumStr = self.allData[indexPath.row];
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
