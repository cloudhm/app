//
//  BrandViewController.m
//  Mode
//
//  Created by YedaoDEV on 15/5/25.
//  Copyright (c) 2015年 YedaoDEV. All rights reserved.
//

#import "BrandViewController.h"
#import "CustomCollectionViewFlowLayout.h"
#import "BrandCollectionViewCell.h"
#import "ModeSysAPI.h"
#import <FMDB.h>
#import "LikeOrNopeViewController.h"
#import "ModeGood.h"
#import "ModeRunwayAPI.h"
#import "ModeSysList.h"
@interface BrandViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) UICollectionView *cv;

@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) UIRefreshControl *refresh;
@end

@implementation BrandViewController
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
    
   
    
    [self readDataFromLocalDatabase];
    
    //设置集合视图的框架位置
    CGRect frame = CGRectMake(5.f, 0.f, self.view.bounds.size.width-10.f, self.view.bounds.size.height-5.f -44.f - 56.f);
    
    //集合视图的布局及相关配置
    CustomCollectionViewFlowLayout * cvLayout = [[CustomCollectionViewFlowLayout alloc]initWithFrame:frame];
    UICollectionView* brandCV = [[UICollectionView alloc]initWithFrame:frame collectionViewLayout:cvLayout];
    brandCV.backgroundColor = [UIColor clearColor];
//    brandCV.pagingEnabled = YES;
    brandCV.delegate = self;
    brandCV.dataSource = self;
    brandCV.showsVerticalScrollIndicator = NO;
    brandCV.alwaysBounceVertical = YES;//上下总是可以拉动
    self.cv = brandCV;
    [self.view addSubview:self.cv];
    
    //注册集合视图单元格
    [self.cv registerClass:[BrandCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    self.refresh = [[UIRefreshControl alloc]init];
    [self.refresh addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    self.refresh.attributedTitle = [[NSAttributedString alloc]initWithString:@"下拉刷新"];
    [self.cv addSubview:self.refresh];
}
-(void)viewDidAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(gotoChoose:) name:@"bvcToLvc" object:nil];
}
-(void)viewWillAppear:(BOOL)animated{
    [self getData];
}
-(void)viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"bvcToLvc" object:nil];
}
-(void)refreshData{
    NSLog(@"update");
    [ModeSysAPI requestBrandListAndCallback:^(id obj) {
        if (![obj isKindOfClass:[NSNull class]]) {
            [self.dataArray removeAllObjects];
            [self.dataArray addObjectsFromArray:obj];
            [self saveAllResponseDataByObject:obj];
            [self.refresh endRefreshing];
            NSLog(@"刷新视图");
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
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"bvcToLvc" object:nil];
    NSDictionary* params = @{@"mode":[noti.userInfo objectForKey:@"mode"],@"mode_val":[noti.userInfo objectForKey:@"mode_val"]};
    [ModeRunwayAPI requestGetNewWithParams:params andCallback:^(id obj) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(gotoChoose:) name:@"bvcToLvc" object:nil];
        if ([obj isKindOfClass:[NSNull class]]) {
            return;
        }
        NSArray* allItems = [obj objectForKey:@"allItems"];
        [self saveDatabaseWithObj:allItems];
        [self performSegueWithIdentifier:@"bvcToLvc" sender:@{@"title":[noti.userInfo objectForKey:@"category"],@"intro_desc":[obj objectForKey:@"intro_desc"],@"intro_title":[obj objectForKey:@"intro_title"]}];
    }];
    
}
-(void)saveDatabaseWithObj:(id)obj{
    NSString* documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString*path=[documentPath stringByAppendingPathComponent:@"my.sqlite"];
    FMDatabase* db = [FMDatabase databaseWithPath:path];
    if ([db open]) {
        [db executeUpdate:@"DROP TABLE likenope"];//只是为了清空原先加载的16张图片数据模型
        BOOL result = [db executeUpdate:@"CREATE TABLE IF NOT EXISTS likenope (id integer primary key autoincrement,goods_id,brand_name,brand_img_link,img_link,has_coupon)"];
        if (result) {
            NSLog(@"创建表成功");
            for (ModeGood* modeGood in obj) {
                BOOL res = [db executeUpdate:@"insert into likenope (goods_id,brand_name,brand_img_link,img_link,has_coupon) values(?,?,?,?,?)", modeGood.goods_id,modeGood.brand_name,modeGood.brand_img_link,modeGood.img_link,modeGood.has_coupon];
                if (res == NO) {
                    NSLog(@"插入数据失败");
                }
            }
        } else {
            NSLog(@"创建数据表失败");
            [db close];
        }
    } else {
        NSLog(@"数据库打开失败");
        [db close];
    }
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
    BrandCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.brand = self.dataArray[indexPath.row];
    return cell;
}
-(void)getData{
    [ModeSysAPI requestBrandListAndCallback:^(id obj) {
        if (![obj isKindOfClass:[NSNull class]]) {//返回不为空
            [self.dataArray removeAllObjects];
            [self.dataArray addObjectsFromArray:obj];
            [self.cv reloadData];//刷新集合视图
            [self saveAllResponseDataByObject:self.dataArray];//将数据
        }
    }];
}
-(void)readDataFromLocalDatabase{

    //从本地数据库读取内容
    NSString* documentPath=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString*path=[documentPath stringByAppendingPathComponent:@"my.sqlite"];
    FMDatabase *db = [FMDatabase databaseWithPath:path];
    if ([db open] == NO) {
        NSLog(@"打开失败");
        return;
    }
    //查询数据
    FMResultSet* set = [db executeQuery:@"select * from list_home where type = 'brand' "];
    while ([set next]) {
        ModeSysList* brand = [[ModeSysList alloc]init];
        brand.name = [set stringForColumn:@"name"];
        brand.pic_link = [set stringForColumn:@"pic_link"];
        brand.event_id = [NSNumber numberWithInt:[set intForColumn:@"event_id"]];
        brand.amount = [NSNumber numberWithInt:[set intForColumn:@"amount"]];
        [self.dataArray addObject:brand];
        
    }
    [db close];
    
}


-(void)saveAllResponseDataByObject:(NSArray*)array{
    NSString* documentPath=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString*path=[documentPath stringByAppendingPathComponent:@"my.sqlite"];
    FMDatabase *db = [FMDatabase databaseWithPath:path];
    
    if ([db open]) {
        BOOL result = [db executeUpdate:@"CREATE TABLE IF NOT EXISTS list_home (event_id primary key,type,name,pic_link)"];
        if (result) {
            for (ModeSysList* brand in self.dataArray) {
                BOOL res = [db executeUpdate:@"replace into list_home (event_id,type,name,pic_link,amount) values(?,?,?,?,?)", brand.event_id,@"brand", brand.name, brand.pic_link,brand.amount];
                if (res == NO) {
                    NSLog(@"插入数据失败");
                }
            }
        }
        [db close];
    } else {
        [db close];
        NSLog(@"数据库打开失败");
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UINavigationController*navi = [segue destinationViewController];
    LikeOrNopeViewController* lvc = (LikeOrNopeViewController*)navi.topViewController;
    lvc.dictionary = sender;
}


@end
