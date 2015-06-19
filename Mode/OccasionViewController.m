//
//  OccasionViewController.m
//  Mode
//
//  Created by huangmin on 15/5/28.
//  Copyright (c) 2015年 YedaoDEV. All rights reserved.
//

#import "OccasionViewController.h"
#import "LikeOrNopeViewController.h"
#import "ModeSysAPI.h"
#import "CustomCollectionViewFlowLayout.h"
#import "OccasionCollectionViewCell.h"
#import "ModeRunwayAPI.h"
#import "ModeGood.h"
#import "ModeSysList.h"
#import "ModeWishlistAPI.h"
#import "ModeDatabase.h"
#import "PrefixHeaderDatabase.pch"
#import "TAlertView.h"
#import "QBArrowRefreshControl.h"
@interface OccasionViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,QBRefreshControlDelegate>
@property (weak, nonatomic) UICollectionView *cv;

@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) QBArrowRefreshControl *myRefreshControl;
@end

@implementation OccasionViewController

static NSString *reuseIdentifier=@"MyCell";
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
//懒加载可变数组
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.dataArray addObjectsFromArray:[ModeDatabase readDatabaseFromTableName:HOME_LIST_TABLENAME andSelectConditionKey:TYPE andSelectConditionValue:OCCASION]];
    //设置集合视图的框架位置
    CGRect frame = CGRectMake(5.f, 0.f, self.view.bounds.size.width-10.f, self.view.bounds.size.height-5.f -44.f - 56.f);
    
    //集合视图的布局及相关配置
    CustomCollectionViewFlowLayout * cvLayout = [[CustomCollectionViewFlowLayout alloc]initWithFrame:frame];
    UICollectionView* occasionCV = [[UICollectionView alloc]initWithFrame:frame collectionViewLayout:cvLayout];
    occasionCV.backgroundColor = [UIColor clearColor];
    occasionCV.delegate = self;
    occasionCV.dataSource = self;
    occasionCV.showsVerticalScrollIndicator = NO;
    occasionCV.alwaysBounceVertical = YES;//上下总是可以拉动
    self.cv = occasionCV;
    [self.view addSubview:self.cv];
    
    //注册集合视图单元格
    [self.cv registerClass:[OccasionCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, -400, 320, 400)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.cv addSubview:bgView];
    QBArrowRefreshControl *refreshControl = [[QBArrowRefreshControl alloc] init];
    refreshControl.delegate = self;
    [self.cv addSubview:refreshControl];
    self.myRefreshControl = refreshControl;
    

}
#pragma mark - QBRefreshControlDelegate

- (void)refreshControlDidBeginRefreshing:(QBRefreshControl *)refreshControl
{
//    [self refreshData];
}
//刷新数据
-(void)refreshData{
    [ModeSysAPI requestMenuListAndCallback:^(id obj) {
        [self.myRefreshControl endRefreshing];//返回值进入block块中停止刷新动画
        if ([obj isKindOfClass:[NSNull class]]) {
            NSString* cautionInfo = @"Net error!Fail to connect host servers.";
            [self showAlertViewWithCautionInfo:cautionInfo];
        } else if ([obj boolValue] == YES || [obj boolValue] == NO) {
            [self.dataArray removeAllObjects];
            [self.dataArray addObjectsFromArray: [ModeDatabase readDatabaseFromTableName:HOME_LIST_TABLENAME andSelectConditionKey:TYPE andSelectConditionValue:OCCASION]];
            [self.cv reloadData];
            [self.cv setNeedsDisplay];
        }
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [self refreshData];
}
-(void)viewDidAppear:(BOOL)animated{
//    [self.dataArray removeAllObjects];
//    [self.dataArray addObjectsFromArray: [ModeDatabase readDatabaseFromTableName:HOME_LIST_TABLENAME andSelectConditionKey:TYPE andSelectConditionValue:OCCASION]];
//    [self.cv reloadData];
//    [self.cv setNeedsDisplay];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"ovcToLvc" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(gotoChoose:) name:@"ovcToLvc" object:nil];
}
-(void)viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"ovcToLvc" object:nil];
}
//接受到通知后响应此方法
-(void)gotoChoose:(NSNotification*)noti{
    NSDictionary* params = @{@"name":[noti.userInfo objectForKey:@"name"],@"source":[noti.userInfo objectForKey:@"source"]};
    NSLog(@"页面即将切换");
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"ovcToLvc" object:nil];
    [ModeRunwayAPI requestRunwayWithParams:params andCallback:^(id obj) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(gotoChoose:) name:@"ovcToLvc" object:nil];
        if ([obj isKindOfClass:[NSNull class]]) {
            [self showAlertViewWithCautionInfo:@"Bad net.Please hold a mement."];
            return;
        }
        NSArray* allItems = obj[1];
        [ModeDatabase saveGetNewDatabaseIntoTableName:LIKENOPE_TABLENAME andTableElements:LIKENOPE_ELEMENTS andObj:allItems];
        [self performSegueWithIdentifier:@"ovcToLvc" sender:obj];
        
    }];
}


#pragma mark CollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}
#pragma mark CollectionView继承ScrollView  因此可以用ScrollViewDelegate
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self.cv reloadData];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    OccasionCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.occasion = self.dataArray[indexPath.row];
    return cell;
}


 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     
     UINavigationController*navi = [segue destinationViewController];
     LikeOrNopeViewController* lvc = (LikeOrNopeViewController*)navi.topViewController;
     NSLog(@"%@",lvc);
     lvc.receiveArr = sender;
 }



@end
