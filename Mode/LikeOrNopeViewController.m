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

#import "ModeGoodAPI.h"
#import "ModeGood.h"
#import "SDWebImageManager.h"
#import "UIViewController+CWPopup.h"
#import "ShareViewController.h"
#import "UIColor+HexString.h"
#import "AppDelegate.h"
//static const CGFloat ChoosePersonButtonHorizontalPadding = 80.f;
//static const CGFloat ChoosePersonButtonVerticalPadding = 35.f;

@interface LikeOrNopeViewController ()<UIAlertViewDelegate,ShareViewControllerDelegate>


@property (nonatomic,assign) CGRect mainFrame;
@property (weak, nonatomic) UILabel *label;
@property (strong, nonatomic) NSMutableArray *allGoods;
@property (strong, nonatomic) NSMutableArray *wishlist;
@property (strong, nonatomic) UIView *startIntroduceView;
@property (nonatomic,assign) BOOL anotherFlag;
@end

@implementation LikeOrNopeViewController


#pragma mark - Object Lifecycle
-(NSMutableArray *)allGoods{//准备接受一组秀场的数组
    if (!_allGoods) {
        _allGoods = [NSMutableArray array];
    }
    return _allGoods;
}
-(NSMutableArray *)wishlist{//喜欢产品的数组，从数据库先读取
    if (!_wishlist) {
        _wishlist = [NSMutableArray array];
    }
    return _wishlist;
}
#pragma mark - 跳转至Wishlist页面
-(void)gotoWishlist:(UIBarButtonItem*)btn{
    if (self.label.text.integerValue>0) {
        [self performSegueWithIdentifier:@"gotoWishlistVC" sender:nil];
    } else {
        UIAlertView* av = [[UIAlertView alloc]initWithTitle:@"Hi,Friend!" message:@"Please choose some your liked fashion goods first" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [av show];
    }
}
//定义导航栏右侧按钮
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
    
#warning 临时左侧按钮
    UIBarButtonItem* barItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(comeback:)];
    self.navigationItem.leftBarButtonItem = barItem;
}
#pragma mark －临时左侧按钮
-(void)comeback:(UIBarButtonItem*)btn{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
//页面即将显示 将bottomView插入至视图底部位置
-(void)viewWillAppear:(BOOL)animated{
    [self.view insertSubview:self.bottomView atIndex:0];
    [self.wishlist removeAllObjects];
    [self readTableWishlistFromDatabase];
    self.view.userInteractionEnabled = YES;
}
//如果上一次未完成分享  会弹出分享视图
-(void)viewDidAppear:(BOOL)animated{
    if (self.label.text.integerValue >= 9) {
        [self showShareViewController];
    }
}
//读likenope中的数据 一组秀场数据 存入allGoods数组中
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
//点击手势 去除开场遮盖
-(void)tap:(UITapGestureRecognizer*)gr{
    self.startIntroduceView=gr.view;
    [UIView animateWithDuration:0.5f animations:^{
        self.startIntroduceView.alpha = 0.f;
    } completion:^(BOOL finished) {
        [self.startIntroduceView removeFromSuperview];
        self.startIntroduceView =nil;
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.parentViewController setNeedsStatusBarAppearanceUpdate];
#warning 再造一个view在初次进这时显示
    [self createStartIntroduceView];//创建一个开场遮盖
    self.title = [[self.dictionary objectForKey:@"title"]uppercaseString];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:@"#1b1b1b"];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue" size:20],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self readDatabase];
    
    [self updateUI];
    [self defineRightBarItem];
    self.anotherFlag = NO;
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}
//开场遮盖
-(void)createStartIntroduceView{
    if (!self.startIntroduceView) {
        self.startIntroduceView = [[UIView alloc]initWithFrame:self.navigationController.view.bounds];
        self.startIntroduceView.backgroundColor = [UIColor colorWithHexString:@"#1b1b1b"];
        self.startIntroduceView.alpha= 0.7f;
        UILabel * titleLabel = [[UILabel alloc]init];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.numberOfLines = 0;
        NSDictionary* attributes =@{NSFontAttributeName:[UIFont fontWithName:@"Verdana-Bold" size:17],NSForegroundColorAttributeName:[UIColor colorWithRed:202/255.f green:228/255.f blue:194/255.f alpha:1]};
        titleLabel.attributedText = [[NSAttributedString alloc]initWithString:[self.dictionary objectForKey:@"intro_title"]attributes:attributes];
        CGRect rect = [titleLabel.text boundingRectWithSize:CGSizeMake(220, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
        titleLabel.frame = CGRectMake((CGRectGetWidth(self.navigationController.view.bounds) - 220.f)/2, CGRectGetHeight(self.navigationController.view.bounds)/2 - 100.f, 220, rect.size.height + 10.f);
        [self.startIntroduceView addSubview:titleLabel];
        
        UILabel * descLabel = [[UILabel alloc]init];
        descLabel.numberOfLines = 0;
        descLabel.text = [self.dictionary objectForKey:@"intro_desc"] ;
        descLabel.font = [UIFont fontWithName:@"Georgia-Italic" size:15];
        descLabel.textColor = [UIColor whiteColor];
        descLabel.textAlignment = NSTextAlignmentCenter;
        rect = [descLabel.text boundingRectWithSize:CGSizeMake(220.f, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Georgia-Italic" size:15],NSForegroundColorAttributeName:[UIColor whiteColor]} context:nil];
        descLabel.frame = CGRectMake(CGRectGetMinX(titleLabel.frame), CGRectGetMaxY(titleLabel.frame)+10.f, 220.f, rect.size.height + 10.f);
        [self.startIntroduceView addSubview:descLabel];
        
        UIView* lineView = [[UIView alloc]initWithFrame:CGRectMake((CGRectGetWidth(self.navigationController.view.bounds)-60.f)/2, CGRectGetMaxY(descLabel.frame) +10.f, 60.f, 2.f)];
        lineView.backgroundColor = [UIColor whiteColor];
        [self.startIntroduceView addSubview:lineView];
        
        UITapGestureRecognizer* tapGr = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
        [self.startIntroduceView addGestureRecognizer:tapGr];
        [self.navigationController.view addSubview:self.startIntroduceView];
    }
}
//九宫格弹出的控件
-(void)showShareViewController{
    ShareViewController* shareViewController = [[ShareViewController alloc]initWithNibName:@"ShareViewController" bundle:nil];
    shareViewController.delegate = self;
    shareViewController.nineGoods = self.wishlist;
#warning 加载在导航栏控制器上  该视图控制器就可以居中显示了
    [self.navigationController presentPopupViewController:shareViewController animated:YES completion:nil];
}
#pragma mark ShareViewControllerDelegate
-(void)shareViewController:(ShareViewController *)shareViewController shareNineModeGoodsToOthers:(NSArray *)nineGoods andTextContent:(NSString *)textContent startAnimation:(UIActivityIndicatorView *)activityView{
    [activityView startAnimating];
#warning 发布信息给服务器
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [NSThread sleepForTimeInterval:5.f];
        dispatch_async(dispatch_get_main_queue(), ^{
            [activityView stopAnimating];
            [self.navigationController dismissPopupViewControllerAnimated:YES completion:nil];
        });
    });
    self.navigationItem.rightBarButtonItem.enabled = YES;
#warning 清空数据库中9个项目
    BOOL flag = [self clearTableWishlist];
#warning 成功后移除ShareViewController
    [self.navigationController dismissPopupViewControllerAnimated:YES completion:nil];
#warning 如果没有商品可选弹出第一个AlertView  有可选则第二个
    if (self.tabLabel.text.integerValue>=self.totalNumber) {
        [self finishOneSetAndReadyComeback];
        return ;
    }
    if (flag) {
        UIAlertView* av = [[UIAlertView alloc]initWithTitle:@"Nice!" message:@"Whether to continue" delegate:self cancelButtonTitle:@"Back" otherButtonTitles:@"Continue",nil];
        av.tag = 1;
        [av show];
    }
}

-(void)dealloc{
    NSLog(@"likeornope页面销毁");
}
//完成整组秀场弹出的alertView
-(void)finishOneSetAndReadyComeback{
    UIAlertView* av = [[UIAlertView alloc]initWithTitle:@"Nice!" message:@"The set has been finished,please come back and choose another set" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    av.tag = 2;
    [av show];
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1) {
        if (buttonIndex == alertView.cancelButtonIndex) {
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        } else {
            NSLog(@"before open:%@",self);
            self.view.userInteractionEnabled = YES;
            self.firstCardView.userInteractionEnabled = YES;
        }
    } else if (alertView.tag == 2) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}
#pragma mark 清空wishlist数据
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
#pragma mark UpdateUI
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

}
//根据一个现有尺寸修改，返回一个尺寸
-(CGRect)scaleRect:(CGRect)frame{
    CGRect rect = frame;
    rect.origin.x += 5.f;
    rect.origin.y += 15.f;
    rect.size.width -= 10.f;
    rect.size.height -= 10.f;
    return rect;
}
//从数据库中读取wishlist列表
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

#pragma mark - MDCSwipeToChooseDelegate Protocol Methods 手势

// This is called when a user didn't fully swipe left or right.
- (void)viewDidCancelSwipe:(UIView *)view {
    NSLog(@"You couldn't decide on %@.", self.currentCloth.goods_id);
}

// This is called then a user swipes the view fully left or right.
- (void)view:(UIView *)view wasChosenWithDirection:(MDCSwipeDirection)direction {
    self.number++;
    self.tabLabel.text = [NSString stringWithFormat:@"%d/%d",(int)(self.number>self.totalNumber?12:self.number),(int)self.totalNumber];
    if (direction == MDCSwipeDirectionLeft) {
        //Nope goods
        [ModeGoodAPI setGoodsFeedbackWithParams:@{@"goods_id":self.currentCloth.goods_id,@"fd":@"nope"} andCallback:^(id obj) {
            NSLog(@"nope:%@",[obj objectForKey:@"status"]);
        }];
        // remove nope goods-Image from Disk
        [[SDImageCache sharedImageCache] removeImageForKey:[self.currentCloth.img_link lastPathComponent] fromDisk:YES];
        
    } else {
        //Like goods
        [self  writeCurrentClothIntoTableWishlist];//写入数据库
        [ModeGoodAPI setGoodsFeedbackWithParams:@{@"goods_id":self.currentCloth.goods_id,@"fd":@"like"} andCallback:^(id obj) {
            if ([[obj objectForKey:@"status"]isEqualToString:@"success"]) {
                NSLog(@"like:%@",[obj objectForKey:@"status"]);
            };
        }];
        [self.wishlist addObject:self.currentCloth];
        //判断移动方向为右则添加进数组
        int count = self.label.text.intValue;
        count++;
        self.label.text = [NSString stringWithFormat:@"%d",(int)count];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"modificationWishlistCount" object:nil userInfo:@{@"wishlistCount":self.label.text}];
        if (self.label.text.intValue == 9) {
            NSLog(@"before close:%@",self);
            self.navigationItem.rightBarButtonItem.enabled = NO;//弹出九宫格  关闭导航栏右上的跳转按钮交互

            self.view.userInteractionEnabled = NO;
            [self showShareViewController];
            self.anotherFlag = YES;
        }
    }
    self.firstCardView = self.secondCardView;
    self.firstCardView.userInteractionEnabled = YES;
    self.secondCardView = self.thirdCardView;
    self.thirdCardView = self.fourthCardView;
    if ((self.fourthCardView = [self popPersonViewWithFrame:[self firstCardViewFrame]])) {
        self.fourthCardView.frame = [self fourthCardViewFrame];
        [self.view insertSubview:self.fourthCardView belowSubview:self.thirdCardView];
    }
    if(!self.anotherFlag) {
        if (self.number>self.totalNumber) {
            [self finishOneSetAndReadyComeback];
        }
    } else {
        self.anotherFlag = NO;
    }
    
}
//把数据写入数据库
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
    _firstCardView = firstCardView;
    self.currentCloth = firstCardView.modeGood;
}
- (ChooseClothesView *)popPersonViewWithFrame:(CGRect)frame {
    if ([self.allGoods count] == 0) {
        return nil;
    }
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


#pragma mark Control Events

- (IBAction)likeFrontCardView:(UIButton *)sender {
    [self.firstCardView mdc_swipe:MDCSwipeDirectionRight];
}

- (IBAction)nopeFrontCardView:(UIButton *)sender {
    [self.firstCardView mdc_swipe:MDCSwipeDirectionLeft];
}

@end

