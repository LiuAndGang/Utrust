//
//  LTSExonerateViewController.m
//  Utrust
//
//  Created by 李棠松 on 2017/1/6.
//  Copyright © 2017年 李棠松. All rights reserved.
//

#import "LTSExonerateViewController.h"
@import WebKit;
@interface LTSExonerateViewController ()
@property (nonatomic,strong)WKWebView *webView;
@end

@implementation LTSExonerateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _webView = [[WKWebView alloc]initWithFrame:self.view.bounds ];
    
  
    _webView.autoresizingMask =(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    [self.view addSubview:_webView];
    
    _webView.multipleTouchEnabled=YES;
    
    _webView.userInteractionEnabled=YES;
   
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[kLTSDBBaseUrl stringByAppendingString:@"webpage/common/disclaimer.html"]]];
    [_webView loadRequest:request];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
