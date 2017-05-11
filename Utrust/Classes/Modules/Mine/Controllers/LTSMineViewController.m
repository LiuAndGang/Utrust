//
//  LTSMineViewController.m
//  CMSP
//
//  Created by 李棠松 on 2016/12/1.
//  Copyright © 2016年 李棠松. All rights reserved.
//

#import "LTSMineViewController.h"
#import "SettingView.h"
#import "LTSUserInfoViewController.h"
#import "LTSAboutViewController.h"
#import "LTSLoginViewController.h"
#import "LTSChangePassWordViewController.h"
#import "LTSExonerateViewController.h"
#import "LTSCheckUpdate.h"
#import "LTSWarnAlertView.h"

@interface LTSMineViewController () <OtherDelegate>

@property (nonatomic,strong)UIImageView *headerImage;

@property (nonatomic,strong)UIImageView *login;

@property (nonatomic,strong) NSString *name;

@property (nonatomic,strong)UIButton *messgaeButton;

@property (nonatomic,strong)SettingView *tableView;

@property (nonatomic,strong)UILabel *nameLabel;
@end

@implementation LTSMineViewController


- (void)returnName:(NSData *)image {
    _headerImage.image = [UIImage imageWithData:image];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    [[LTSNotification rac_addObserverForName:KNotification_UserInfoUpdate object:nil] subscribeNext:^(id x) {
        if (LTSUserDes.empName.length) {
            self.nameLabel.text = LTSUserDes.empName;
        }
        else  self.nameLabel.text = @"未设置";
        
        if (!LTSUserDes.portraitUrl.length) {
            LTSUserDes.portraitUrl = @" ";
        }
   
        [self.headerImage sd_setImageWithURL:[NSURL URLWithString:[kLTSDBBaseUrl stringByAppendingString:LTSUserDes.portraitUrl]] placeholderImage:[UIImage imageNamed:@"header_placeholder"]];
        
    }];

}

- (void)initUI{
    //头部试图
    UIImageView *view = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"mine"]];
    view.backgroundColor = BlueColor;
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(750/1242.0 * Screen_Width);
    }];

    //头像
   
    UIImageView *headerDefault =[[UIImageView alloc] init];
    [headerDefault setUserInteractionEnabled:YES];
    if (!LTSUserDes.portraitUrl.length) {
        LTSUserDes.portraitUrl = @" ";
    }
    [headerDefault sd_setImageWithURL:[NSURL URLWithString:[kLTSDBBaseUrl stringByAppendingString:LTSUserDes.portraitUrl]] placeholderImage:[UIImage imageNamed:@"header_placeholder"]];
    
    //设置圆角
    headerDefault.layer.cornerRadius = (57 * Screen_Width/375) /2;
    //将多余的部分切掉
    headerDefault.layer.masksToBounds = YES;
//    [headerDefault sd_setImageWithURL:[NSURL URLWithString:[kLTSDBBaseUrl stringByAppendingString:LTSUserDes.portraitUrl]] placeholderImage:[UIImage imageNamed:@"header_placeholder"]];
    [view addSubview:headerDefault];
    [headerDefault mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(view.mas_left).with.offset(158*Screen_Width/375);
        make.top.mas_equalTo(view.mas_top).with.offset(80*Screen_Width/375);
        make.size.mas_equalTo(CGSizeMake(57 * Screen_Width/375, 57* Screen_Width/375));
//        make.bottom.mas_equalTo(self.nameLabel.mas_top).with.offset(-10);
    }];
  
    self.headerImage = headerDefault;
    headerDefault.userInteractionEnabled = YES;
    
//    self.messgaeButton = ({UIButton *button = [UIButton new];
//        [view addSubview:button];
//        [button setImage:[UIImage imageNamed:@"icon_nomessage"] forState:UIControlStateNormal];
//        
//        [button mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(30);
//            make.right.mas_equalTo(-12);
//            
//        }];
//        
//        button;
//    });

    self.nameLabel = ({UILabel *label = [UILabel new];
        [view addSubview:label];
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = LTSUserDes.empName;
        label.font = [UIFont systemFontOfSize:14];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.headerImage.mas_bottom).with.offset(10);
            make.height.mas_equalTo(15);
            make.centerX.mas_equalTo(view.mas_centerX);
        }];
        
        label;
    });
    
    
    self.login = ({UIImageView *imageView = [UIImageView new];
        [headerDefault addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(58, 58));
            make.center.mas_equalTo(CGPointMake(0, 0));
            
            }];
        ViewRadius(imageView, 58/2.0);
        
        imageView;
    });
    
    
  
    
    self.tableView = ({SettingView *tableView = [[SettingView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        tableView.backgroundColor = BGColorGray;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.rowHeight = 44;
        tableView.sectionHeaderHeight = 8;
        tableView.bottomLineLeftOffset = 0;
        [self.view addSubview:tableView];
        [tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(200, 0, 0, 0));
        }];
        tableView;
    });
    [self addTableViewGroup1];
//     [self addTableViewGroup2];
}
- (void)addTableViewGroup1
{
    @weakify(self)
    SettingGroup *group = [self.tableView addGroup];
    
    SettingItem *item1 = [SettingArrowItem itemWithIcon:@"icon_info" title:@"个人资料"];
    item1.operation = ^(){
        
        LTSUserInfoViewController *userInfo = [LTSUserInfoViewController new];
        userInfo.updateImageBlck = ^(NSString *imageStr){
            
            
            [self.headerImage sd_setImageWithURL:[NSURL URLWithString:[kLTSDBBaseUrl stringByAppendingString:imageStr]] placeholderImage:[UIImage imageNamed:@"icon_headerDefault"]];
            
        };

        userInfo.delegate = self;
        [self.navigationController pushViewController:userInfo animated:YES];
        
        
    };
    SettingItem *item2 = [SettingArrowItem itemWithIcon:@"updatePw" title:@"修改密码"];
    item2.operation = ^(){
        @strongify(self)
        LTSChangePassWordViewController *changePassWord = [LTSChangePassWordViewController new];
        [self.navigationController pushViewController:changePassWord animated:YES];

    };
    
    SettingItem *item3 = [SettingArrowItem itemWithIcon:@"icon_checkUpdate" title:@"检查更新"];
    item3.subtitleColor = HexColor(@"#676769");
     item3.subtitle = [NSString stringWithFormat:@"当前版本：%@",Current_Version];
    item3.operation = ^(){
        //加载图
        //升级版本
//        [self showHudInView:self.view hint:@""];
        [[LTSCheckUpdate shareUpdate] checkUpdateWithBlock:^(BOOL data,NSString *message) {

            [self hideHud];
            if (data) {
                @weakify(self);
                
                LTSWarnAlertView *alertView = [LTSWarnAlertView new];
                alertView.message = [NSString stringWithFormat:@"发现新版本%@",@""];
                alertView.delegate = self;
                [alertView showWithAnimation:YES];
                [[self rac_signalForSelector:@selector(alertView:clickButtonAtIndex:) fromProtocol:@protocol(LTSWarnAlertViewDelegate)] subscribeNext:^(RACTuple *tuple) {
                    @strongify(self)
                    if ([tuple.second isEqual:@1]) {
                        [[LTSCheckUpdate shareUpdate]  installAPP];
                    }
                }];
                
            }else{
                [ActivityHub ShowHub:@"当前已是最新版本"];
            }
        }];
        
    };
    
    
    
    SettingItem *item4 = [SettingArrowItem itemWithIcon:@"icon_declare" title:@"免责声明"];
    item4.operation = ^(){
         @strongify(self)
        LTSExonerateViewController *exonerateVC = [LTSExonerateViewController new];
        [self.navigationController pushViewController:exonerateVC animated:YES];
        
    };

    group.items = @[item1,item2,item4,item3];
    
  
}
- (void)addTableViewGroup2
{
    @weakify(self)
    SettingGroup *group = [self.tableView addGroup];
    
    SettingItem *item1 = [SettingArrowItem itemWithIcon:@"icon_cache" title:@"清除缓存"];
    item1.operation = ^(){
        
    };
    SettingItem *item2 = [SettingArrowItem itemWithIcon:@"icon_declare" title:@"免责声明"];
    item2.operation = ^(){
        
    };
    
    SettingItem *item3 = [SettingArrowItem itemWithIcon:@"icon_about" title:@"关于"];
    item3.operation = ^(){
        @strongify(self)
        LTSAboutViewController *aboutVC = [LTSAboutViewController new];
        [self.navigationController pushViewController:aboutVC animated:YES];
    };

    
    group.items = @[item1,item2,item3];
    
    
}

- (void)goLogin{
    LTSLoginViewController *loginVC = [LTSLoginViewController new];
    LTSBaseNavigationController *loginNavi = [[LTSBaseNavigationController alloc]initWithRootViewController:loginVC];

    
   
    [self presentViewController:loginNavi animated:YES completion:nil];
}
- (void)addEvents{
    @weakify(self)
//    UITapGestureRecognizer *tap = [UITapGestureRecognizer new];
//    [self.headerImage addGestureRecognizer:tap];
//    [[tap rac_gestureSignal] subscribeNext:^(id x) {
//        @strongify(self)
//        if ([LTSUserDefault boolForKey:KPath_UserLoginState] ) {
//            LTSUserInfoViewController *userInfo = [LTSUserInfoViewController new];
//            [self.navigationController pushViewController:userInfo animated:YES];
//        }else [self goLogin];
//        
//    }];
   
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
