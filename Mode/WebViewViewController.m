//
//  WebViewViewController.m
//  Mode
//
//  Created by YedaoDEV on 15/6/9.
//  Copyright (c) 2015年 YedaoDEV. All rights reserved.
//

#import "WebViewViewController.h"


@interface WebViewViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
//@property (strong, nonatomic) nsur *<#name#>;
@end

@implementation WebViewViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView.delegate = self;
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.website]];
    self.webView.scalesPageToFit = YES;
    [self.webView loadRequest:request];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *urlPath = [request.URL description];
    switch (navigationType) {
#warning 该代理方法中把用户点击的链接，用户提交form，用户重新提交form纪录
        case UIWebViewNavigationTypeLinkClicked:
            NSLog(@"user click:%@",urlPath);
            break;
        case UIWebViewNavigationTypeFormSubmitted:
            NSLog(@"from user submitted:%@",urlPath);
            break;
        case UIWebViewNavigationTypeFormResubmitted:
            NSLog(@"from user resubmitted:%@",urlPath);
            break;
        default:
            break;
    }
    return YES;
}



@end
