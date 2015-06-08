//
//  LikeOrNopeViewController.m
//  Mode
//
//  Created by YedaoDEV on 15/5/25.
//  Copyright (c) 2015年 YedaoDEV. All rights reserved.
//

#import "LikeOrNopeViewController.h"

#import <MDCSwipeToChoose/MDCSwipeToChoose.h>
#import "WishListViewController.h"
#import <FMDB.h>
#import <ASDepthModalViewController.h>
#import "ModeGoodAPI.h"
#import "ModeGood.h"
#import "SDWebImageManager.h"
#import "UIViewController+CWPopup.h"
#import "ShareViewController.h"
//static const CGFloat ChoosePersonButtonHorizontalPadding = 80.f;
//static const CGFloat ChoosePersonButtonVerticalPadding = 35.f;

@interface LikeOrNopeViewController ()<UIAlertViewDelegate,ShareViewControllerDelegate>


@property (nonatomic,assign) CGRect mainFrame;
@property (weak, nonatomic) UILabel *label;
@property (strong, nonatomic) NSMutableArray *allGoods;
@property (strong, nonatomic) NSMutableArray *wishlist;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (strong, nonatomic) UIView* startIntroduceView;
@end

@implementation LikeOrNopeViewController

#pragma mark - Object Lifecycle
-(NSMutableArray *)allGoods{
    if (!_allGoods) {
        _allGoods = [NSMutableArray array];
    }
    return _allGoods;
}
-(NSMutableArray *)wishlist{
    if (!_wishlist) {
        _wishlist = [NSMutableArray array];
    }
    return _wishlist;
}
#pragma mark - UIViewController Overrides
-(void)gotoWishlist:(UIBarButtonItem*)btn{
    [self performSegueWithIdentifier:@"gotoWishlistVC" sender:nil];
//    WishListViewController* wvc = [[WishListViewController alloc]init];
//    [self.navigationController pushViewController:wvc animated:YES];

}
-(void)defineRightBarItem{
    UIView *rightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 34 ,34)];
    UIImageView *bgIV = [[UIImageView alloc]initWithFrame:rightView.bounds];
    bgIV.image = [UIImage imageNamed:@"heart.png"];
    UILabel *l = [[UILabel alloc]initWithFrame:bgIV.bounds];

    l.textAlignment = NSTextAlignmentCenter;
    l.textColor = [UIColor whiteColor];
    self.label = l;
    UIButton *btn = [[UIButton alloc]initWithFrame:rightView.bounds];
    [btn addTarget:self action:@selector(gotoWishlist:) forControlEvents:UIControlEventTouchUpInside];
    [rightView addSubview:bgIV];
    [rightView addSubview:self.label];
    [rightView addSubview:btn];
    UIBarButtonItem* rightBarItem = [[UIBarButtonItem alloc]initWithCustomView:rightView];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    
#warning 临时按钮
    UIBarButtonItem* barItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(comeback:)];
    self.navigationItem.leftBarButtonItem = barItem;
    
}
#pragma mark 临时的按钮
-(void)comeback:(UIBarButtonItem*)btn{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
-(void)viewWillAppear:(BOOL)animated{
    [self.view insertSubview:self.bottomView atIndex:0];
    [self.wishlist removeAllObjects];
    [self readTableWishlistFromDatabase];
    
}
-(void)viewDidAppear:(BOOL)animated{
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showShareViewController) name:@"showShareView" object:nil];
    if (self.label.text.integerValue >= 9) {
        [self showShareViewController];
    }
}
-(void)viewDidDisappear:(BOOL)animated{
//    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"showShareView" object:nil];
}
//读likenope中的数据 一组秀场数据
-(void)readDatabase{
    NSString* documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString* path = [documentPath stringByAppendingPathComponent:@"my.sqlite"];
    FMDatabase* db = [FMDatabase databaseWithPath:path];
    if ([db open]) {
        FMResultSet* set = [db executeQuery:@"select * from likenope"];
        while ([set next]) {
            ModeGood* modeGood = [[ModeGood alloc]init];
            modeGood.goods_id = [set stringForColumn:@"goods_id"];
            modeGood.brand_name = [set stringForColumn:@"brand_name"];
            modeGood.brand_img_link = [set stringForColumn:@"brand_img_link"];
            modeGood.img_link = [set stringForColumn:@"img_link"];
            modeGood.has_coupon = [set stringForColumn:@"has_coupon"];
            [self.allGoods addObject:modeGood];
        }
        [db close];
        self.number = 1;
        self.totalNumber = self.allGoods.count;
        self.tabLabel.text = [NSString stringWithFormat:@"%ld/%ld",self.number,self.totalNumber];
    } else {
        NSLog(@"数据库打开失败");
        [db close];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
#warning 再造一个view在初次进这时显示
//    self.navigationController presentPopupViewController:<#(UIViewController *)#> animated:<#(BOOL)#> completion:<#^(void)completion#>
    
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:20/255.f green:21/255.f blue:20/255.f alpha:1];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self readDatabase];
    
    [self updateUI];
    [self defineRightBarItem];
    
#warning 该方法可以隐藏导航栏左侧自带按钮的文字,目前由于是pesenet过来的   导航栏左侧没有按钮
//    [[UIBarButtonItem appearance]setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60.f) forBarMetrics:UIBarMetricsDefault];
    
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    
    self.title = [self.dictionary objectForKey:@"title"];
    
    
    
}

-(void)showShareViewController{
//    ShareView* shareView = [[[NSBundle mainBundle]loadNibNamed:@"ShareView" owner:nil options:nil]lastObject];
//    shareView.delegate = self;
//    shareView.nineGoods = self.wishlist;
//    NSLog(@"%@",self.wishlist);
    
//    [ASDepthModalViewController presentView:shareView backgroundColor:nil options:ASDepthModalOptionAnimationNone completionHandler:nil];
//    [ASDepthModalViewController presentView:shareView onCurrentViewController:self.navigationController backgroundColor:nil options:ASDepthModalOptionAnimationNone completionHandler:nil];
    
    ShareViewController* shareViewController = [[ShareViewController alloc]initWithNibName:@"ShareViewController" bundle:nil];
    shareViewController.delegate = self;
    shareViewController.nineGoods = self.wishlist;
#warning 加载在导航栏控制器上  该视图控制器就可以居中显示了
    [self.navigationController presentPopupViewController:shareViewController animated:YES completion:nil];
}
#pragma mark ShareViewControllerDelegate
-(void)shareViewController:(ShareViewController *)shareViewController shareNineModeGoodsToOthers:(NSArray *)nineGoods andTextContent:(NSString *)textContent{
#warning 发布信息给服务器
    [self.activityIndicatorView startAnimating];
    [NSThread sleepForTimeInterval:3.f];
    [self.activityIndicatorView stopAnimating];
#warning 成功后移除popupViewController
    [self.navigationController dismissPopupViewControllerAnimated:YES completion:nil];
#warning 清空数据库中9个项目
    BOOL flag = [self clearTableWishlist];
    if (flag) {
        UIAlertView* av = [[UIAlertView alloc]initWithTitle:@"返回" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [av show];
        NSLog(@"321");
    }
}
-(void)dealloc{
    NSLog(@"likeornope页面销毁");
}


//#pragma ShareViewDelegate
//-(void)shareView:(ShareView *)shareView shareNineModeGoodsToOthers:(NSArray *)nineGoods andTextContent:(NSString *)textContent{
//#warning 发布信息给服务器
//#warning 清空数据库中9个项目
//    BOOL flag = [self clearTableWishlist];
//    if (flag) {
//        [ASDepthModalViewController dismiss];
//        NSLog(@"123");
//        [NSThread sleepForTimeInterval:3.f];
//        UIAlertView* av = [[UIAlertView alloc]initWithTitle:@"返回" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
//        [av show];
//        NSLog(@"321");
//    }
//}
#pragma UIAlertViewDelegate
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//    NSLog(@"即将返回前一个页面");
//    if (buttonIndex == 0) {
//        [self dismissViewControllerAnimated:YES completion:nil];
//    }
//}
#pragma 清空wishlist数据
-(BOOL)clearTableWishlist{
    NSString* documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString* path = [documentPath stringByAppendingPathComponent:@"my.sqlite"];
    FMDatabase* db = [FMDatabase databaseWithPath:path];
    if ([db open]) {
        BOOL res = [db executeUpdate:@"delete from wishlist"];
        if (res) {
            NSLog(@"成功清空wishlist");
            self.label.text = @"0";
            [self.wishlist removeAllObjects];
            NSLog(@"%ld",self.wishlist.count);
            [[NSNotificationCenter defaultCenter]postNotificationName:@"modificationWishlistCount" object:nil userInfo:@{@"wishlistCount":self.label.text}];
            return YES;
        } else {
            NSLog(@"未清空wishlist");
        }
    } else {
        NSLog(@"打开数据库失败");
    }
    [db close];
    return NO;
}
#pragma UpdateUI
-(void)updateUI{
    //由于使用自动布局和size class技术  屏幕宽度在首次使用时用常量持久保存，否则首次匹配会有问题
    self.mainFrame = [UIScreen mainScreen].bounds;
    
    
    self.firstCardView = [self popPersonViewWithFrame:[self firstCardViewFrame]];
    self.firstCardView.userInteractionEnabled = YES;
    [self.view addSubview:self.firstCardView];
    
    
    self.secondCardView = [self popPersonViewWithFrame:[self firstCardViewFrame]];
    self.secondCardView.frame = [self scaleRect:self.secondCardView.frame];
    [self.view insertSubview:self.secondCardView belowSubview:self.firstCardView];
    
    self.thirdCardView = [self popPersonViewWithFrame:[self firstCardViewFrame]];
    self.thirdCardView.frame = [self scaleRect:self.secondCardView.frame];
    [self.view insertSubview:self.thirdCardView belowSubview:self.secondCardView];
    
    self.fourthCardView = [self popPersonViewWithFrame:[self firstCardViewFrame]];
    self.fourthCardView.frame = self.thirdCardView.frame;
    [self.view insertSubview:self.fourthCardView belowSubview:self.thirdCardView];
    
//    [self constructNopeButton];
//    [self constructLikedButton];
}
-(CGRect)scaleRect:(CGRect)frame{
    CGRect rect = frame;
    rect.origin.x += 5.f;
    rect.origin.y += 15.f;
    rect.size.width -= 10.f;
    rect.size.height -= 10.f;
    return rect;
}

-(void)readTableWishlistFromDatabase{
    NSString* documentPath=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString*path=[documentPath stringByAppendingPathComponent:@"my.sqlite"];
    FMDatabase* db = [FMDatabase databaseWithPath:path];
    if ([db open]) {
        FMResultSet* set = [db executeQuery:@"select * from wishlist"];
        while ([set next]) {
            ModeGood* modeGood = [[ModeGood alloc]init];
            modeGood.brand_img_link = [set stringForColumn:@"brand_img_link"];
            modeGood.brand_name = [set stringForColumn:@"brand_name"];
            modeGood.goods_id = [set stringForColumn:@"goods_id"];
            modeGood.img_link = [set stringForColumn:@"img_link"];
            modeGood.has_coupon = [set stringForColumn:@"has_coupon"];
            [self.wishlist addObject:modeGood];
        }
        self.label.text = [NSString stringWithFormat:@"%d",(int)self.wishlist.count];
        [db close];
    } else {
        [db close];
        NSLog(@"数据库打开失败");
    }
    
}
- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - MDCSwipeToChooseDelegate Protocol Methods

// This is called when a user didn't fully swipe left or right.
- (void)viewDidCancelSwipe:(UIView *)view {
    NSLog(@"You couldn't decide on %@.", self.currentCloth.goods_id);
}

// This is called then a user swipes the view fully left or right.
- (void)view:(UIView *)view wasChosenWithDirection:(MDCSwipeDirection)direction {
    if (self.number<self.totalNumber) {
        self.number++;
    }
    self.tabLabel.text = [NSString stringWithFormat:@"%ld/%ld",self.number,self.totalNumber];
    // MDCSwipeToChooseView shows "NOPE" on swipes to the left,
    // and "LIKED" on swipes to the right.
    if (direction == MDCSwipeDirectionLeft) {
        //Nope goods
        [ModeGoodAPI setGoodsFeedbackWithParams:@{@"goods_id":self.currentCloth.goods_id,@"fd":@"nope"} andCallback:^(id obj) {
            NSLog(@"%@",[obj objectForKey:@"status"]);
        }];
        // remove nope goods-Image from Disk
        [[SDImageCache sharedImageCache] removeImageForKey:[self.currentCloth.img_link lastPathComponent] fromDisk:YES];
    } else {
        //Like goods
        [ModeGoodAPI setGoodsFeedbackWithParams:@{@"goods_id":self.currentCloth.goods_id,@"fd":@"nope"} andCallback:^(id obj) {
            if ([[obj objectForKey:@"status"]isEqualToString:@"success"]) {
                [self  writeCurrentClothIntoTableWishlist];
            };
        }];
        [self.wishlist addObject:self.currentCloth];
        //判断移动方向为右则添加进数组
        int count = self.label.text.intValue;
        count++;
        self.label.text = [NSString stringWithFormat:@"%d",count];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"modificationWishlistCount" object:nil userInfo:@{@"wishlistCount":self.label.text}];
        if (self.label.text.intValue == 9) {
            [self showShareViewController];
        }
        
        
    }
    
    
    
    // MDCSwipeToChooseView removes the view from the view hierarchy
    // after it is swiped (this behavior can be customized via the
    // MDCSwipeOptions class). Since the front card view is gone, we
    // move the back card to the front, and create a new back card.
    self.firstCardView = self.secondCardView;
    self.firstCardView.userInteractionEnabled = YES;
    self.secondCardView = self.thirdCardView;
    self.thirdCardView = self.fourthCardView;
    if ((self.fourthCardView = [self popPersonViewWithFrame:[self firstCardViewFrame]])) {
        self.fourthCardView.frame = [self fourthCardViewFrame];
        [self.view insertSubview:self.fourthCardView belowSubview:self.thirdCardView];
    }
}
- (void)dismissPopup {
    if (self.popupViewController != nil) {
        [self dismissPopupViewControllerAnimated:YES completion:^{
            NSLog(@"popup view dismissed");
        }];
    }
}
-(void)writeCurrentClothIntoTableWishlist{
    NSString* documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString*path=[documentPath stringByAppendingPathComponent:@"my.sqlite"];
    FMDatabase* db = [FMDatabase databaseWithPath:path];
    if ([db open]) {
        BOOL res = [db executeUpdate:@"CREATE TABLE IF NOT EXISTS wishlist (goods_id primary key ,brand_img_link,brand_name,img_link,has_coupon)"];
        if (res) {
            NSLog(@"创建或打开wishlist成功");
            res = [db executeUpdate:@"replace into wishlist(goods_id,brand_img_link,brand_name,img_link,has_coupon)values(?,?,?,?,?)",self.currentCloth.goods_id,self.currentCloth.brand_img_link,self.currentCloth.brand_name,self.currentCloth.img_link,self.currentCloth.has_coupon];
            if (res) {
                NSLog(@"insert wishlist success");
            } else {
                NSLog(@"insert wishlist failure");
            }
            [db close];
        }
    } else {
        [db close];
        NSLog(@"打开数据库失败");
    }
}
#pragma mark - Internal Methods
- (void)setFirstCardView:(ChooseClothesView *)firstCardView {
    // Keep track of the person currently being chosen.
    // Quick and dirty, just for the purposes of this sample app.
    _firstCardView = firstCardView;
    self.currentCloth = firstCardView.modeGood;
}
- (ChooseClothesView *)popPersonViewWithFrame:(CGRect)frame {
    if ([self.allGoods count] == 0) {
        return nil;
    }
    // UIView+MDCSwipeToChoose and MDCSwipeToChooseView are heavily customizable.
    // Each take an "options" argument. Here, we specify the view controller as
    // a delegate, and provide a custom callback that moves the back card view
    // based on how far the user has panned the front card view.
    MDCSwipeToChooseViewOptions *options = [MDCSwipeToChooseViewOptions new];
    options.delegate = self;
    options.threshold = 80.f;
    options.onPan = ^(MDCPanState *state){
        CGRect frame = [self secondCardViewFrame];
        self.secondCardView.frame = CGRectMake(frame.origin.x - 5.f * state.thresholdRatio,
                                               frame.origin.y - state.thresholdRatio * 15.f,
                                               CGRectGetWidth(frame) + 10.f *state.thresholdRatio,
                                               CGRectGetHeight(frame) +10.f*state.thresholdRatio);

        frame = [self thirdCardViewFrame];
        self.thirdCardView.frame = CGRectMake(frame.origin.x - 5.f * state.thresholdRatio,
                                              frame.origin.y - state.thresholdRatio * 15.f,
                                              CGRectGetWidth(frame) + 10.f *state.thresholdRatio,
                                              CGRectGetHeight(frame) +10.f*state.thresholdRatio);
        
    };

    ChooseClothesView *clothesView = [[ChooseClothesView alloc] initWithFrame:frame
                                                                    modeGood:self.allGoods[0]
                                                                   options:options];
    clothesView.userInteractionEnabled = NO;
    
    [self.allGoods removeObjectAtIndex:0];
    
    return clothesView;
}

#pragma mark View Contruction

- (CGRect)firstCardViewFrame {
    
    CGFloat horizontalPadding = 30.f;
    CGFloat topPadding = 25.f;
    CGFloat width = CGRectGetWidth(self.mainFrame) - 2 * horizontalPadding;
    CGFloat height = width + 30.f;
    return CGRectMake(horizontalPadding,
                      topPadding,
                      width,
                      height);
}

- (CGRect)secondCardViewFrame {
    CGRect frontFrame = [self firstCardViewFrame];
    
    return [self scaleRect:frontFrame];
}
- (CGRect)thirdCardViewFrame {
    CGRect frontFrame = [self secondCardViewFrame];
    return [self scaleRect:frontFrame];
}
- (CGRect)fourthCardViewFrame {
    return [self thirdCardViewFrame];
    
}
//// Create and add the "nope" button.
//- (void)constructNopeButton {
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [button setBackgroundColor:[UIColor grayColor]];
//    UIImage *image = [UIImage imageNamed:@"hand_left.png"];
//    button.frame = CGRectMake(ChoosePersonButtonHorizontalPadding,
//                              CGRectGetMaxY(self.secondCardView.frame) + ChoosePersonButtonVerticalPadding*2,
//                              image.size.width,
//                              image.size.height);
//    [button setImage:image forState:UIControlStateNormal];
//    [button setTintColor:[UIColor colorWithRed:247.f/255.f
//                                         green:91.f/255.f
//                                          blue:37.f/255.f
//                                         alpha:1.f]];
//    [button addTarget:self
//               action:@selector(nopeFrontCardView)
//     forControlEvents:UIControlEventTouchUpInside];
//    [self.view insertSubview:button atIndex:0];
//}
//
//// Create and add the "like" button.
//- (void)constructLikedButton {
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [button setBackgroundColor:[UIColor grayColor]];
//    UIImage *image = [UIImage imageNamed:@"hand_right.png"];
//    button.frame = 
//    button.frame = CGRectMake(CGRectGetMaxX(self.mainFrame) - image.size.width - ChoosePersonButtonHorizontalPadding,
//                              CGRectGetMaxY(self.secondCardView.frame) + ChoosePersonButtonVerticalPadding*2,
//                              image.size.width,
//                              image.size.height);
//    [button setImage:image forState:UIControlStateNormal];
//    [button setTintColor:[UIColor colorWithRed:29.f/255.f
//                                         green:245.f/255.f
//                                          blue:106.f/255.f
//                                         alpha:1.f]];
//    [button addTarget:self
//               action:@selector(likeFrontCardView)
//     forControlEvents:UIControlEventTouchUpInside];
//    [self.view insertSubview:button atIndex:0];
//}

#pragma mark Control Events

//// Programmatically "nopes" the front card view.
//- (void)nopeFrontCardView {
//    [self.firstCardView mdc_swipe:MDCSwipeDirectionLeft];
//}
//
//
//// Programmatically "likes" the front card view.
//- (void)likeFrontCardView {
//    [self.firstCardView mdc_swipe:MDCSwipeDirectionRight];
//}
- (IBAction)likeFrontCardView:(UIButton *)sender {
    [self.firstCardView mdc_swipe:MDCSwipeDirectionRight];
}

- (IBAction)nopeFrontCardView:(UIButton *)sender {
    [self.firstCardView mdc_swipe:MDCSwipeDirectionLeft];
}


//-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
//    WishListViewController* wvc = segue.destinationViewController;
//    wvc.comfirmValue = sender;
//}
@end

