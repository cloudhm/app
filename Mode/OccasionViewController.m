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
#import <FMDB.h>
#import "CustomCollectionViewFlowLayout.h"
#import "OccasionCollectionViewCell.h"
#import "ModeRunwayAPI.h"
#import "ModeGood.h"
#import "ModeSysList.h"
#import "ModeWishlistAPI.h"
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
    
    
    [self readDataFromLocalDatabase];
    
    
    
    
    //设置集合视图的框架位置
    CGRect frame = CGRectMake(5.f, 0.f, self.view.bounds.size.width-10.f, self.view.bounds.size.height-5.f -44.f - 56.f);
    
    //集合视图的布局及相关配置
    CustomCollectionViewFlowLayout * cvLayout = [[CustomCollectionViewFlowLayout alloc]initWithFrame:frame];
    UICollectionView* occasionCV = [[UICollectionView alloc]initWithFrame:frame collectionViewLayout:cvLayout];
    occasionCV.backgroundColor = [UIColor clearColor];
//    occasionCV.pagingEnabled = YES;
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
-(void)refreshData{
    NSLog(@"update");
    [ModeSysAPI requestOccasionListAndCallback:^(id obj) {
        [self.refresh endRefreshing];
        if (![obj isKindOfClass:[NSNull class]]) {
            [self.dataArray removeAllObjects];
            [self.dataArray addObjectsFromArray:obj];
            NSLog(@"刷新视图");
            [self saveAllResponseDataByObject:obj];
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
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"cccc");
}

-(void)viewWillAppear:(BOOL)animated{
    [self getData];
}
-(void)viewDidAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(gotoChoose:) name:@"ovcToLvc" object:nil];
}
-(void)viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"ovcToLvc" object:nil];
}
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
        [self saveDatabaseWithObj:allItems];
        [self performSegueWithIdentifier:@"ovcToLvc" sender:@{@"title":[noti.userInfo objectForKey:@"category"],@"intro_desc":[obj objectForKey:@"intro_desc"],@"intro_title":[obj objectForKey:@"intro_title"]}];
    }];
}
-(void)saveDatabaseWithObj:(id)obj{
    NSString* documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString*path=[documentPath stringByAppendingPathComponent:@"my.sqlite"];
    FMDatabase* db = [FMDatabase databaseWithPath:path];
    if ([db open]) {
        BOOL result = [db executeUpdate:@"DROP TABLE likenope"];//只是为了清空原先加载的16张图片数据模型
        if (result) {
            NSLog(@"成功删除");
        } else {
            NSLog(@"该表不存在或未删除");
        }
        result = [db executeUpdate:@"CREATE TABLE IF NOT EXISTS likenope (id integer primary key autoincrement,goods_id,brand_name,brand_img_link,img_link,has_coupon)"];
        if (result) {
            NSLog(@"创建likenope表成功");
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
    OccasionCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.occasion = self.dataArray[indexPath.row];
    return cell;
}

-(void)getData{
    [ModeSysAPI requestOccasionListAndCallback:^(id obj) {
        if (![obj isKindOfClass:[NSNull class]]) {//返回不为空
            [self.dataArray removeAllObjects];
            [self.dataArray addObjectsFromArray:obj];
            [self saveAllResponseDataByObject:self.dataArray];//将数据
            [self.cv reloadData];//刷新集合视图
            
        }
    }];
}
-(void)readDataFromLocalDatabase{
    //从本地数据库读取内容
    NSString* documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString* path = [documentPath stringByAppendingPathComponent:@"my.sqlite"];
    FMDatabase *db = [FMDatabase databaseWithPath:path];
    if ([db open] == NO) {
        NSLog(@"打开失败");
        return;
    }
    //查询数据
    FMResultSet* set = [db executeQuery:@"select * from list_home where type = 'occasion' "];
    while ([set next]) {
        ModeSysList* occasion = [[ModeSysList alloc]init];
        occasion.name = [set stringForColumn:@"name"];
        occasion.pic_link = [set stringForColumn:@"pic_link"];
        occasion.event_id = [NSNumber numberWithInt:[set intForColumn:@"event_id"]];
        occasion.amount = [NSNumber numberWithInt:[set intForColumn:@"amount"]];
        [self.dataArray addObject:occasion];
    }
    [db close];
}

-(void)saveAllResponseDataByObject:(NSArray*)array{
    NSString* documentPath=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString*path=[documentPath stringByAppendingPathComponent:@"my.sqlite"];
    FMDatabase *db = [FMDatabase databaseWithPath:path];

    if ([db open]) {
        BOOL result = [db executeUpdate:@"CREATE TABLE IF NOT EXISTS list_home (event_id primary key,type,name,pic_link,amount)"];
        if (result) {
            for (ModeSysList* occasion in self.dataArray) {
                    BOOL res = [db executeUpdate:@"replace into list_home(event_id,type,name,pic_link,amount) values(?,?,?,?,?)", occasion.event_id,@"occasion",occasion.name, occasion.pic_link,occasion.amount];
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
     NSLog(@"%@",lvc);
     lvc.dictionary = sender;
 }



@end
