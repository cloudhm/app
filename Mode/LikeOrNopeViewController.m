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
#import "ModeGoodAPI.h"
#import "SDWebImageManager.h"
#import "UIViewController+CWPopup.h"
#import "ShareViewController.h"
#import "UIColor+HexString.h"
#import "AppDelegate.h"
#import "ModeRunwayAPI.h"
#import "ModeDatabase.h"
#import "PrefixHeaderDatabase.pch"
#import "TAlertView.h"
#import "Runway.h"
#import "GoodItem.h"
#import "ModeWishlistAPI.h"


@interface LikeOrNopeViewController ()<UIAlertViewDelegate,ShareViewControllerDelegate>


@property (nonatomic,assign) CGRect mainFrame;
@property (weak, nonatomic) UILabel *label;
@property (weak, nonatomic) UIImageView *heartIV;
@property (strong, nonatomic) NSMutableArray *goodItems;
@property (strong, nonatomic) NSMutableArray *wishlist;
@property (strong, nonatomic) UIView *startIntroduceView;
@property (nonatomic,assign) BOOL anotherFlag;
@end

@implementation LikeOrNopeViewController

#pragma mark ShowAlertView
-(void)showAlertViewWithCautionInfo:(NSString*)cautionInfo{
    TAlertView *alert = [[TAlertView alloc] initWithTitle:cautionInfo andMessage:nil];
    alert.alertBackgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.8];
    alert.titleFont = [UIFont fontWithName:@"Baskerville-SemiBoldItalic" size:14];
    [alert setTitleColor:[UIColor whiteColor] forAlertViewStyle:TAlertViewStyleInformation];
    alert.tapToClose = NO;
    alert.timeToClose = 1.f;
    alert.buttonsAlign = TAlertViewButtonsAlignHorizontal;
    alert.style = TAlertViewStyleInformation;
    [alert showAsMessage];
}
#pragma mark - Object Lifecycle
-(NSMutableArray *)goodItems{//准备接受一组秀场的数组
    if (!_goodItems) {
        _goodItems = [NSMutableArray array];
    }
    return _goodItems;
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
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
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
    self.heartIV = bgIV;
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
    UIBarButtonItem* barItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(comeback:)];
    self.navigationItem.leftBarButtonItem = barItem;
}
#pragma mark navigationItem.leftBarButtonItem Action
-(void)comeback:(UIBarButtonItem*)btn{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
//页面即将显示 将bottomView插入至视图底部位置
-(void)viewWillAppear:(BOOL)animated{
    [self.view insertSubview:self.bottomView atIndex:0];
    [self.wishlist removeAllObjects];
    [self.wishlist addObjectsFromArray:[ModeDatabase readDatabaseFromTableName:WISHLIST_TABLENAME andSelectConditionKey:nil andSelectConditionValue:nil]];
    self.label.text = @"0";
    if (self.wishlist.count>0) {
        self.label.text = [NSString stringWithFormat:@"%d",(int)self.wishlist.count];
        self.view.userInteractionEnabled = YES;
    }
    
}
-(NSString*)getUserId{
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"userId"];
}
//如果上一次未完成分享  会弹出分享视图
-(void)viewDidAppear:(BOOL)animated{
    if (self.label.text.integerValue >= 9) {
        [self showShareViewController];
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
    [self useCustomAppearance];
#warning 再造一个view在初次进这时显示
    [self createStartIntroduceView];//创建一个开场遮盖
    self.title = [[[self.receiveArr lastObject] objectForKey:@"name"]uppercaseString];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:@"#1b1b1b"];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue" size:20],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self.goodItems addObjectsFromArray:[ModeDatabase readDatabaseFromTableName:LIKENOPE_TABLENAME andSelectConditionKey:nil andSelectConditionValue:nil]];
    if (self.goodItems.count>0) {
        self.number = 1;
        self.totalNumber = self.goodItems.count;
        self.tabLabel.text = [NSString stringWithFormat:@"%d/%d",(int)self.number,(int)self.totalNumber];
    }
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
        Runway* runway = [self.receiveArr firstObject];
        titleLabel.attributedText = [[NSAttributedString alloc]initWithString:runway.runwayTitle attributes:attributes];
        CGRect rect = [titleLabel.text boundingRectWithSize:CGSizeMake(220, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
        titleLabel.frame = CGRectMake((CGRectGetWidth(self.navigationController.view.bounds) - 220.f)/2, CGRectGetHeight(self.navigationController.view.bounds)/2 - 100.f, 220, rect.size.height + 10.f);
        [self.startIntroduceView addSubview:titleLabel];
        
        UILabel * descLabel = [[UILabel alloc]init];
        descLabel.numberOfLines = 0;
        descLabel.text = runway.runwayDescription ;
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
    self.heartIV.alpha = 0.f;
    self.label.alpha = 0.f;
    ShareViewController* shareViewController = [[ShareViewController alloc]initWithNibName:@"ShareViewController" bundle:nil];
    shareViewController.delegate = self;
    shareViewController.nineGoods = self.wishlist;
#warning 加载在导航栏控制器上  该视图控制器就可以居中显示了
    [self.navigationController presentPopupViewController:shareViewController animated:YES completion:nil];
}
#pragma mark ShareViewControllerDelegate
-(void)shareViewController:(ShareViewController *)shareViewController shareNineModeGoodsToOthers:(NSArray *)nineGoods andTextContent:(NSString *)textContent startAnimation:(UIActivityIndicatorView *)activityView{
    [activityView startAnimating];
    NSDictionary* params = @{@"items":nineGoods,@"text":textContent};
    [ModeWishlistAPI shareWishlistBy:params andCallback:^(id obj) {
        if(obj == nil) {
            [activityView stopAnimating];
            [self.navigationController dismissPopupViewControllerAnimated:YES completion:nil];
            self.heartIV.alpha = 1.f;
            self.label.alpha = 1.f;
            [self showAlertView];
        } else {
            [self showAlertViewWithCautionInfo:@"Fail to share,please try again."];
        }
        
    }];
}


-(void)showAlertView{
    self.navigationItem.rightBarButtonItem.enabled = NO;//弹出九宫格  关闭导航栏右上的跳转按钮交互
    
    self.view.userInteractionEnabled = YES;
#warning 清空数据库中9个项目
    BOOL flag = [ModeDatabase deleteTableWithName:WISHLIST_TABLENAME andConditionKey:nil andConditionValue:nil];
#warning 如果没有商品可选弹出第一个AlertView  有可选则第二个
    if (self.tabLabel.text.integerValue>=self.totalNumber) {//用来判断本组是否已经完成
        self.label.text = @"0";
        [self finishOneSetAndReadyComeback];
        return ;
    }
    if (flag) {
        self.label.text = @"0";
        [self.wishlist removeAllObjects];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"modificationWishlistCount" object:nil userInfo:@{@"wishlistCount":self.label.text}];
        self.navigationController.navigationBar.userInteractionEnabled = YES;
        UIAlertView* av = [[UIAlertView alloc]initWithTitle:@"Nice!" message:@"Well Done.Shared successed!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        av.tag = 1;
        [av show];
    }
}



-(void)dealloc{
    NSLog(@"likeornope页面销毁");
}
-(void)useCustomAppearance{
    TAlertView *appearance = [TAlertView appearance];
    appearance.alertBackgroundColor     = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    appearance.titleFont                = [UIFont fontWithName:@"Baskerville" size:22];
    appearance.messageColor             = [UIColor whiteColor];
    appearance.messageFont              = [UIFont fontWithName:@"Baskerville-SemiBoldItalic" size:14];
    appearance.buttonsTextColor         = [UIColor whiteColor];
    appearance.buttonsFont              = [UIFont fontWithName:@"Baskerville-Bold" size:16];
    appearance.separatorsLinesColor     = [UIColor grayColor];
    appearance.tapToCloseFont           = [UIFont fontWithName:@"Baskerville" size:10];
    appearance.tapToCloseColor          = [UIColor grayColor];
    appearance.tapToCloseText           = @"Touch to close";
    [appearance setTitleColor:[UIColor orangeColor] forAlertViewStyle:TAlertViewStyleError];
    [appearance setDefaultTitle:@"Error" forAlertViewStyle:TAlertViewStyleError];
    [appearance setTitleColor:[UIColor whiteColor] forAlertViewStyle:TAlertViewStyleNeutral];
}
//完成整组秀场弹出的alertView
-(void)finishOneSetAndReadyComeback{
    
    TAlertView* av = [[TAlertView alloc]initWithTitle:@"Nice!" message:@"The set has been finished,whether to continue" buttons:@[@"Back",@"Continue"] andCallBack:^(TAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        } else {
            NSDictionary* newParams = [self.receiveArr lastObject];
            [ModeRunwayAPI requestRunwayWithParams:newParams andCallback:^(id obj) {
                if ([obj isKindOfClass:[NSNull class]]) {
                    return;
                }
                
                self.receiveArr = obj;
                NSArray* allItems = obj[1];
                [ModeDatabase saveGetNewDatabaseIntoTableName:LIKENOPE_TABLENAME andTableElements:LIKENOPE_ELEMENTS andObj:allItems];
                [self createStartIntroduceView];
                [self.goodItems removeAllObjects];
                [self.goodItems addObjectsFromArray:[ModeDatabase readDatabaseFromTableName:LIKENOPE_TABLENAME andSelectConditionKey:nil andSelectConditionValue:nil]];
                
                
                
                self.number = 1;
                self.totalNumber = self.goodItems.count;
                self.tabLabel.text = [NSString stringWithFormat:@"%d/%d",(int)self.number,(int)self.totalNumber];
                [self updateUI];
                self.view.userInteractionEnabled = YES;
                [self.view setNeedsDisplay];
            }];
            
        }

    }];
    
//    UIAlertView* av = [[UIAlertView alloc]initWithTitle:@"Nice!" message:@"The set has been finished,whether to continue" delegate:self cancelButtonTitle:@"Back" otherButtonTitles: @"Continue",nil];
//    av.tag = 2;
    [av show];
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1) {
        if (buttonIndex == alertView.cancelButtonIndex) {
            self.firstCardView.userInteractionEnabled = YES;
        }
    } else if (alertView.tag == 2) {
        if (buttonIndex == alertView.cancelButtonIndex) {
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        } else {
            NSDictionary* newParams = [self.receiveArr lastObject];
            [ModeRunwayAPI requestRunwayWithParams:newParams andCallback:^(id obj) {
                if ([obj isKindOfClass:[NSNull class]]) {
                    return;
                }
                NSArray* allItems = [obj objectForKey:@"allItems"];
                self.receiveArr =obj;
                [ModeDatabase saveGetNewDatabaseIntoTableName:LIKENOPE_TABLENAME andTableElements:LIKENOPE_ELEMENTS andObj:allItems];
                [self createStartIntroduceView];
                [self.goodItems addObjectsFromArray:allItems];
                
                
                
                self.number = 1;
                self.totalNumber = self.goodItems.count;
                self.tabLabel.text = [NSString stringWithFormat:@"%d/%d",(int)self.number,(int)self.totalNumber];
                [self updateUI];
                self.view.userInteractionEnabled = YES;
                [self.view setNeedsDisplay];
            }];
            
        }
        
        
    }
    self.navigationItem.rightBarButtonItem.enabled = YES;
}

#pragma mark UpdateUI
-(void)updateUI{
    //由于使用自动布局和size class技术  屏幕宽度在首次使用时用常量持久保存，否则首次匹配会有问题
    self.mainFrame = [UIScreen mainScreen].bounds;
    
    
    self.firstCardView = [self popPersonViewWithFrame:[self firstCardViewFrame]];
    self.firstCardView.userInteractionEnabled = YES;
    self.firstCardView.layer.borderColor = [UIColor colorWithHexString:@"#4c4c4c" withAlpha:1.f].CGColor;
    [self.view addSubview:self.firstCardView];
    
    
    self.secondCardView = [self popPersonViewWithFrame:[self firstCardViewFrame]];
    self.secondCardView.frame = [self scaleRect:self.secondCardView.frame];
    self.secondCardView.layer.borderColor = [UIColor colorWithHexString:@"#4c4c4c" withAlpha:.8f].CGColor;
    [self.view insertSubview:self.secondCardView belowSubview:self.firstCardView];
    
    self.thirdCardView = [self popPersonViewWithFrame:[self firstCardViewFrame]];
    self.thirdCardView.frame = [self scaleRect:self.secondCardView.frame];
    self.thirdCardView.layer.borderColor = [UIColor colorWithHexString:@"#4c4c4c" withAlpha:.5f].CGColor;
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

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - MDCSwipeToChooseDelegate Protocol Methods 手势

// This is called when a user didn't fully swipe left or right.
- (void)viewDidCancelSwipe:(UIView *)view {
    NSLog(@"You couldn't decide on %@.", self.currentCloth.itemId);
}

// This is called then a user swipes the view fully left or right.
- (void)view:(UIView *)view wasChosenWithDirection:(MDCSwipeDirection)direction {
    self.number++;
    self.tabLabel.text = [NSString stringWithFormat:@"%d/%d",(int)(self.number>self.totalNumber?self.totalNumber:self.number),(int)self.totalNumber];
#warning like or nope feedback interface params need to modify
    if (direction == MDCSwipeDirectionLeft) {
        //Nope goods
        [ModeGoodAPI setGoodsFeedbackWithParams:@{@"itemId":self.currentCloth.itemId,@"brandId":self.currentCloth.brandId} andCallback:^(id obj) {
            NSLog(@"nope:%@",[obj objectForKey:@"status"]);
        }];
        // remove nope goods-Image from Disk
        [[SDImageCache sharedImageCache] removeImageForKey:[self.currentCloth.defaultImage lastPathComponent] fromDisk:YES];
        
    } else {
        //Like goods
        [ModeDatabase replaceIntoTable:WISHLIST_TABLENAME andTableElements:WISHLIST_ELEMENTS andInsertContent:self.currentCloth];
        [ModeGoodAPI setGoodsFeedbackWithParams:@{@"itemId":self.currentCloth.itemId,@"brandId":self.currentCloth.brandId} andCallback:^(id obj) {
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
    self.firstCardView.layer.borderColor = [UIColor colorWithHexString:@"#4c4c4c" withAlpha:1.f].CGColor;
    self.firstCardView.userInteractionEnabled = YES;
    self.secondCardView = self.thirdCardView;
    self.secondCardView.layer.borderColor = [UIColor colorWithHexString:@"#4c4c4c" withAlpha:.8f].CGColor;
    self.thirdCardView = self.fourthCardView;
    self.thirdCardView.layer.borderColor = [UIColor colorWithHexString:@"#4c4c4c" withAlpha:.5f].CGColor;
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

#pragma mark - Internal Methods
- (void)setFirstCardView:(ChooseClothesView *)firstCardView {
    _firstCardView = firstCardView;
    self.currentCloth = firstCardView.goodItem;
}
- (ChooseClothesView *)popPersonViewWithFrame:(CGRect)frame {
    if ([self.goodItems count] == 0) {
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
        self.secondCardView.layer.borderColor = [UIColor colorWithHexString:@"#4c4c4c" withAlpha:(.8f+state.thresholdRatio*.2f)].CGColor;
        frame = [self thirdCardViewFrame];
        self.thirdCardView.frame = CGRectMake(frame.origin.x - 5.f * state.thresholdRatio,
                                              frame.origin.y - state.thresholdRatio * 15.f,
                                              CGRectGetWidth(frame) + 10.f *state.thresholdRatio,
                                              CGRectGetHeight(frame) +10.f*state.thresholdRatio);
        self.thirdCardView.layer.borderColor = [UIColor colorWithHexString:@"#4c4c4c" withAlpha:(.5f+state.thresholdRatio*.3f)].CGColor;
        
    };

    ChooseClothesView *clothesView = [[ChooseClothesView alloc] initWithFrame:frame
                                                                    goodItem:self.goodItems[0]
                                                                   options:options];
    clothesView.userInteractionEnabled = NO;
    
    [self.goodItems removeObjectAtIndex:0];
    
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
    if (self.number == 9) {
        return;
    }
    [self.firstCardView mdc_swipe:MDCSwipeDirectionRight];
}

- (IBAction)nopeFrontCardView:(UIButton *)sender {
    [self.firstCardView mdc_swipe:MDCSwipeDirectionLeft];
}

@end

