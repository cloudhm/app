//
//  SettingTableViewController.m
//  Mode
//
//  Created by YedaoDEV on 15/6/11.
//  Copyright (c) 2015年 YedaoDEV. All rights reserved.
//

#import "SettingTableViewController.h"
#import "AppDelegate.h"
#import "UIColor+HexString.h"
#import "WishListViewController.h"
#import "UIViewController+CWPopup.h"
#import "ConsigneeNameViewController.h"
#import "TAlertView.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
@interface SettingTableViewController ()<ConsigneeNameViewControllerDelegate>
@property (strong, nonatomic) ConsigneeNameViewController *consigneeNameViewController;
@end

@implementation SettingTableViewController

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
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changePosition:) name:UIKeyboardWillChangeFrameNotification object:nil];
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
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"gotoWishlistController" object:nil];
}
-(void)changePosition:(NSNotification*)noti{
    NSTimeInterval timeDuration = [[noti.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey]floatValue];
    CGRect startRect = [[noti.userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey]CGRectValue];
    CGRect endRect = [[noti.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue];
    CGRect rect = self.consigneeNameViewController.view.frame;
    rect.origin.y = startRect.origin.y>endRect.origin.y? -30.f:+30.f;
    [UIView animateWithDuration:timeDuration animations:^{
        self.consigneeNameViewController.view.frame = rect;
    } completion:nil];
}

- (IBAction)actionToggleLeftDrawer:(UIBarButtonItem *)sender {
    [[AppDelegate globalDelegate] toggleLeftDrawer:self animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Settings";
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue" size:20],NSForegroundColorAttributeName:[UIColor whiteColor]};
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:@"#1b1b1b"];
    [self setExtraCellLineHidden:self.tableView];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


//隐藏多余的分割线
- (void)setExtraCellLineHidden: (UITableView *)tableView{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    [tableView setTableHeaderView:view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
#pragma mark UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.row) {
        case 0:
        {
            self.tableView.userInteractionEnabled = NO;
            self.consigneeNameViewController = [[ConsigneeNameViewController alloc]initWithNibName:@"ConsigneeNameViewController" bundle:nil];
            self.consigneeNameViewController.delegate = self;
            [self.navigationController presentPopupViewController:self.consigneeNameViewController animated:YES completion:nil];
        }
            break;
        case 1:
        {
            
        }
            break;
        default:
        {
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"utime"];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"userId"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            LoginViewController *lvc = [[AppDelegate globalDelegate].drawersStoryboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
            [AppDelegate globalDelegate].window.rootViewController = lvc;
            
        }
            break;
    }
}
#pragma mark ConsigneeNameViewControllerDelegate
-(void)consigneeNameViewController:(ConsigneeNameViewController *)consigneeNameViewController comfirmInputConsigneeName:(NSString *)consigneeName{
    [[NSUserDefaults standardUserDefaults]setObject:consigneeName forKey:@"consigneeName"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [self dismissconsigneeNameViewController:consigneeNameViewController];
//    [self showTAlertViewWithTitle:@"Operation success!"];

}
-(void)showTAlertViewWithTitle:(NSString*)title{
    TAlertView *alert = [[TAlertView alloc] initWithTitle:title andMessage:nil];
    alert.style = TAlertViewStyleSuccess;
    [alert show];
}
-(void)dismissconsigneeNameViewController:(ConsigneeNameViewController *)consigneeNameViewContorller{
    self.tableView.userInteractionEnabled = YES;
    [self.navigationController dismissPopupViewControllerAnimated:YES completion:nil];
    self.consigneeNameViewController = nil;
}
/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
