//
//  WishListViewController.m
//  Mode
//
//  Created by YedaoDEV on 15/5/26.
//  Copyright (c) 2015年 YedaoDEV. All rights reserved.
//

#import "WishListViewController.h"
#import "ModeGood.h"
#import "WishlistScrollView.h"
#import <FMDB.h>
#import "WishlistView.h"
#import "ModeGoodAPI.h"
#import "GoodInfo.h"
#import "Coupon.h"
#import "UIImageView+WebCache.h"
#import "SDWebImageManager.h"
#import "ColorView.h"
@interface WishListViewController ()<UIAlertViewDelegate>
@property (nonatomic, strong) NSMutableArray* clothes;
@property (nonatomic, strong) NSMutableArray* clothesIvArr;
@property (weak, nonatomic) UILabel *label;
@property (nonatomic, weak) WishlistScrollView *bigSV;
@property (strong, nonatomic) GoodInfo *goodInfo;
@property (weak, nonatomic) IBOutlet UIImageView *goods_img_detail;
@property (weak, nonatomic) IBOutlet UILabel *goods_price;
@property (weak, nonatomic) IBOutlet UIView *rightView;
@property (weak, nonatomic) UILabel *goods_title;
@property (weak, nonatomic) UIView *smallLineView;
@property (weak, nonatomic) UILabel *releaseTime;
@property (weak, nonatomic) UILabel *colorLabel;
@property (weak, nonatomic) UILabel *sizeLabel;
@property (weak, nonatomic) UIImageView *couponIV;
@property (weak, nonatomic) UIButton *couponBtn;
@property (weak, nonatomic) UIButton *goodDetailBtn;
;
@property (weak, nonatomic) ColorView *colorView1;
@property (weak, nonatomic) ColorView *colorView2;
@property (weak, nonatomic) ColorView *colorView3;
@property (weak, nonatomic) ColorView *colorView4;
@property (strong, nonatomic) NSArray *colorViews;
@end

@implementation WishListViewController
- (BOOL)prefersStatusBarHidden
{
    return NO;
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
//增加右下视图  商品详情控件
-(void)addSomeElementsToRightView{
    UILabel* l1 = [[UILabel alloc]init];
    l1.numberOfLines=0;
    l1.font = [UIFont italicSystemFontOfSize:14];
    l1.textAlignment = NSTextAlignmentCenter;
//    l1.backgroundColor = [UIColor yellowColor];
    l1.textColor = [UIColor colorWithRed:77/255.f green:77/255.f blue:77/255.f alpha:1];
    self.goods_title = l1;
    [self.rightView addSubview:l1];
    
    UIView* v1 = [[UIView alloc]init];
    v1.backgroundColor = [UIColor colorWithRed:115/255.f green:115/255.f blue:115/255.f alpha:1];
    self.smallLineView = v1;
    [self.rightView addSubview:v1];
    
    UILabel* l2 = [[UILabel alloc]init];
    l2.textColor = [UIColor colorWithRed:95/255.f green:197/255.f blue:66/255.f alpha:1];
    self.releaseTime = l2;
    l2.textAlignment = NSTextAlignmentCenter;
    l2.font = [UIFont italicSystemFontOfSize:12];
    [self.rightView addSubview:l2];
    
    UILabel* l3 = [[UILabel alloc]init];
    l3.text = @"COLOUR";
    l3.font = [UIFont systemFontOfSize:11];
    l3.textColor = [UIColor blackColor];
    self.colorLabel = l3;
    [self.rightView addSubview:l3];
    
    UILabel* l4 = [[UILabel alloc]init];
    l4.text = @"SIZE:";
    l4.font = [UIFont systemFontOfSize:11];
    l4.textColor = [UIColor blackColor];
    self.sizeLabel = l4;
    [self.rightView addSubview:l4];
    
    UIImageView* iv = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"red coupon_normal.png"]];
    iv.userInteractionEnabled = YES;
    self.couponIV = iv;
    [self.rightView addSubview:iv];
    
    UIButton* b1 = [[UIButton alloc]init];
    [b1 setImage:[UIImage imageNamed:@"apply_normal.png"] forState:UIControlStateNormal];
    [b1 setImage:[UIImage imageNamed:@"apply_press.png"] forState:UIControlStateHighlighted];
    self.couponBtn = b1;
    [self.couponIV addSubview:b1];
    
    UIButton* b2 = [[UIButton alloc]init];
    [b2 setImage:[UIImage imageNamed:@"view detal_normal.png"] forState:UIControlStateNormal];
    [b2 setImage:[UIImage imageNamed:@"view detal_press.png"] forState:UIControlStateHighlighted];
    self.goodDetailBtn = b2;
    [self.rightView addSubview: b2];
    
    ColorView* colorView = [[ColorView alloc]init];
    self.colorView1 = colorView;
    [self.rightView addSubview:self.colorView1];
    
    colorView = [[ColorView alloc]init];
    self.colorView2 = colorView;
    [self.rightView addSubview:self.colorView2];
    
    colorView = [[ColorView alloc]init];
    self.colorView3 = colorView;
    [self.rightView addSubview:self.colorView3];
    
    colorView = [[ColorView alloc]init];
    self.colorView4 = colorView;
    [self.rightView addSubview:self.colorView4];
    
    self.colorViews = @[self.colorView1,self.colorView2,self.colorView3,self.colorView4];
}
//设置右视图的所有子控件位置及大小
-(void)resetAllElementsInRightView{
    CGRect frame = [self getGoodTitleFrame];
    self.goods_title.text = self.goodInfo.goods_title;
    self.goods_title.frame = CGRectMake(10.f, 15.f, frame.size.width, frame.size.height+10.f);
    
    self.smallLineView.frame = CGRectMake(CGRectGetWidth(self.goods_title.frame)/2-15.f, CGRectGetMaxY(self.goods_title.frame)+5.f, 15.f*2, 2.f);
    
    self.releaseTime.text = self.goodInfo.ctime;
    self.releaseTime.frame = CGRectMake(0, CGRectGetMaxY(self.smallLineView.frame) + 15.f, CGRectGetWidth(self.rightView.frame), 20.f);
    
    self.colorLabel.frame = CGRectMake(CGRectGetMinX(self.releaseTime.frame)+10.f, CGRectGetMaxY(self.releaseTime.frame)+15.f, 50.f, 20.f);
    
    
    NSArray* colorArr= [self.goodInfo.goods_color componentsSeparatedByString:@","];
    float colorViewW = 20.f;
    float colorViewH = 20.f;
    
    self.colorView1.frame = CGRectMake(CGRectGetMaxX(self.colorLabel.frame), CGRectGetMinY(self.colorLabel.frame), colorViewW, colorViewH);
    self.colorView2.frame = CGRectMake(CGRectGetMaxX(self.colorView1.frame), CGRectGetMinY(self.colorLabel.frame), colorViewW, colorViewH);
    self.colorView3.frame = CGRectMake(CGRectGetMaxX(self.colorView2.frame), CGRectGetMinY(self.colorLabel.frame), colorViewW, colorViewH);
    self.colorView4.frame = CGRectMake(CGRectGetMaxX(self.colorView3.frame), CGRectGetMinY(self.colorLabel.frame), colorViewW, colorViewH);
    
    
    for (int i = 0; i<self.colorViews.count; i++) {
        ColorView*colorView = self.colorViews[i];
        if (i>=colorArr.count) {
            colorView.colorStr = @"";
            continue;
        }
        colorView.colorStr = colorArr[i];
        //重绘在View中的类的setter方法已写
    }
    self.sizeLabel.frame = CGRectMake(CGRectGetMinX(self.colorLabel.frame), CGRectGetMaxY(self.colorLabel.frame)+5.f, 100, 20);
    self.sizeLabel.text = [NSString stringWithFormat:@"SIZE:  %@",self.goodInfo.goods_size];
    
    
    
    
    float couponIVX = 20.f;
    self.couponIV.frame = CGRectMake(couponIVX, CGRectGetMaxY(self.sizeLabel.frame)+10.f, CGRectGetWidth(self.rightView.bounds)-2* couponIVX, 40.f);
    
    self.couponBtn.frame = CGRectMake(10.f, 10.f, 40.f, 20.f);
    
    self.goodDetailBtn.frame = CGRectMake(CGRectGetMinX(self.couponIV.frame), CGRectGetMaxY(self.couponIV.frame)+10.f, CGRectGetWidth(self.couponIV.frame), 40.f);
    
    
}
//懒加载
-(NSMutableArray *)clothes{
    if (!_clothes) {
        _clothes = [NSMutableArray array];
    }
    return _clothes;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
//如果跳转页面未传值，则显示本地未上传给服务器的wishlist列表，如果传值则显示网络上喜欢的历史纪录
    if (!self.receiveArr) {
        [self readDataFromTableWishlist];
    } else {
        [self.clothes addObjectsFromArray:self.receiveArr];
    }
    
    [self addSomeElementsToRightView];
//从数据库读取数据
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self addUI];
    
    
}
//页面已经显示时添加两个通知的观察者
-(void)viewDidAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(requestLoadGoodInfo:) name:@"selectGood_id" object:nil];
    if (!self.receiveArr) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(removeDataFromWishlist:) name:@"removeNopedGood" object:nil];
    }
}
//页面即将消失把通知注销掉
-(void)viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"removeNopedGood" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"requestLoadGoodInfo" object:nil];
}
//收到通知  网络请求商品详情
-(void)requestLoadGoodInfo:(NSNotification*)noti{
    NSLog(@"noti");
    [ModeGoodAPI requestGoodInfoWithGoodID:[noti.userInfo objectForKey:@"goods_id"] andCallback:^(id obj) {
        if ([obj isKindOfClass:[NSNull class]]) {
            return ;
        }
        self.goodInfo = obj;
        self.goods_price.text = [NSString stringWithFormat:@"Sale Price:$%.2f",self.goodInfo.goods_price.floatValue];
        [self.goods_img_detail sd_setImageWithURL:[NSURL URLWithString:self.goodInfo.img_detail_link] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [[SDImageCache sharedImageCache]storeImage:image forKey:[self.goodInfo.img_detail_link lastPathComponent] toDisk:YES];
        }];
        [self resetAllElementsInRightView];
        [self.view setNeedsLayout];
    }];
}
//计算右视图中商品标题的大小
-(CGRect)getGoodTitleFrame {
    NSDictionary* attributes = @{NSFontAttributeName:[UIFont italicSystemFontOfSize:14],NSForegroundColorAttributeName:[UIColor colorWithRed:77/255.f green:77/255.f blue:77/255.f alpha:1]};
    return [self.goodInfo.goods_title boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.rightView.bounds), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
}

//导入wishlist数据  主要用来显示右上角红心数
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
//增加横向滚动的scrollView视图
-(void)addUI{
    [self defineRightBarItem];
    WishlistScrollView* sv = [[WishlistScrollView alloc]initWithFrame:CGRectMake(0, 20.f, CGRectGetWidth(self.view.bounds), 125) WithWishlistArr:self.clothes];
    self.bigSV = sv;
    [self.view addSubview:sv];
}

//根据滚动视图中的子视图删除按钮的通知  把该视图从scrollView中删除  并且从数据库删除，更新右上角红心数 重置选中视图下标
-(void)removeDataFromWishlist:(NSNotification*)noti{
    NSString* nopedGoods_id = [noti.userInfo objectForKey:@"goods_id"];
    NSString* documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString*path=[documentPath stringByAppendingPathComponent:@"my.sqlite"];
    FMDatabase* db = [FMDatabase databaseWithPath:path];
    if ([db open]) {
        NSLog(@"数据库成功打开");
        BOOL res = [db executeUpdate:@"DELETE FROM wishlist WHERE goods_id = ?",nopedGoods_id];
        NSLog(@"%@",nopedGoods_id);
        if (res) {
            NSLog(@"删除成功");
        }
        [db close];
    } else {
        [db close];
        NSLog(@"数据库打开失败");
    }
    id obj = noti.object;
    if ([obj isMemberOfClass:[WishlistView class]]) {
        WishlistView* wishlistView = (WishlistView*)obj;
        [self.bigSV.wishlists removeObject:wishlistView.modeGood];
        [self.bigSV.wishlistViews removeObject:wishlistView];
        [wishlistView removeFromSuperview];
        [self.bigSV layoutSubviews];
        int count = self.label.text.intValue;
        count--;
        self.label.text = [NSString stringWithFormat:@"%d",(int)count];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"modificationWishlistCount" object:nil userInfo:@{@"wishlistCount":self.label.text}];
        if ([self.label.text isEqualToString:@"0"]) {
            UIAlertView* av = [[UIAlertView alloc]initWithTitle:@"Caution" message:@"Please come back and choose some your liked fashion goods first" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [av show];
        }
    }
}
#pragma mark UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == alertView.cancelButtonIndex) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
//定义导航栏右上角红心位置的视图
-(void)defineRightBarItem{
    UIView *rightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 34 ,34)];
    UIImageView *bgIV = [[UIImageView alloc]initWithFrame:rightView.bounds];
    bgIV.image = [UIImage imageNamed:@"heart.png"];
    UILabel *l = [[UILabel alloc]initWithFrame:bgIV.bounds];
    l.textAlignment = NSTextAlignmentCenter;
    l.textColor = [UIColor whiteColor];
    l.text = [NSString stringWithFormat:@"%d",(int)self.clothes.count];
    self.label = l;
    [rightView addSubview:bgIV];
    [rightView addSubview:l];
    UIBarButtonItem* rightBarItem = [[UIBarButtonItem alloc]initWithCustomView:rightView];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
