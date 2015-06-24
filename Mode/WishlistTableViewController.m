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
#import "ModeProfilesAPI.h"
#import "ProfileInfo.h"
#import "QBArrowRefreshControl.h"
#import "TAlertView.h"
#import "CashViewController.h"
#import "CollectionItem.h"
#import "WishlistHeadView.h"
#import "WishlistTableSectionHeaderView.h"
@interface WishlistTableViewController ()<QBRefreshControlDelegate,WishlistHeadViewDelegate>

@property (strong, nonatomic) NSMutableArray *modeCollections;

@property (strong, nonatomic) QBArrowRefreshControl *myRefreshControl;
//@property (weak, nonatomic) IBOutlet UIImageView *brand_img;//用户头像 暂时用系统自定义头像
//
//@property (weak, nonatomic) IBOutlet UILabel *following;
//@property (weak, nonatomic) IBOutlet UILabel *likes;
//@property (weak, nonatomic) IBOutlet UILabel *invitaions;
//@property (weak, nonatomic) IBOutlet UILabel *money;

@property (weak, nonatomic) IBOutlet WishlistHeadView *headV;

@property (strong, nonatomic) ProfileInfo *profileInfo;

@end

@implementation WishlistTableViewController

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

-(NSMutableArray *)modeCollections{
    if (!_modeCollections) {
        _modeCollections = [NSMutableArray array];
    }
    return _modeCollections;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Profile";
    self.tableView.sectionHeaderHeight = 30;
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue" size:20],NSForegroundColorAttributeName:[UIColor whiteColor]};
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:@"#1b1b1b"];
    [[UIBarButtonItem appearance]setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60.f) forBarMetrics:UIBarMetricsDefault];
    
    if ([[[UIDevice currentDevice]systemVersion ]floatValue]>=7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }

    self.tableView.tableHeaderView = self.headV;
    UIView* view = self.tableView.tableHeaderView;
    view.frame = CGRectMake(0, 0, 0, 125);
    self.tableView.tableHeaderView = view;
    
    self.headV.delegate = self;
    [self getDataFromNetwork];
//    self.tableView.tableHeaderView.bounds = CGRectMake(0, 0, 0, 185);
 
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, -400, 320, 400)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.tableView addSubview:bgView];
    QBArrowRefreshControl *refreshControl = [[QBArrowRefreshControl alloc] init];
    refreshControl.delegate = self;
    [self.tableView addSubview:refreshControl];
    self.myRefreshControl = refreshControl;
    
    NSLog(@"%@",NSStringFromCGRect(self.headV.frame));
    
}
#pragma mark - QBRefreshControlDelegate

- (void)refreshControlDidBeginRefreshing:(QBRefreshControl *)refreshControl{
    [self getDataFromNetwork];
}

-(void)getDataFromNetwork{
    [ModeProfilesAPI requestProfilesAndCallback:^(id obj) {
        [self.myRefreshControl endRefreshing];
        if (![obj isKindOfClass:[NSNull class]]) {
            self.headV.profileInfo = obj;
            self.profileInfo = obj;
            UIView* view = self.tableView.tableHeaderView;
            if (self.profileInfo.likes.integerValue == 0) {
                view.frame = CGRectMake(0, 0, 0, 125);
            } else {
                view.frame = CGRectMake(0, 0, 0, 185);
            }
            self.tableView.tableHeaderView = view;
            [self.headV setNeedsLayout];
        } else {
            [self showAlertViewWithErrorInfo:@"Net error.Please try it again."];
        }
        
    }];
    [ModeWishlistAPI requestCollectionsAndCallback:^(id obj) {
        [self.myRefreshControl endRefreshing];
        if (![obj isKindOfClass:[NSNull class]]) {
            [self.modeCollections removeAllObjects];
            [self.modeCollections addObjectsFromArray:obj];
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
    ModeCollection* modeCollection = self.modeCollections[indexPath.row];
    return [modeCollection getCommentHeightByLabelWidth:(CGRectGetWidth(tableView.bounds)-80.f-20.f)]+170.f+15.f;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.modeCollections.count;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    WishlistTableSectionHeaderView* sectionHeaderView = [WishlistTableSectionHeaderView headerViewWithTableView:tableView];
    if (self.modeCollections.count == 0) {
        sectionHeaderView.headerString = @"Nothing";
        self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    } else {
        sectionHeaderView.headerString = @"TASTE STUDIO";
        self.tableView.separatorStyle = UITableViewCellSelectionStyleDefault;
    }
    return sectionHeaderView;
}

#pragma mark -UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* reuseIdentifier = @"Cell";
    WishlistTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"WishlistTableViewCell" owner:nil options:nil]lastObject];
    }
    cell.modeCollection = self.modeCollections[indexPath.row];
    return cell;
}
-(void)viewWillAppear:(BOOL)animated{
    self.tableView.userInteractionEnabled = YES;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.tableView.userInteractionEnabled = NO;
    ModeCollection* modeCollection = self.modeCollections[indexPath.row];
    [ModeWishlistAPI requestCollectionItems:modeCollection.collectionId AndCallback:^(id obj) {
        if(![obj isKindOfClass:[NSNull class]]) {
            NSArray* array = obj;
            if (array.count>0) {
                self.tableView.userInteractionEnabled = YES;
                [self performSegueWithIdentifier:@"gotoWishlist2" sender:obj];
            } else {
                [self showAlertViewWithErrorInfo:@"That is null link"];
                
            }
            
        } else {
            self.tableView.userInteractionEnabled = YES;
        }
    }];
}

////隐藏多余的分割线
//- (void)setExtraCellLineHidden: (UITableView *)tableView{
//    UIView *view =[ [UIView alloc]init];
//    view.backgroundColor = [UIColor clearColor];
//    [tableView setTableFooterView:view];
////    [tableView setTableHeaderView:view];
//}
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
#pragma mark WishlistHeadViewDelegate
-(void)wishlistHeadView:(WishlistHeadView *)wishlistHeadView didClickGoToCashListWith:(NSString *)cash{
    [self performSegueWithIdentifier:@"gotoCash" sender:cash];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"gotoCash"]) {
        CashViewController*cc = [segue destinationViewController];
        cc.currentCash = sender;
    } else if ([segue.identifier isEqualToString:@"gotoWishlist2"]) {
        UINavigationController* navi=[segue destinationViewController];
        WishListViewController* wvc = (WishListViewController*)navi.topViewController;
        wvc.receiveArr = sender;
    }
    
}


@end
