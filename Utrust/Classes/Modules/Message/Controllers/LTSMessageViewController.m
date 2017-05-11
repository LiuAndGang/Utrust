//
//  LTSMessageViewController.m
//  CMSP
//
//  Created by 李棠松 on 2016/12/1.
//  Copyright © 2016年 李棠松. All rights reserved.
//

#import "LTSMessageViewController.h"
#import "LTSMessageOtherViewController.h"
@interface LTSMessageViewController ()<WKUIDelegate,WKNavigationDelegate>

@end

@implementation LTSMessageViewController


- (void)viewDidLoad {

    NSString *urlStr = [kLTSDBBaseUrl stringByAppendingString:@"appInterfaceController.do?oauthview#/home"];
//    NSMutableURLRequest *requst = [NSMutableURLRequest requestWithURL:];
    NSLog(@"string：%@",urlStr);
    self.url = [NSURL URLWithString:urlStr];

//    [self.webView loadRequest:[NSURLRequest requestWithURL:self.url]];
//
//    [self.view addSubview:self.webView];
    
    [[LTSNotification rac_addObserverForName:KNotification_MessageChange  object:nil] subscribeNext:^(id x) {
        NSString *refreshJS = @"UCG_refreshMessage()";
        [self.webView evaluateJavaScript:refreshJS completionHandler:^(id response, NSError * _Nullable error) {
            
        }];
    }];

    [super viewDidLoad];

    
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
