//
//  LTSMessageOtherViewController.m
//  Utrust
//
//  Created by 李棠松 on 2017/1/4.
//  Copyright © 2017年 李棠松. All rights reserved.
//

#import "LTSMessageOtherViewController.h"

@interface LTSMessageOtherViewController ()<WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler>
//@property (nonatomic,strong)WKWebView *webView;
@end

@implementation LTSMessageOtherViewController




- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self.webView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(20, 0, 0, 0));
    }];
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
