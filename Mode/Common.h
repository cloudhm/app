//
//  Common.h
//  muzhicheng
//
//  Created by MX on 15/2/10.
//  Copyright (c) 2015年 focoon. All rights reserved.
//  公用宏
#define kIos_8  [[UIDevice currentDevice].systemVersion floatValue] >= 8.0

// 获得RGB颜色
#define kColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define kColorAlpha(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]
// 屏幕的宽和高
#define KScreenWidth    [UIScreen mainScreen].bounds.size.width   //宽
#define KScreenHeight   [UIScreen mainScreen].bounds.size.height  //高
// 状态栏的高
#define kStatusHeight   ([[UIApplication sharedApplication] statusBarFrame].size.height)
// 导航栏的高
#define kNavigationBarH (self.navigationController.navigationBar.frame.size.height)
// 状态栏和导航栏的总高
#define kStatusNaviBarH (kStatusHeight+kNavigationBarH)
// tabbar的高
#define kTabbarH 49
// 分隔线高
#define kLineH 0.5

// 颜色值宏函数
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define UIColorFromRGBAlpha(rgbValue, a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]

// 计算字符串宽高
#define kTextRect(label, maxWidth) [label.text boundingRectWithSize:CGSizeMake(maxWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : label.font} context:nil]

// 产生占位图片底色
#define kPlaceholderImage 0xb5b5ac
#define kPlaceholderImg [UIImage imageWithColor:UIColorFromRGB(0xb5b5ac)]

// 判断是否为iphone4的宏
#define isIPhone4s ([UIScreen mainScreen].bounds.size.height == 480)
// 判断是否为iphone5的宏
#define isIPhone5 ([UIScreen mainScreen].bounds.size.height == 568)
// 判断是否为iPhone6的宏
#define isIPhone6 ([UIScreen mainScreen].bounds.size.height == 667)
// 判断是否为iphone6plus的宏
#define isIPhone6plus ([UIScreen mainScreen].bounds.size.height == 736)

// 适配宏函数
#define kFontScreenFit(value)     (isIPhone6plus ? ((value)*1.0) : value) // 字体
#define kMarginScreenFit(value)   (isIPhone6plus ? ((value)*1.0) : value) // 间距
#define kHeightScreenFit(value)   (isIPhone6plus ? ((value)*1.0) : value) // 高度
#define kWidthScreenFit(value)    (isIPhone6plus ? ((value)*1.0) : value) // 宽度
#define kIconScreenFit(value)     (isIPhone6plus ? ((value)*1.0) : value) // 图标，适用于宽高
#define kSmallImageScreenFit(value) (isIPhone6plus ? ((value)*1.3) : value) // 内容小图片，适用于宽高，5/6不变，6plus*1.3
#define kImageScreenFit(value)    (isIPhone6plus ? ((value)*1.3) : (isIPhone6 ? floor((value)*(375/320.0)*100)/100 : value)) // 内容图片，适用于宽高且宽是屏宽，floor保留小数位数，100保留两位
#define kPickerViewFit(value)    (isIPhone6plus ? ((value)*1.0) : value) // pickerView
#define kSpecialIconScreenFit(value)    (isIPhone6plus ? ((value)*1.5) : value) // 特殊头像适配
// floor保留小数位数，100保留两位
#define floor(value) (floor((value) * 100)/100)



// appdelegate
#define kAppDelegate [UIApplication sharedApplication].delegate
