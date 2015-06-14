//
//  StyleViewController.m
//  Mode
//
//  Created by YedaoDEV on 15/5/25.
//  Copyright (c) 2015年 YedaoDEV. All rights reserved.
//

#import "StyleViewController.h"
#import "CustomCollectionViewFlowLayout.h"
#import "StyleCollectionViewCell.h"
#import "ModeSysAPI.h"
#import "LikeOrNopeViewController.h"
#import "ModeRunwayAPI.h"
#import "ModeGood.h"
#import "ModeSysList.h"
#import "ModeDatabase.h"
#import "PrefixHeaderDatabase.pch"
@interface StyleViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) UICollectionView *cv;

@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) UIRefreshControl *refresh;
@end

@implementation StyleViewController
static NSString *reuseIdentifier=@"MyCell";

//懒加载可变数组
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
-(void)viewWillAppear:(BOOL)animated{
    [self getData];
}
//由于需要整页跳转，因此是按分区设置内容格式，因此可变数组应为二维数组
- (void)viewDidLoad {
    [super viewDidLoad];
    [ModeDatabase readDatabaseFromTableName:HOME_LIST_TABLENAME andSelectConditionKey:TYPE andSelectConditionValue:STYLE];
    //设置集合视图的框架位置
    CGRect frame = CGRectMake(5.f, 0.f, self.view.bounds.size.width-10.f, self.view.bounds.size.height-5.f -44.f - 56.f);
    
    //集合视图的布局及相关配置
    CustomCollectionViewFlowLayout * cvLayout = [[CustomCollectionViewFlowLayout alloc]initWithFrame:frame];
    UICollectionView* brandCV = [[UICollectionView alloc]initWithFrame:frame collectionViewLayout:cvLayout];
    brandCV.backgroundColor = [UIColor clearColor];
    brandCV.delegate = self;
    brandCV.dataSource = self;
    brandCV.showsVerticalScrollIndicator = NO;
    brandCV.alwaysBounceVertical = YES;
    self.cv = brandCV;
    [self.view addSubview:self.cv];
    
    //注册集合视图单元格
    [self.cv registerClass:[StyleCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    self.refresh = [[UIRefreshControl alloc]init];
    [self.refresh addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    self.refresh.attributedTitle = [[NSAttributedString alloc]initWithString:@"下拉刷新"];
    [self.cv addSubview:self.refresh];
}
-(void)viewDidAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"svcToLvc" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(gotoChoose:) name:@"svcToLvc" object:nil];
}
-(void)viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"svcToLvc" object:nil];
}
-(void)refreshData{
    NSLog(@"update");
    [ModeSysAPI requestStyleListAndCallback:^(id obj) {
        if (![obj isKindOfClass:[NSNull class]]) {
            [self.dataArray removeAllObjects];
            [self.dataArray addObjectsFromArray:obj];
            [ModeDatabase saveSystemListDatabaseIntoTableName:HOME_LIST_TABLENAME andTableElements:HOME_LIST_ELEMENTS andObject:self.dataArray andKeyWord:STYLE];
            [self.refresh endRefreshing];
            [self.cv reloadData];
        } else {
            [self.refresh endRefreshing];
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

-(void)gotoChoose:(NSNotification*)noti{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"svcToLvc" object:nil];
    NSDictionary* params = @{@"mode":[noti.userInfo objectForKey:@"mode"],@"mode_val":[noti.userInfo objectForKey:@"mode_val"]};
    [ModeRunwayAPI requestGetNewWithParams:params andCallback:^(id obj) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(gotoChoose:) name:@"svcToLvc" object:nil];
        if ([obj isKindOfClass:[NSNull class]]) {
            return;
        }
        NSArray* allItems = [obj objectForKey:@"allItems"];
        [ModeDatabase saveGetNewDatabaseIntoTableName:LIKENOPE_TABLENAME andTableElements:LIKENOPE_ELEMENTS andObj:allItems];
        [self performSegueWithIdentifier:@"svcToLvc" sender:@{@"title":[noti.userInfo objectForKey:@"category"],@"intro_desc":[obj objectForKey:@"intro_desc"],@"intro_title":[obj objectForKey:@"intro_title"],@"params":params}];
    }];
    
}


#pragma mark CollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self.cv reloadData];
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    StyleCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.mstyle = self.dataArray[indexPath.row];
    return cell;
}



-(void)getData{
    [ModeSysAPI requestStyleListAndCallback:^(id obj) {
        if (![obj isKindOfClass:[NSNull class]]) {//返回不为空
            [self.dataArray removeAllObjects];
            [self.dataArray addObjectsFromArray:obj];
            [self.cv reloadData];//刷新集合视图
            [ModeDatabase saveSystemListDatabaseIntoTableName:HOME_LIST_TABLENAME andTableElements:HOME_LIST_ELEMENTS andObject:self.dataArray andKeyWord:STYLE];
        }
    }];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UINavigationController*navi = [segue destinationViewController];
    LikeOrNopeViewController* lvc = (LikeOrNopeViewController*)navi.topViewController;
    lvc.dictionary = sender;
}


@end
