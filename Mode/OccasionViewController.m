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
@interface OccasionViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) UICollectionView *cv;
@property (assign, nonatomic) NSInteger num;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) UIRefreshControl *refresh;
@end

@implementation OccasionViewController

static NSString *reuseIdentifier=@"MyCell";
//懒加载可变数组
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

//由于需要整页跳转，因此是按分区设置内容格式，因此可变数组应为二维数组
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
    
    self.refresh = [[UIRefreshControl alloc]init];
    [self.refresh addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    self.refresh.attributedTitle = [[NSAttributedString alloc]initWithString:@"下拉刷新"];
    [self.cv addSubview:self.refresh];
}
//刷新数据
-(void)refreshData{
    NSLog(@"update");
    [ModeSysAPI requestOccasionListAndCallback:^(id obj) {
        [self.refresh endRefreshing];//返回值进入block块中停止刷新动画
        if (![obj isKindOfClass:[NSNull class]]) {
            [self.dataArray removeAllObjects];
            [self.dataArray addObjectsFromArray:obj];
            [ModeDatabase saveSystemListDatabaseIntoTableName:HOME_LIST_TABLENAME andTableElements:HOME_LIST_ELEMENTS andObject:self.dataArray andKeyWord:OCCASION];
            [self.cv reloadData];
            [self.cv setNeedsLayout];
        } else {
            UILabel * l = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 20)];
            l.text = @"已是最新版";
            l.textColor = [UIColor redColor];
            l.center = self.view.center;
            l.alpha = 0.f;
            [self.view addSubview:l];
            [UIView animateWithDuration:1.f animations:^{
                l.alpha = 1.f;
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:1.f animations:^{
                    l.alpha = 0.f;
                } completion:^(BOOL finished) {
                    [l removeFromSuperview];
                }];
            }];
        }
    }];
    
}


-(void)viewWillAppear:(BOOL)animated{
    [self getData];
}
-(void)viewDidAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"ovcToLvc" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(gotoChoose:) name:@"ovcToLvc" object:nil];
}
-(void)viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"ovcToLvc" object:nil];
}
//接受到通知后响应此方法
-(void)gotoChoose:(NSNotification*)noti{
    NSDictionary* params = @{@"mode":[noti.userInfo objectForKey:@"mode"],@"mode_val":[noti.userInfo objectForKey:@"mode_val"]};
    NSLog(@"页面即将切换");
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"ovcToLvc" object:nil];
    [ModeRunwayAPI requestGetNewWithParams:params andCallback:^(id obj) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(gotoChoose:) name:@"ovcToLvc" object:nil];
        if ([obj isKindOfClass:[NSNull class]]) {
            return;
        }
        NSArray* allItems = [obj objectForKey:@"allItems"];
        [ModeDatabase saveGetNewDatabaseIntoTableName:LIKENOPE_TABLENAME andTableElements:LIKENOPE_ELEMENTS andObj:allItems];
        [self performSegueWithIdentifier:@"ovcToLvc" sender:@{@"title":[noti.userInfo objectForKey:@"category"],@"":[obj objectForKey:@"intro_desc"],@"intro_title":[obj objectForKey:@"intro_title"],@"params":params}];
        
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
//获取网络数据  用来填充页面内容
-(void)getData{
    [ModeSysAPI requestOccasionListAndCallback:^(id obj) {
        if (![obj isKindOfClass:[NSNull class]]) {//返回不为空
            [self.dataArray removeAllObjects];
            [self.dataArray addObjectsFromArray:obj];
            [ModeDatabase saveSystemListDatabaseIntoTableName:HOME_LIST_TABLENAME andTableElements:HOME_LIST_ELEMENTS andObject:self.dataArray andKeyWord:OCCASION];
            [self.cv reloadData];//刷新集合视图
            
        }
    }];
}

 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     
     UINavigationController*navi = [segue destinationViewController];
     LikeOrNopeViewController* lvc = (LikeOrNopeViewController*)navi.topViewController;
     NSLog(@"%@",lvc);
     lvc.dictionary = sender;
 }



@end
