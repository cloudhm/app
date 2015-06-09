//
//  HomeViewController.m
//  MutilPage
//
//  Created by YedaoDEV on 15/5/19.
//  Copyright (c) 2015年 YedaoDEV. All rights reserved.
//

#import "HomeViewController.h"
#import "OccasionViewController.h"
#import "BrandViewController.h"
#import "StyleViewController.h"


#import "JVFloatingDrawerSpringAnimator.h"
#import "AppDelegate.h"

#import "SDWebImage/SDImageCache.h"
#import "FMDB.h"
#import "UIColor+HexString.h"
@interface HomeViewController ()<ViewPagerDataSource,ViewPagerDelegate>
@property (strong, nonatomic) NSArray *tabNames;

@end

@implementation HomeViewController
- (IBAction)clearCache:(UIBarButtonItem *)sender {
    NSLog(NSHomeDirectory());
    [[SDImageCache sharedImageCache]clearDiskOnCompletion:^{
        [self removeDataBase];
        NSLog(@"clear success");
    }];
    [[SDImageCache sharedImageCache]clearMemory];
}
-(void)removeDataBase{
//    NSString* documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
//    NSString* path = [documentPath stringByAppendingPathComponent:@"my.sqlite"];
//    
//    NSError *err;
//    [[NSFileManager defaultManager]removeItemAtPath:path error:&err];
//    NSLog(@"%@",err);
    
    NSUserDefaults* ud=[NSUserDefaults standardUserDefaults];
    [ud removeObjectForKey:@"brandlist_utime"];
    [ud removeObjectForKey:@"occssionlist_utime"];
    [ud removeObjectForKey:@"stylelist_utime"];
    [ud synchronize];
    
}
/**
 *  标签栏
 */
-(NSArray *)tabNames{
    if (_tabNames==nil) {
        _tabNames = @[@"OCCASION",@"BRAND",@"STYLE"];
    }
    return _tabNames;
}
- (IBAction)actionToggleLeftDrawer:(UIBarButtonItem *)sender {
    [[AppDelegate globalDelegate] toggleLeftDrawer:self animated:YES];
}
- (void)viewDidLoad {
    self.delegate = self;
    self.dataSource = self;
    [super viewDidLoad];
    self.title = @"MODE";
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue" size:20],NSForegroundColorAttributeName:[UIColor whiteColor]};
}

#pragma mark ViewPagerDatasource
-(NSUInteger)numberOfTabsForViewPager:(ViewPagerController *)viewPager{
    return 3;
}
/**
 *  标签视图
 */

-(UIView *)viewPager:(ViewPagerController *)viewPager viewForTabAtIndex:(NSUInteger)index{
    UILabel *label = [UILabel new];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
    label.text = self.tabNames[index];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithHexString:@"#b4b4b4"];
    [label sizeToFit];
    return label;
}

/**
 *  内容视图
 */
-(UIViewController *)viewPager:(ViewPagerController *)viewPager contentViewControllerForTabAtIndex:(NSUInteger)index{
    switch (index) {
        case 0:
        {
            OccasionViewController *ovc = [self.storyboard instantiateViewControllerWithIdentifier:@"OccasionViewController"];
            return ovc;
        }
            break;
        case 1:
        {
            BrandViewController *bvc = [self.storyboard instantiateViewControllerWithIdentifier:@"BrandViewController"];
            return bvc;
        }
            break;
        case 2:
        {
            StyleViewController *svc = [self.storyboard instantiateViewControllerWithIdentifier:@"StyleViewController"];
            return svc;
        }
            break;
    }
    return nil;
}
#pragma mark - ViewPagerDelegate
- (CGFloat)viewPager:(ViewPagerController *)viewPager valueForOption:(ViewPagerOption)option withDefault:(CGFloat)value {
    
    switch (option) {
        case ViewPagerOptionStartFromSecondTab:
            return 1.0;
            break;
        case ViewPagerOptionCenterCurrentTab:
            return 0.0;
            break;
        case ViewPagerOptionTabLocation:
            return 1.0;
            break;
        default:
            break;
    }
    
    return value;
}
- (UIColor *)viewPager:(ViewPagerController *)viewPager colorForComponent:(ViewPagerComponent)component withDefault:(UIColor *)color {
    
    switch (component) {
        case ViewPagerIndicator:
            return [UIColor colorWithRed:183.0/255.0 green:220.0/255.0 blue:173.0/255.0 alpha:1];
            break;
        default:
            break;
    }
    
    return color;
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
