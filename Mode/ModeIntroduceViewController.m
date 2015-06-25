//
//  ModeIntroduceViewController.m
//  Mode
//
//  Created by huangmin on 15/6/3.
//  Copyright (c) 2015年 YedaoDEV. All rights reserved.
//

#import "ModeIntroduceViewController.h"
#import "AppDelegate.h"
#import "LaunchViewController.h"
#import "ModeUtils.h"
#import "UIColor+HexString.h"
#import "Common.h"
@interface ModeIntroduceViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) UIScrollView *introScrollView;
@property(nonatomic,strong)NSArray *imageNames;
@property(nonatomic,strong)UIPageControl* pageControl;
@property (weak, nonatomic) UIButton *startBtn;
@end

@implementation ModeIntroduceViewController

- (NSArray *)imageNames{
    if (!_imageNames) {
        _imageNames = @[@"welcome1.png",@"welcome2.png",@"welcome3.png"];
    }
    return _imageNames;
}
-(void)dealloc{
    self.imageNames = nil;
    self.pageControl = nil;
    self.introScrollView = nil;
    NSLog(@"IntroVC dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
#warning 这个数据库表可能废弃，因为没有用户userId
    [ModeUtils initDatabase];//这个数据库建在哪  目前还不知道  可能因此废弃
    UIScrollView* scrollView = [[UIScrollView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.introScrollView = scrollView;
    self.introScrollView.contentSize = CGSizeMake(self.introScrollView.frame.size.width*self.imageNames.count, self.introScrollView.frame.size.height);
    for (NSInteger i=0; i<self.imageNames.count; i++) {
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:self.imageNames[i]]];
        //创建一个frame变量，并赋值
        CGRect imageFrame = CGRectZero;
        imageFrame.size = self.introScrollView.frame.size;
        imageFrame.origin.y = 0;
        imageFrame.origin.x = i*self.introScrollView.frame.size.width;
        //将设置到好的frame变量给image
        imageView.frame = imageFrame;
        [self.introScrollView addSubview:imageView];
    }
    //配置scrollView
    //设置整页滚动
    self.introScrollView.pagingEnabled = YES;
    //设置边缘不弹跳
    self.introScrollView.bounces = NO;
    //设置水平滚动条不显示
    self.introScrollView.showsHorizontalScrollIndicator =NO;
    //设置scrollView的代理
    self.introScrollView.delegate = self;
    [self.view addSubview:self.introScrollView];
    
    
    
    //创建pageControl
    UIPageControl *pageControl = [[UIPageControl alloc]init];
    self.pageControl = pageControl;
    pageControl.frame = CGRectMake(0, self.view.frame.size.height-10-30, self.view.frame.size.width, 30);
    pageControl.numberOfPages = self.imageNames.count;
    //设置圆点的颜色
    pageControl.pageIndicatorTintColor = [UIColor colorWithHexString:@"#403434"];
    //设置被选中的圆点的颜色
    pageControl.currentPageIndicatorTintColor = [UIColor colorWithHexString:@"#ff00ea"];
    //关闭用户交互功能
    pageControl.userInteractionEnabled = NO;
    [self.view addSubview:pageControl];
    
    //为最后一屏添加按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"startGo.png"] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor clearColor];
    button.alpha = 0.f;
    button.frame = CGRectMake(0, 0, 140.f, 40.f);
    self.startBtn = button;
    //为按钮添加点击事件
    [button addTarget:self action:@selector(enterApp) forControlEvents:UIControlEventTouchUpInside];
    [self.introScrollView addSubview:button];
}
-(void)viewWillAppear:(BOOL)animated{
    self.startBtn.center = CGPointMake(KScreenWidth*self.imageNames.count - KScreenWidth/2, KScreenHeight - 50.f);
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    // 获取移动的偏移定点坐标
    CGPoint offSet = scrollView.contentOffset;
    //根据坐标算出滚动到第几屏的位置下标
    NSInteger index = offSet.x/scrollView.frame.size.width;
    self.pageControl.currentPage=index;
    
    self.startBtn.alpha = (offSet.x-KScreenWidth)/(KScreenWidth)>=0?(offSet.x-KScreenWidth)/(KScreenWidth):0;
}

-(void)enterApp{
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"notFirstTime"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    LaunchViewController* lvc = [[AppDelegate globalDelegate].drawersStoryboard instantiateViewControllerWithIdentifier:@"LaunchViewController"];
    [AppDelegate globalDelegate].window.rootViewController = lvc;
}



@end
