//
//  WishlistTableViewController.m
//  Mode
//
//  Created by YedaoDEV on 15/6/1.
//  Copyright (c) 2015年 YedaoDEV. All rights reserved.
//

#import "WishlistTableViewController.h"
#import "PrefixHeader.pch"
#import "ModeWishlistAPI.h"
#import "WishlistTableViewCell.h"
#import "WishListViewController.h"
#import "AppDelegate.h"
@interface WishlistTableViewController ()

@property (strong, nonatomic) NSMutableArray *wishlists;
@property (strong, nonatomic) UIRefreshControl *refresh;
@end

@implementation WishlistTableViewController
- (IBAction)actionToggleLeftDrawer:(UIBarButtonItem *)sender {
    [[AppDelegate globalDelegate] toggleLeftDrawer:self animated:YES];
}
-(NSMutableArray *)wishlists{
    if (!_wishlists) {
        _wishlists = [NSMutableArray array];
    }
    return _wishlists;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if ([[[UIDevice currentDevice]systemVersion ]floatValue]>=7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:20/255.f green:21/255.f blue:21/255.f alpha:1];
    [self getDataFromNetwork];
    self.tableView.tableHeaderView.bounds = CGRectMake(0, 0, 0, 185);
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.refresh = [[UIRefreshControl alloc]init];
    [self.refresh addTarget:self action:@selector(refreshView) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refresh];
}
-(void)refreshView{
    [ModeWishlistAPI requestWishlistsAndCallback:^(id obj) {
        [self.refresh endRefreshing];
        if (![obj isKindOfClass:[NSNull class]]) {
            [self.wishlists removeAllObjects];
            [self.wishlists addObjectsFromArray:obj];
            [self.tableView reloadData];
        } else {
            NSLog(@"....");
        }
    }];
}
-(void)getDataFromNetwork{
    [ModeWishlistAPI requestWishlistsAndCallback:^(id obj) {
        if (![obj isKindOfClass:[NSNull class]]) {
            [self.wishlists removeAllObjects];
            [self.wishlists addObjectsFromArray:obj];
            [self.tableView reloadData];
        } else {
            NSLog(@"failure");
        }
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    ModeWishlist* modewishlist = self.wishlists[indexPath.row];
    NSLog(@"cell:%f",[modewishlist getCommentHeightByLabelWidth:(CGRectGetWidth(tableView.bounds)-80.f-20.f)]);
    return [modewishlist getCommentHeightByLabelWidth:(CGRectGetWidth(tableView.bounds)-80.f-20.f)]+170.f+15.f;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.wishlists.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30.f;
}
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
#warning 这里不能用带属性的字符串，如需要修改sectionTitle 则需要用添加视图的方法来做
//    NSDictionary* attributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:20],NSForegroundColorAttributeName:[UIColor grayColor]};
//    NSAttributedString* headStr = [[NSAttributedString alloc]initWithString:@"123123" attributes:attributes];
    
    return @"123123";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* reuseIdentifier = @"Cell";
    WishlistTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"WishlistTableViewCell" owner:nil options:nil]lastObject];
    }
    cell.modeWishlist = self.wishlists[indexPath.row];
    return cell;
}
-(void)viewWillAppear:(BOOL)animated{
    self.tableView.userInteractionEnabled = YES;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.tableView.userInteractionEnabled = NO;
    ModeWishlist* wishlist = self.wishlists[indexPath.row];
    [ModeWishlistAPI requestWishlistsByWishlist_ID:wishlist.wishlist_id AndCallback:^(id obj) {
        if(![obj isKindOfClass:[NSNull class]]) {
            [self performSegueWithIdentifier:@"gotoWishlist2" sender:obj];
//            WishListViewController*wvc = [[WishListViewController alloc]init];
//            [self.navigationController pushViewController:wvc animated:YES];
        } else {
            self.tableView.userInteractionEnabled = YES;
        }
    }];
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    WishListViewController* wvc=[segue destinationViewController];
    wvc.receiveArr = sender;
}


@end
