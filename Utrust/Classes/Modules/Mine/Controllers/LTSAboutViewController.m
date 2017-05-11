//
//  LTSAboutViewController.m
//  CMSP
//
//  Created by 李棠松 on 2016/12/8.
//  Copyright © 2016年 李棠松. All rights reserved.
//

#import "LTSAboutViewController.h"

@interface LTSAboutViewController ()
@property (nonatomic,strong)SettingView *tableView;
@end

@implementation LTSAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于";
    // Do any additional setup after loading the view.
}
- (void)initUI{
    
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_aboutlogo"]];
    imageView.contentMode = UIViewContentModeCenter;
    [self.view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(240*Scale);
    }];
    
    SettingView *tableView  = [SettingView new];
    tableView.sectionHeaderHeight  = 0;
    tableView.bottomLineLeftOffset = 0;
    tableView.backgroundColor = BGColorGray;
    [self.view addSubview:tableView];
    tableView.rowHeight = 44;
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(imageView.mas_bottom).with.offset(0);
    }];
    self.tableView = tableView;
    
    [self addTableViewGroup1];
    
}
- (void)addTableViewGroup1{
    SettingGroup *group = [self.tableView addGroup];
    SettingItem *item1 = [SettingArrowItem itemWithTitle:@"公司介绍"];
    item1.operation = ^(){
        
    };

    
    SettingItem *item2 = [SettingArrowItem itemWithTitle:@"版本检测"];
    item2.operation = ^(){
    };
    
    SettingItem *item3 = [SettingArrowItem itemWithTitle:@"客户热线"];
    item3.subtitle = @"020-55555534";
    item3.subtitleColor = HexColor(@"#00b0ec");
    item3.operation = ^(){
        
    };
    group.items  = @[item1,item2,item3];

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
