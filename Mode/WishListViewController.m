//
//  WishListViewController.m
//  Mode
//
//  Created by YedaoDEV on 15/5/26.
//  Copyright (c) 2015年 YedaoDEV. All rights reserved.
//

#import "WishListViewController.h"

#import "WishlistScrollView.h"
#import <FMDB.h>
#import "WishlistView.h"
#import "ModeGoodAPI.h"

#import "UIImageView+WebCache.h"
#import "SDWebImageManager.h"
#import "ColorView.h"
#import "UIImage+PartlyImage.h"
#import "UIColor+HexString.h"
#import "Common.h"
#import "UIView+AutoLayout.h"
#import "GoodItem.h"
#import "ModeDatabase.h"
#import "PrefixHeaderDatabase.pch"
#import "BrandRunwayTableViewController.h"
#import "WebViewViewController.h"
@interface WishListViewController ()<WishlistScrollViewDelegate>
@property (nonatomic, strong) NSMutableArray* clothes;
@property (nonatomic, strong) NSMutableArray* clothesIvArr;
@property (weak, nonatomic) UILabel *label;
@property (nonatomic, weak) WishlistScrollView *bigSV;

@property (strong, nonatomic) GoodItem *goodItem;
@property (weak, nonatomic) UIImageView *goods_img_detail;
@property (weak, nonatomic) UILabel *goods_price;
@property (weak, nonatomic) UIView *rightView;
@property (weak, nonatomic) UILabel *goods_title;
@property (weak, nonatomic) UIView *smallLineView;
@property (weak, nonatomic) UILabel *releaseTime;
@property (weak, nonatomic) UILabel *colorLabel;
@property (weak, nonatomic) UILabel *sizeLabel;


@property (weak, nonatomic) UIImageView *brandImageView;
@property (weak, nonatomic) UIButton *brandInfoBtn;
@property (weak, nonatomic) UIButton *viewDetailBtn;


@property (weak, nonatomic) ColorView *colorView1;
@property (weak, nonatomic) ColorView *colorView2;
@property (weak, nonatomic) ColorView *colorView3;
@property (weak, nonatomic) ColorView *colorView4;
@property (strong, nonatomic) NSArray *colorViews;

@property (weak, nonatomic) IBOutlet UIButton *couponBtn;

@end

@implementation WishListViewController



#pragma mark Create Elements
//增加右下视图  商品详情控件
-(void)createRightView{
    
    float padding = 10.f;
    float x = KScreenWidth/2;
    float y = CGRectGetMaxY(self.bigSV.frame) + 2* padding;
    float w = KScreenWidth/2;
    float h = KScreenHeight - y - kStatusNaviBarH - 50.f;
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(x, y, w, h)];
    self.rightView = view;
    [self.view addSubview:self.rightView];
    
    UILabel* l1 = [[UILabel alloc]init];
    l1.numberOfLines=0;
    l1.font = [UIFont italicSystemFontOfSize:14];
    l1.textAlignment = NSTextAlignmentCenter;
    l1.textColor = [UIColor colorWithRed:77/255.f green:77/255.f blue:77/255.f alpha:1];
    self.goods_title = l1;
    [self.rightView addSubview:l1];
    
    UIView* v1 = [[UIView alloc]init];
    v1.backgroundColor = [UIColor colorWithRed:115/255.f green:115/255.f blue:115/255.f alpha:1];
//    v1.translatesAutoresizingMaskIntoConstraints = NO;
    self.smallLineView = v1;
    [self.rightView addSubview:v1];
    
    UILabel* l2 = [[UILabel alloc]init];
    l2.textColor = [UIColor colorWithRed:95/255.f green:197/255.f blue:66/255.f alpha:1];
//    l2.translatesAutoresizingMaskIntoConstraints = NO;
    l2.textAlignment = NSTextAlignmentCenter;
    l2.font = [UIFont italicSystemFontOfSize:12];
    self.releaseTime = l2;
    [self.rightView addSubview:l2];
    
    UILabel* l3 = [[UILabel alloc]init];
    l3.text = @"COLOUR";
    l3.font = [UIFont systemFontOfSize:11];
    l3.textColor = [UIColor blackColor];
//    l3.translatesAutoresizingMaskIntoConstraints = NO;
    self.colorLabel = l3;
    [self.rightView addSubview:l3];
    
    UILabel* l4 = [[UILabel alloc]init];
    l4.text = @"SIZE:";
    l4.font = [UIFont systemFontOfSize:11];
    l4.textColor = [UIColor blackColor];
//    l4.translatesAutoresizingMaskIntoConstraints = NO;
    self.sizeLabel = l4;
    [self.rightView addSubview:l4];
    
    UIButton* b1 = [[UIButton alloc]init];
//    b1.translatesAutoresizingMaskIntoConstraints = NO;
    [b1 setImage:[UIImage imageNamed:@"brandInfoNor.png"] forState:UIControlStateNormal];
    [b1 setImage:[UIImage imageNamed:@"brandInfoHigh.png"] forState:UIControlStateHighlighted];
    [b1 addTarget:self action:@selector(gotoNextView:) forControlEvents:UIControlEventTouchUpInside];
    b1.tag = 1;
    self.brandInfoBtn = b1;
    [self.rightView addSubview:b1];
    
    UIButton* b2 = [[UIButton alloc]init];
//    b2.translatesAutoresizingMaskIntoConstraints = NO;
    [b2 setImage:[UIImage imageNamed:@"viewDetailNormal.png"] forState:UIControlStateNormal];
    [b2 setImage:[UIImage imageNamed:@"viewDetailPress.png"] forState:UIControlStateHighlighted];
    [b2 addTarget:self action:@selector(gotoNextView:) forControlEvents:UIControlEventTouchUpInside];
    b2.tag = 2;
    self.viewDetailBtn = b2;
    [self.rightView addSubview: b2];
    
    UIImageView* iv = [[UIImageView alloc]init];
    iv.userInteractionEnabled = YES;
    self.brandImageView = iv;
    [self.brandInfoBtn addSubview:iv];
    
    ColorView* colorView = [[ColorView alloc]init];
    colorView.colorStr = @"";
    self.colorView1 = colorView;
    self.colorView1.translatesAutoresizingMaskIntoConstraints = NO;
    [self.rightView addSubview:self.colorView1];
    
    colorView = [[ColorView alloc]init];
    colorView.colorStr = @"";
    self.colorView2 = colorView;
    self.colorView2.translatesAutoresizingMaskIntoConstraints = NO;
    [self.rightView addSubview:self.colorView2];
    
    colorView = [[ColorView alloc]init];
    colorView.colorStr = @"";
    self.colorView3 = colorView;
    self.colorView3.translatesAutoresizingMaskIntoConstraints = NO;
    [self.rightView addSubview:self.colorView3];
    
    colorView = [[ColorView alloc]init];
    colorView.colorStr = @"";
    self.colorView4 = colorView;
    self.colorView4.translatesAutoresizingMaskIntoConstraints = NO;
    [self.rightView addSubview:self.colorView4];
    
    self.colorViews = @[self.colorView1,self.colorView2,self.colorView3,self.colorView4];
    
    self.rightView.backgroundColor = [UIColor clearColor];
}

//设置右视图的所有子控件位置及大小
-(void)resetAllElementsInRightView{

    CGRect frame = [self getGoodTitleFrame];

    
    self.goods_title.text = self.goodItem.goodTitle;
    self.releaseTime.text = [NSString stringWithFormat:@"Release time:%@",self.goodItem.ctime];
    
    
    
    self.goods_title.frame = CGRectMake(0, 0, CGRectGetWidth(self.rightView.bounds)-10.f, frame.size.height+10.f);
    self.smallLineView.frame = CGRectMake(CGRectGetMidX(self.goods_title.frame)- 30./2, CGRectGetMaxY(self.goods_title.frame)+5.f, 30.f, 2.f);
    

    self.releaseTime.frame = CGRectMake(0, CGRectGetMaxY(self.smallLineView.frame) + 5.f, CGRectGetWidth(self.rightView.frame), 20.f);
    
    self.colorLabel.frame = CGRectMake(CGRectGetMinX(self.releaseTime.frame)+10.f, CGRectGetMaxY(self.releaseTime.frame)+5.f, 50.f, 20.f);
  
    NSArray* colorArr= [self.goodItem.color componentsSeparatedByString:@","];
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
    self.sizeLabel.frame = CGRectMake(CGRectGetMinX(self.colorLabel.frame), CGRectGetMaxY(self.colorLabel.frame)+5.f, 100, 40);
    self.sizeLabel.text = [NSString stringWithFormat:@"SIZE:    %@",self.goodItem.goodSize];
    float brandInfoBtnX = 20.f;
    self.brandInfoBtn.frame = CGRectMake(brandInfoBtnX, CGRectGetMaxY(self.sizeLabel.frame), CGRectGetWidth(self.rightView.bounds)-2* brandInfoBtnX, 30.f);
    
    self.brandImageView.frame = CGRectMake(10.f, 2.f, 26.f, 26.f);
    self.brandImageView.layer.borderWidth = 1.f;
    self.brandImageView.layer.borderColor = [UIColor colorWithHexString:@"#dbdbdb"].CGColor;
    self.brandImageView.layer.cornerRadius = 13.f;
    self.brandImageView.layer.masksToBounds = YES;
    self.brandImageView.backgroundColor = [UIColor yellowColor];
    
    self.viewDetailBtn.frame = CGRectMake(brandInfoBtnX, CGRectGetMaxY(self.brandInfoBtn.frame)+10.f, CGRectGetWidth(self.rightView.bounds)-2* brandInfoBtnX, 30.f);
    
    
}

//计算右视图中商品标题的大小
-(CGRect)getGoodTitleFrame {
    NSDictionary* attributes = @{NSFontAttributeName:[UIFont italicSystemFontOfSize:14],NSForegroundColorAttributeName:[UIColor colorWithRed:77/255.f green:77/255.f blue:77/255.f alpha:1]};
    return [self.goodItem.goodTitle boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.rightView.bounds)-10.f, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
}

//增加横向滚动的scrollView视图
-(void)createScrollView{
    [self defineRightBarItem];
    WishlistScrollView* sv = [[WishlistScrollView alloc]initWithFrame:CGRectMake(0, 10.f, CGRectGetWidth(self.view.bounds), (KScreenHeight - kStatusNaviBarH)/3.5) WithWishlistArr:self.clothes];
    sv.myDelegate = self;
    self.bigSV = sv;
    [self.view addSubview:sv];
    float padding = 10.f;
    UIView *topLineView = [[UIView alloc]initWithFrame:CGRectMake(padding*2, CGRectGetMaxY(self.bigSV.frame)+padding, KScreenWidth - 4*padding, 2.f)];
    topLineView.backgroundColor = [UIColor colorWithHexString:@"#dbdbdb"];
    [self.view addSubview:topLineView];
    UIView *bottomLineView = [[UIView alloc]initWithFrame:CGRectMake(padding*2, KScreenHeight- kStatusNaviBarH - 50.f, KScreenWidth - 4* padding, 2.f)];
    bottomLineView.backgroundColor = [UIColor colorWithHexString:@"#dbdbdb"];
    [self.view addSubview:bottomLineView];
}
-(void)createLeftView{
    float padding = 10.f;
    float leftViewX = 0;
    float leftViewY = CGRectGetMaxY(self.bigSV.frame) + 2* padding;
    float leftViewW = KScreenWidth/2;
    float leftViewH = KScreenHeight - kStatusNaviBarH - leftViewY - 50.f;
    UIView* leftView = [[UIView alloc]initWithFrame:CGRectMake(leftViewX, leftViewY, leftViewW, leftViewH)];
    [self.view addSubview:leftView];
    
    leftView.backgroundColor = [UIColor clearColor];
    
    float labelX = 0;
    float labelH = 20.f;
    float labelY = leftViewH - padding -labelH;
    float labelW = leftViewW;
    UILabel * l1 = [[UILabel alloc]initWithFrame:CGRectMake(labelX, labelY, labelW, labelH)];
    l1.textAlignment = NSTextAlignmentCenter;
    l1.font = [UIFont systemFontOfSize:15];
    l1.minimumScaleFactor = 0.7;
    self.goods_price = l1;
    self.goods_price.text = [NSString stringWithFormat:@"Sale Price:$%.2f",self.goodItem.goodPrice.floatValue];
    [leftView addSubview:l1];
    
    float leftH = leftViewH - labelH - padding;
    float leftW = leftViewW - 2* padding;
    float imageViewX,imageViewY,imageViewW,imageViewH;
    float scale = 0.6;
    if (leftW/leftH>=scale) {
        imageViewX = (leftW - scale * leftH)/2 + padding;
        imageViewY = 0;
        imageViewW = scale * leftH;
        imageViewH = leftH;
    } else {
        imageViewX = padding;
        imageViewY = (leftH - leftW/scale)/2;
        imageViewW = leftW;
        imageViewH = leftW/scale;
    }
    UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(imageViewX, imageViewY, imageViewW, imageViewH)];
    imageView.backgroundColor = [UIColor colorWithHexString:@"#dbdbdb"];
    self.goods_img_detail = imageView;
    [self.goods_img_detail sd_setImageWithURL:[NSURL URLWithString:self.goodItem.defaultImage] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.goods_img_detail.image = [UIImage getSubImageByImage:image andImageViewFrame:self.goods_img_detail.frame];
        [[SDImageCache sharedImageCache]storeImage:image forKey:[self.goodItem.defaultImage lastPathComponent] toDisk:YES];
    }];
    [leftView addSubview:imageView];
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
    UIBarButtonItem* barItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(comeback:)];
    self.navigationItem.leftBarButtonItem = barItem;
}
//懒加载
-(NSMutableArray *)clothes{
    if (!_clothes) {
        _clothes = [NSMutableArray array];
    }
    return _clothes;
}
#pragma mark view-life_circle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Wishlist";
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue" size:20],NSForegroundColorAttributeName:[UIColor whiteColor]};
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:@"#1b1b1b"];
    [[UIBarButtonItem appearance]setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60.f) forBarMetrics:UIBarMetricsDefault];
    

    
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
//如果跳转页面未传值，则显示本地未上传给服务器的wishlist列表，如果传值则显示网络上喜欢的历史纪录
    if (!self.receiveArr) {
        [self.clothes addObjectsFromArray:[ModeDatabase readDatabaseFromTableName:WISHLIST_TABLENAME andSelectConditionKey:nil andSelectConditionValue:nil]];
    } else {
        [self.clothes addObjectsFromArray:self.receiveArr];
    }
    self.goodItem = self.clothes[0];
    [self createScrollView];
    [self createRightView];
    [self createLeftView];
//从数据库读取数据
    [self resetAllElementsInRightView];
    
    
    
}
-(NSString*)getUserId{
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"userId"];
}
#pragma mark WishlistScrollViewDelegate
-(void)wishlistScrollView:(WishlistScrollView *)wishlistScrollView didSelectedItemsAtIndex:(NSInteger)index{
    self.goodItem = self.clothes[index];
    self.goods_price.text = [NSString stringWithFormat:@"Sale Price:$%.2f",self.goodItem.goodPrice.floatValue];
    self.couponBtn.enabled = YES;
    if ([self.goodItem.hasCoupon isEqualToString:@"true"]&&[self.goodItem.hasSelected isEqual:@(0)]) {
        [self.couponBtn setSelected:NO];
    } else {
        [self.couponBtn setSelected:YES];
        self.couponBtn.enabled = NO;
    }
    
    [self.goods_img_detail sd_setImageWithURL:[NSURL URLWithString:self.goodItem.defaultImage] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.goods_img_detail.image = [UIImage getSubImageByImage:image andImageViewFrame:self.goods_img_detail.frame];
        [[SDImageCache sharedImageCache]storeImage:image forKey:[self.goodItem.defaultImage lastPathComponent] toDisk:YES];
    }];
    [self resetAllElementsInRightView];
    [self.view setNeedsLayout];
}

#pragma mark Cash-pay
- (IBAction)clickConpon:(UIButton *)sender {
    [sender setSelected:YES];
    sender.enabled = NO;
    self.goodItem.hasSelected = @(1);
#warning 发请求通知服务器已申请优惠券
}




#pragma mark navigationItem.leftBarButtonItem Action
-(void)comeback:(UIBarButtonItem*)btn{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
- (void)gotoNextView:(UIButton *)sender {//跳转时响应
    
    switch (sender.tag) {
        case 1:
        {
            self.navigationController.interactivePopGestureRecognizer.enabled = YES;
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
            if (self.goodItem.brandId) {
                [self performSegueWithIdentifier:@"gotoBrandRunway" sender:self.goodItem.brandId];
            }
        }
            break;
        case 2:
        {
            [self performSegueWithIdentifier:@"gotoWebViewController1" sender:self.goodItem.defaultThumb];
        }
            break;
        default:
            break;
    }
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"gotoBrandRunway"]) {
        BrandRunwayTableViewController* bc = segue.destinationViewController;
        bc.brandId = sender;
    } else if ([segue.identifier isEqualToString:@"gotoWebViewController1"]) {
        WebViewViewController* wc = segue.destinationViewController;
        wc.website = sender;
    }
    
}


@end
