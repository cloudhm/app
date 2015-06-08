//
//  ShareViewController.m
//  Mode
//
//  Created by YedaoDEV on 15/6/8.
//  Copyright (c) 2015年 YedaoDEV. All rights reserved.
//

#import "ShareViewController.h"
#import "ModeGood.h"
#import "SDWebImage/SDWebImageManager.h"
#import "SDWebImage/UIImageView+WebCache.h"
@interface ShareViewController()<UITextViewDelegate>
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *shareImageViews;

@property (weak, nonatomic) IBOutlet UITextView *shareTextContent;
@end


@implementation ShareViewController
-(void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
//    self.shareTextContent.clearsOnInsertion = YES;
    self.shareTextContent.delegate = self;
    for (int i = 0; i<self.shareImageViews.count; i++) {
        ModeGood* modeGood = self.nineGoods[i];
        UIImageView*iv=self.shareImageViews[i];
        iv.image = [[SDImageCache sharedImageCache]imageFromDiskCacheForKey:[modeGood.img_link lastPathComponent]];
    }
    
}
-(void)viewDidAppear:(BOOL)animated{
    NSLog(@"ShareViewController addObserver");
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(modificationPosition:) name:UIKeyboardWillChangeFrameNotification object:nil];
}
-(void)viewDidDisappear:(BOOL)animated{
    NSLog(@"ShareViewController removeObserver");
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}
-(void)modificationPosition:(NSNotification*)noti{
    
    float animationDuration = [[noti.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey]floatValue];
    CGRect startRect = [[noti.userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey]CGRectValue];
    CGRect endRect = [[noti.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue];
    CGRect rect = self.view.frame;
    rect.origin.y -= (startRect.origin.y - endRect.origin.y+50.f);
    [UIView animateWithDuration:animationDuration animations:^{
        self.view.frame = rect;
    } completion:nil];
}
- (void)textViewDidBeginEditing:(UITextView *)textView{
    if ([self.shareTextContent.text isEqualToString:@"My Collection..."]) {
        self.shareTextContent.text = @"";
    }
}
- (IBAction)sendShareAndPostNotification:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(shareViewController:shareNineModeGoodsToOthers:andTextContent:)]) {
        [self.delegate shareViewController:self shareNineModeGoodsToOthers:self.nineGoods andTextContent:self.shareTextContent.text];
    }
}

@end
