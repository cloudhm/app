//
//  JVLeftDrawerTableViewController.m
//  JVFloatingDrawer
//
//  Created by Julian Villella on 2015-01-15.
//  Copyright (c) 2015 JVillella. All rights reserved.
//

#import "JVLeftDrawerTableViewController.h"
#import "JVLeftDrawerTableViewCell.h"
#import "AppDelegate.h"
#import "JVFloatingDrawerViewController.h"

#import "BrandRunwayTableViewController.h"
#import "ModeGood.h"
#import <FMDB.h>

static const CGFloat kJVTableViewTopInset = 30.0;
static NSString * const kJVDrawerCellReuseIdentifier = @"JVDrawerCellReuseIdentifier";

@interface JVLeftDrawerTableViewController ()
@property (weak, nonatomic) IBOutlet UILabel *wishlistCount;
@property (strong, nonatomic) NSMutableArray *clothes;
@property (strong, nonatomic) UIViewController *currentViewController;
@end

@implementation JVLeftDrawerTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor colorWithRed:56/255.f green:56/255.f blue:56/255.f alpha:1];
    self.tableView.contentInset = UIEdgeInsetsMake(kJVTableViewTopInset, 0.0, 0.0, 0.0);
    self.clearsSelectionOnViewWillAppear = NO;
    self.tableView.tableHeaderView.frame = CGRectMake(0, 0, 0, 44);
    
    self.currentViewController = [[AppDelegate globalDelegate] homeViewController];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(modificationWishlistCount:) name:@"modificationWishlistCount" object:nil];
}
-(void)modificationWishlistCount:(NSNotification*)noti{
    self.wishlistCount.text = [noti.userInfo objectForKey:@"wishlistCount"];
}
//初始值设定
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
}

//设置区头和区尾内容和高度 合起来是一根中间的分割线
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 2) {
        return nil;
    } else {
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = [UIColor colorWithRed:122/255.f green:122/255.f blue:122/255.f alpha:0.8];
        return view;
    }
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return nil;
    } else {
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = [UIColor colorWithRed:122/255.f green:122/255.f blue:122/255.f alpha:0.8];
        return view;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    } else {
        return 1.f;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 2) {
        return 0;
    } else {
        return 1.f;
    }
}


//选中某行进行跳转
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIViewController *destinationViewController = nil;
    if (indexPath.section == 0) {
        if(indexPath.row == 0) {
            destinationViewController = [[AppDelegate globalDelegate] homeViewController];
            self.currentViewController = destinationViewController;
        } else {
            destinationViewController = [[AppDelegate globalDelegate] wishlistTableViewController];
            self.currentViewController = destinationViewController;
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            destinationViewController = self.currentViewController;
            [[[AppDelegate globalDelegate] drawerViewController] setCenterViewController:destinationViewController];
            [[AppDelegate globalDelegate] toggleLeftDrawer:self animated:YES];
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"gotoWishlistController" object:nil userInfo:@{@"currentViewController":self.currentViewController,@"count":self.wishlistCount.text}];
            return;
            
        } else if (indexPath.row == 1) {
            destinationViewController = [[AppDelegate globalDelegate] orderViewController];
            self.currentViewController = destinationViewController;
        } else if (indexPath.row == 2) {
            destinationViewController = [[AppDelegate globalDelegate]passbookViewController];
            self.currentViewController = destinationViewController;
        }
    } else if (indexPath.section == 2) {
        if (indexPath.row == 0||indexPath.row ==1) {
            destinationViewController = [[AppDelegate globalDelegate]brandRunwayViewController];
            
        }
    }
    
    
    [[[AppDelegate globalDelegate] drawerViewController] setCenterViewController:destinationViewController];
    [[AppDelegate globalDelegate] toggleLeftDrawer:self animated:YES];
}
-(void)viewWillDisappear:(BOOL)animated{
    NSLog(@"...");
}
-(NSMutableArray *)clothes{
    if (!_clothes) {
        _clothes = [NSMutableArray array];
    }
    return _clothes;
}
-(void)viewWillAppear:(BOOL)animated{
    [self.clothes removeAllObjects];
    [self readDataFromTableWishlist];
    self.wishlistCount.text = [NSString stringWithFormat:@"%d",(int)self.clothes.count];
}
-(void)readDataFromTableWishlist{
    NSString* documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString* path = [documentPath stringByAppendingPathComponent:@"my.sqlite"];
    FMDatabase* db = [FMDatabase databaseWithPath:path];
    if ([db open]) {
        NSLog(@"打开数据库成功");
        FMResultSet* set = [db executeQuery:@"select * from wishlist"];
        while ([set next]) {
            ModeGood* modeGood = [[ModeGood alloc]init];
            modeGood.brand_img_link = [set stringForColumn:@"brand_img_link"];
            modeGood.brand_name = [set stringForColumn:@"brand_name"];
            modeGood.goods_id = [set stringForColumn:@"goods_id"];
            modeGood.img_link = [set stringForColumn:@"img_link"];
            modeGood.has_coupon = [set stringForColumn:@"has_coupon"];
            [self.clothes addObject:modeGood];
        }
        [db close];
    } else {
        NSLog(@"打开数据库失败");
        [db close];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
