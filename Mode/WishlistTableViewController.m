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
#import "UIColor+HexString.h"
#import "WishListViewController.h"
@interface WishlistTableViewController ()

@property (strong, nonatomic) NSMutableArray *wishlists;
@property (strong, nonatomic) UIRefreshControl *refresh;
@property (weak, nonatomic) IBOutlet UIImageView *brand_img;

@end

@implementation WishlistTableViewController


-(void)gotoWishlistController:(NSNotification*)noti{
    if ([[noti.userInfo objectForKey:@"currentViewController"] isKindOfClass:[self.parentViewController class]]
        &&(![[noti.userInfo objectForKey:@"count"]isEqualToString:@"0"])) {
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"gotoWishlistController"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    } else {
        UIAlertView* av = [[UIAlertView alloc]initWithTitle:@"Caution" message:@"Please choose some your liked fashion goods first" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        NSLog(@"wishlistTable");
        [av show];
    }
}
-(void)viewDidAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"gotoWishlistController" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(gotoWishlistController:) name:@"gotoWishlistController" object:nil];
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"gotoWishlistController"]) {
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"gotoWishlistController"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        WishListViewController*wlvc = [[AppDelegate globalDelegate].drawersStoryboard instantiateViewControllerWithIdentifier:@"WishlistNavigationController"];
        [self.navigationController presentViewController:wlvc animated:YES completion:nil];
    }
}
-(void)viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"gotoWishlistController" object:nil];
}

- (IBAction)actionToggleLeftDrawer:(UIBarButtonItem *)sender {
    [[AppDelegate globalDelegate] toggleLeftDrawer:self animated:YES];
}
-(NSMutableArray *)wishlists{
    if (!_wishlists) {
        _wishlists = [NSMutableArray array];
    }
    return _wishlists;
}
-(void)initUI{
    self.brand_img.layer.borderWidth = 1.f;
    self.brand_img.layer.cornerRadius = 29.f;
    self.brand_img.layer.borderColor = [UIColor clearColor].CGColor;
    self.brand_img.image = [UIImage imageNamed:@"headPortrait.png"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Profile";
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue" size:20],NSForegroundColorAttributeName:[UIColor whiteColor]};
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:@"#1b1b1b"];
    [[UIBarButtonItem appearance]setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60.f) forBarMetrics:UIBarMetricsDefault];
    
    if ([[[UIDevice currentDevice]systemVersion ]floatValue]>=7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [self initUI];
    
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


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    ModeWishlist* modewishlist = self.wishlists[indexPath.row];
    return [modewishlist getCommentHeightByLabelWidth:(CGRectGetWidth(tableView.bounds)-80.f-20.f)]+170.f+15.f;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.wishlists.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30.f;
}
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"AAAAAAAA";
}
#pragma mark -UITableViewDelegate
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
    if ([segue.identifier isEqualToString:@"gotoCash"]) {
        
    } else if ([segue.identifier isEqualToString:@"gotoWishlist2"]) {
        UINavigationController* navi=[segue destinationViewController];
        WishListViewController* wvc = (WishListViewController*)navi.topViewController;
        wvc.receiveArr = sender;
    }
    
}


@end
