//
//  FileShowViewController.m
//  Utrust
//
//  Created by 刘刚 on 2017/5/10.
//  Copyright © 2017年 李棠松. All rights reserved.
//

#import "FileShowViewController.h"
#define Width (self.view.bounds.size.width)
#define Height (self.view.bounds.size.height)

@interface FileShowViewController ()
/**左上角返回上一级按钮*/
@property (nonatomic,strong) UIButton *backBtn ;
@property (nonatomic,strong) UIView *topView;
@property (nonatomic,strong) UILabel *titleLabel;
//@property(nonatomic,copy) NSString * vcTitle;

@end

@implementation FileShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNavBar];

    [self initWebView];
    //webView适配底部tabar和导航栏
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

-(void)initNavBar
{
    _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _backBtn.frame = CGRectMake(10, 20, 20, 20);
    [_backBtn setImage:[UIImage imageNamed:@"icon_nav_back"] forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_backBtn];
}



-(void)initWebView{
    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0,Width, Height-64)];
    NSURL *url = [NSURL URLWithString:self.htmlString];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    
    [self.view addSubview:self.webView];
    
}
//- (void)webViewDidStartLoad:(UIWebView *)webView{
//    _context=[webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
//    //iOSopenFile 为web调用方法
//    _context[@"iOSopenFile"] = ^(){
//
//        ViewController *vc = [ViewController new];
//
//        //web传过来参数的数组
//        NSArray * args = [JSContext currentArguments];
//        //打开文件操作 调用本地方法
//        vc.vcTitle = ((JSValue *)args[0]).toString;
//        vc.htmlString = ((JSValue *)args[1]).toString;
//    };
//
//
//}
-(void)back:(UIButton *)btn
{
    if (self.webView.canGoBack) {
        [self.webView goBack];
        
    }else{
        [self.view resignFirstResponder];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
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
