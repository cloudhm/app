//
//  LikeOrNopeViewController.h
//  Mode
//
//  Created by YedaoDEV on 15/5/25.
//  Copyright (c) 2015年 YedaoDEV. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChooseClothesView.h"
//喜欢不喜欢评测界面
@class GoodItem;
@interface LikeOrNopeViewController : UIViewController<MDCSwipeToChooseDelegate>
@property (weak, nonatomic) IBOutlet UIView *bottomView;//下半部视图，用来把下半部整体插入subView 0的位置，在拖动显示时可以在拖动图片下方

@property (weak, nonatomic) IBOutlet UILabel *tabLabel;
@property (nonatomic,assign) NSInteger number;
@property (nonatomic,assign) NSInteger totalNumber;
@property (strong, nonatomic) NSDictionary *params;
@property (nonatomic, strong) GoodItem *currentCloth;
@property (nonatomic, strong) ChooseClothesView *firstCardView;
@property (nonatomic, strong) ChooseClothesView *secondCardView;
@property (nonatomic, strong) ChooseClothesView *thirdCardView;
@property (nonatomic, strong) ChooseClothesView *fourthCardView;
@property (strong, nonatomic) NSArray *receiveArr;
@end
