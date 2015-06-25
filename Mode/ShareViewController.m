//
//  ShareViewController.m
//  Mode
//
//  Created by YedaoDEV on 15/6/8.
//  Copyright (c) 2015年 YedaoDEV. All rights reserved.
//

#import "ShareViewController.h"
#import "GoodItem.h"
#import "SDWebImage/SDWebImageManager.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "UIImage+PartlyImage.h"
@interface ShareViewController()<UITextViewDelegate>
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *shareImageViews;
@property (weak, nonatomic) IBOutlet UIButton *shareFacebookBtn;

@property (weak, nonatomic) IBOutlet UITextView *shareTextContent;

@property (weak, nonatomic) IBOutlet UIView *editView;
@property (weak, nonatomic) UIImage *shareImage;
@end


@implementation ShareViewController
-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.shareFacebookBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    self.shareFacebookBtn.layer.borderWidth = 1.f;
    self.view.backgroundColor = [UIColor clearColor];
    self.shareTextContent.delegate = self;
    for (int i = 0; i<self.shareImageViews.count; i++) {
        GoodItem* goodItem = self.nineGoods[i];
        UIImageView*iv=self.shareImageViews[i];
        iv.image = [UIImage getSubImageByImage:[[SDImageCache sharedImageCache]imageFromDiskCacheForKey:[goodItem.defaultImage lastPathComponent]] andImageViewFrame:iv.frame];
    }
    
}
-(UIImage *)getImageFromView:(UIView *)view{
    //创建一个画布
    UIGraphicsBeginImageContext(view.frame.size);
    //    把view中的内容渲染到画布中
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    //    把画布中的图片取出来
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    //结束渲染
    UIGraphicsEndImageContext();
    return image;
}

- (IBAction)shareFacebook:(UIButton *)sender {
    [sender setSelected:!sender.selected];

    
    NSArray *activityItems;
    
    if (self.shareImage != nil) {
        activityItems = @[self.shareTextContent, self.shareImage];
    } else {
        activityItems = @[self.shareTextContent];
    }
    
    UIActivityViewController *activityController =
    [[UIActivityViewController alloc] initWithActivityItems:activityItems
                                      applicationActivities:nil];
    
    [self presentViewController:activityController
                       animated:YES completion:nil];
    
    

}




-(void)viewDidAppear:(BOOL)animated{
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(modificationPosition:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    
    UIImage* image = [self getImageFromView:self.editView];
    self.shareImage = image;
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
//    UIAlertView *alertView =[[UIAlertView alloc]initWithTitle:@"提示" message:@"图片保存完成" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//    [alertView show];
}
-(void)viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}

-(void)modificationPosition:(NSNotification*)noti{
#warning 高度有问题
    float animationDuration = [[noti.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey]floatValue];
    CGRect startRect  = [[noti.userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey]CGRectValue];
    CGRect endRect = [[noti.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue];
    CGRect rect = self.view.frame;
    rect.origin.y -= CGRectGetMinY(startRect) - CGRectGetMinY(endRect);
    [UIView animateWithDuration:animationDuration animations:^{
        self.view.frame = rect;
    } completion:nil];
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    if ([self.shareTextContent.text isEqualToString:@"My Collection..."]) {
        self.shareTextContent.text = @"";
        self.shareTextContent.textColor = [UIColor blackColor];
    }
}
- (IBAction)sendShareAndPostNotification:(UIButton *)sender {

    if ([self.delegate respondsToSelector:@selector(shareViewController:shareNineModeGoodsToOthers:andTextContent:startAnimation:shareImagesToFacebook:)]) {
        [self.delegate shareViewController:self shareNineModeGoodsToOthers:self.nineGoods andTextContent:self.shareTextContent.text startAnimation:self.avtivityView shareImagesToFacebook:self.shareImage];

    }
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
