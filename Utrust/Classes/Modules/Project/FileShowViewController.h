//
//  FileShowViewController.h
//  Utrust
//
//  Created by 刘刚 on 2017/5/10.
//  Copyright © 2017年 李棠松. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import <JavaScriptCore/JavaScriptCore.h>
@interface FileShowViewController : UIViewController
@property (nonatomic,strong)UIWebView *webView;
@property (nonatomic,strong)NSURL *url;
@property(nonatomic,copy) NSString * vcTitle;
@property (nonatomic,strong)NSString *htmlString;
@property (nonatomic,weak) JSContext * context;


@end
