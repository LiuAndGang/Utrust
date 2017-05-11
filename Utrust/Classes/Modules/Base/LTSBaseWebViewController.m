//
//  LTSBaseWebViewController.m
//  SAIFAMC
//
//  Created by 李棠松 on 16/8/17.
//  Copyright © 2016年 leetangsong. All rights reserved.
//

#import "LTSBaseWebViewController.h"
#import "WKDelegateController.h"
#import "LTSMessageOtherViewController.h"
#import "WKWebViewJavascriptBridge.h"
#import "FileShowViewController.h"
@interface LTSBaseWebViewController ()<WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler>{
    WKWebViewConfiguration *configuration;
    UIView *topView;
}

@property WKWebViewJavascriptBridge *webViewBridge;
@end

@implementation LTSBaseWebViewController


- (void)dealloc{
    [configuration.userContentController removeScriptMessageHandlerForName:@"shouldOverrideUrlLoading"];
    [configuration.userContentController removeScriptMessageHandlerForName:@"closeWindow"];
    
//    [configuration.userContentController removeScriptMessageHandlerForName:@"iOSopenFile"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BlueColor;
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    
}
- (void)initUI{
    UIView *view = [UIView new];
    view.frame = CGRectMake(0, 0, Screen_Width, 20);
    [self.view addSubview:view];
    view.backgroundColor = BlueColor;
    topView = view;
//    view.hidden = YES;
    [self webView];
//    [self.webView.scrollView beginActLoading];
    
    //注册方法
    [self addHandler];
}

- (void)initData
{

    
    NSMutableURLRequest *requst = [NSMutableURLRequest requestWithURL:self.url];
    [requst addValue:LTSUserDes.token forHTTPHeaderField:@"token"];
    NSLog(@"token:%@",LTSUserDes.token);
    NSLog(@"url：%@",self.url);
    [self.webView loadRequest:requst];
    

}

- (void)addHandler{
    [configuration.userContentController addScriptMessageHandler:self name:@"shouldOverrideUrlLoading"];
    [configuration.userContentController addScriptMessageHandler:self name:@"closeWindow"];
    
//    [configuration.userContentController addScriptMessageHandler:self name:@"iOSopenFile"];

}

#pragma mark --  WKScriptMessageHandler -- 


// 从web界面中接收到一个脚本时调用
#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    
     NSLog(@"%@,%@",message.name,message.body);
    if ([message.name  isEqualToString:@"closeWindow"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
   
    if ([message.name isEqualToString:@"shouldOverrideUrlLoading"]) {
        
        NSString *str = [kLTSDBBaseUrl stringByAppendingFormat:@"%@",message.body[@"url"]];
        LTSMessageOtherViewController *other = [LTSMessageOtherViewController new];
        other.url = [NSURL URLWithString:str];
        if ([message.body[@"type"] isEqualToString:@"newWin"]) {
            [self.navigationController pushViewController:other animated:YES];
            //
//            [self.webView reload];

        }
        
    }
    
//    if ([message.name isEqualToString:@"iOSopenFile"]) {
//        NSArray *array = message.body;
//        NSLog(@"js返回的数组：%@",message.body);
//    }
    
    //    message.body  --  Allowed types are NSNumber, NSString, NSDate, NSArray,NSDictionary, and NSNull.
   
    [self addEventWithMessage:message];
}

- (void)addEventWithMessage:(WKScriptMessage *)message{

}

#pragma mark -------------WKNavigationDelegate 用来追踪加载过程 和 页面跳转的代理方法----------------

//发送请求之前决定是否跳转
- (void)webView:(UIWebView *)webView decidePolicyForNavigationAction:(nonnull WKNavigationAction *)navigationAction decisionHandler:(nonnull void (^)(WKNavigationActionPolicy))decisionHandler {
    
    
    NSString * requestString = [[navigationAction.request URL] absoluteString];
    requestString = [requestString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"------%@",requestString);
    
    if([requestString containsString:@"generalController.do?checkIphoneFile&id="]) {//确定是文件预览的url，然后截获该url
        decisionHandler(WKNavigationActionPolicyCancel);//不允许跳转
        
        //        _context=[webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
        //        //iOSopenFile 为web调用方法
        //        _context[@"iOSopenFile"] = ^(){
        //
        //            FileShowViewController *vc = [FileShowViewController new];
        //
        //            //web传过来参数的数组
        //            NSArray * args = [JSContext currentArguments];
        //            //打开文件操作 调用本地方法
        //            vc.vcTitle = ((JSValue *)args[0]).toString;
        //            vc.htmlString = ((JSValue *)args[1]).toString;
        //
        //            [self presentViewController:vc animated:YES completion:nil];
        //        };
        
        
        FileShowViewController *vc = [FileShowViewController new];
        vc.htmlString = requestString;
        [self.navigationController pushViewController:vc animated:YES];
        
    } else {
        
        decisionHandler(WKNavigationActionPolicyAllow);//允许跳转
        
        
    }
    
    //获取H5页面里面按钮的操作方法,根据这个进行判断返回是内部的还是push的上一级页面
    //    if ([requestString hasPrefix:@"goback:"]) {
    //        [self.navigationController popViewControllerAnimated:YES];
    //    }else{
    //        [self.webView goBack];
    //    }
    //    return YES;
}

//收到服务器的跳转请求之后调用
//-(void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
//
//}
//收到响应之后决定是否跳转decidePolicyForNavigationResponse
//- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
//
//}

//页面开始加载时调用
//- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
//
//}
//页面开始返回时调用
//-(void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
//    
//}

//页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{

    [webView evaluateJavaScript:@"document.documentElement.style.webkitUserSelect='none';" completionHandler:nil];
    
    
    [webView evaluateJavaScript:@"document.documentElement.style.webkitTouchCallout='none';" completionHandler:nil];
   
}

//页面加载失败时调用
//-(void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
//
//}


#pragma mark -------------WKUIDelegate  处理web界面的三种提示框（警告框，输入框，确认框）--------------------

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{    // js 里面的alert实现，如果不实现，网页的alert函数无效
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"知道了"
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction *action) {
                                                          completionHandler();
                                                      }]];
    
    [self presentViewController:alertController animated:YES completion:^{
        
    }];
    
}

#pragma mark ----------------------------其他----------------------------
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return nil;
}


-(WKWebView *)webView{
    if (!_webView) {
        configuration = [[WKWebViewConfiguration alloc]init];
        configuration.userContentController = [[WKUserContentController alloc]init];
        
        _webView = [[WKWebView alloc]initWithFrame:self.view.bounds configuration:configuration];
        
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
        _webView.scrollView.bounces = NO;
        _webView.autoresizingMask =(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        [self.view addSubview:_webView];

        _webView.multipleTouchEnabled=YES;
        
        _webView.userInteractionEnabled=YES;
        
//        _webView
        
        [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(20, 0, 49, 0));
        }];
    }
    return _webView;
}
@end
