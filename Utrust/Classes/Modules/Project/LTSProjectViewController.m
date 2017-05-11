//
//  LTSProjectViewController.m
//  CMSP
//
//  Created by 李棠松 on 2016/12/1.
//  Copyright © 2016年 李棠松. All rights reserved.
//

#import "LTSProjectViewController.h"
#import "LTSBaseWebViewController.h"
#import "LTSMessageOtherViewController.h"
@interface LTSProjectViewController ()<WKUIDelegate,WKNavigationDelegate>


@end

@implementation LTSProjectViewController


- (void)dealloc{
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"shouldOverrideUrlLoading"];
}
- (void)viewDidLoad {
     NSString *urlStr = [kLTSDBBaseUrl stringByAppendingString:@"appInterfaceController.do?oauthview#/work"];
    self.url = [NSURL URLWithString:urlStr];
   
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
