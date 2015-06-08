//
//  LikeOrNopeViewController.h
//  Mode
//
//  Created by YedaoDEV on 15/5/25.
//  Copyright (c) 2015年 YedaoDEV. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChooseClothesView.h"
@class ModeGood;
@interface LikeOrNopeViewController : UIViewController<MDCSwipeToChooseDelegate>
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) IBOutlet UILabel *tabLabel;
@property (nonatomic,assign) NSInteger number;
@property (nonatomic,assign) NSInteger totalNumber;
@property (strong, nonatomic) NSDictionary *params;
@property (nonatomic, strong) ModeGood *currentCloth;
@property (nonatomic, strong) ChooseClothesView *firstCardView;
@property (nonatomic, strong) ChooseClothesView *secondCardView;
@property (nonatomic, strong) ChooseClothesView *thirdCardView;
@property (nonatomic, strong) ChooseClothesView *fourthCardView;
@property (strong, nonatomic) NSDictionary *dictionary;
@end
