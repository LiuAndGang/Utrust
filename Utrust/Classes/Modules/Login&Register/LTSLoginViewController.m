//
//  LTSLoginViewController.m
//  CMSP
//
//  Created by 李棠松 on 2016/12/1.
//  Copyright © 2016年 李棠松. All rights reserved.
//

#import "LTSLoginViewController.h"
#import "LTSCustomTextField.h"
#import "LTSTabBarController.h"
@interface LTSLoginViewController ()

@property (nonatomic,strong)UIScrollView *scrollView;

@property (nonatomic,strong)UIView *topView;

@property (nonatomic,strong)LTSCustomTextField *user_tf;
@property (nonatomic,strong)LTSCustomTextField *password_tf;

@property (nonatomic,strong)UIButton *autoLoginBtn;



@property (nonatomic,strong)UIButton *loginBtn;



@property (nonatomic,strong)UIImageView *statusImageView;

@end

@implementation LTSLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.view.backgroundColor = OrangeColor;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [LTSUserDefault setBool:0 forKey:KPath_AutoLogin];
    [LTSUserDefault setBool:0 forKey:KPath_UserLoginState];
    [self addTouchClick];
}

- (void)initUI{
    
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:self.scrollView];
    self.scrollView.backgroundColor = BlueColor;
    self.scrollView.contentSize = CGSizeMake(Screen_Width, 667);
    self.scrollView.bounces = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    
//    UIView *topView = [UIView new];
//    [self.scrollView addSubview:topView];
//    topView.backgroundColor = BlueColor;
//    topView.frame = CGRectMake(0, 0, Screen_Width, 230);
//    self.topView = topView;
    
    
    
    UIImageView *topImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_login_top1"]];
    [self.scrollView addSubview:topImageView];
    [topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(-50);
        make.width.mas_equalTo(Screen_Width);
        make.height.mas_equalTo((990/1242.0)*Screen_Width);
//        make.centerY.mas_equalTo(topView.mas_centerY);
//        make.centerX.mas_equalTo(self.scrollView.mas_centerX).with.offset(20);
//        make.size.mas_equalTo(CGSizeMake(215, 70));
    }];
    
   
    
   
    
    
    
    
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:view];
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topImageView.mas_bottom).with.offset(0);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(Screen_Width);
        make.height.mas_equalTo(Screen_Height-230);
        
    }];
    
    self.user_tf = ({LTSCustomTextField *textField = [LTSCustomTextField textFieldWithleftImageIcon:@"icon_userLogin"];
        textField.borderType = LTSCustomTextFieldBorderTypeBottom;
        [textField setCustomPlaceholder:@"用户名"];
        [view addSubview:textField];
        [textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(15);
            make.left.mas_equalTo(25);
            make.right.mas_equalTo(-25);
            make.height.mas_equalTo(44);
        }];
        textField;
    });
    
    self.password_tf= ({LTSCustomTextField *textField = [LTSCustomTextField textFieldWithleftImageIcon:@"icon_userPassword"];
        [textField setCustomPlaceholder:@"输入密码"];
        textField.borderType = LTSCustomTextFieldBorderTypeBottom;
        textField.secureTextEntry = YES;
        [view addSubview:textField];
        [textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.user_tf.mas_bottom).with.offset(10);
            make.left.mas_equalTo(25);
            make.right.mas_equalTo(-25);
            make.height.mas_equalTo(44);
        }];
        
        UIButton *button = [UIButton new];
        button.frame = CGRectMake(0, 0, 50, 20);
        [button setTitle:@"忘记密码" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        [button setTitleColor:HexColor(@"#00b0ec") forState:UIControlStateNormal];
        textField.rightViewMode = UITextFieldViewModeAlways;
        textField.rightView = button;
        
        
        textField;
    });
    
    self.autoLoginBtn = ({UIButton  *button = [UIButton new];
        [button setImage:[UIImage imageNamed:@"icon_memberPwd_unselected"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"icon_memberPwd_selected"] forState:UIControlStateSelected];
        [view addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.password_tf.mas_left);
            make.top.mas_equalTo(self.password_tf.mas_bottom).with.offset(30);
        }];
        
        UILabel *label = [UILabel new];
        label.text = @"自动登录";
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = LightDarkText;
        [view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(button.mas_right).with.offset(5);
            make.centerY.mas_equalTo(button.mas_centerY);
        }];
        
        
        button;});
    
    
    
    
    self.loginBtn = ({ UIButton *button = [[UIButton alloc] init];
        
        [button GrayRoundButtonStyle];
        [button setTitle:@"登录" forState:UIControlStateNormal];
        
        [view addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view).with.offset(25);
            make.right.equalTo(view.mas_right).with.offset(-25);
            make.top.equalTo(self.autoLoginBtn.mas_bottom).with.offset(15);
            make.height.mas_equalTo(44);
        }];
        
        button;
    });
    
    
    
    
   
}


- (void)addEvents{
    @weakify(self)
    
    RAC(self.loginBtn,enabled) = [RACSignal combineLatest:@[self.user_tf.rac_textSignal,self.password_tf.rac_textSignal] reduce:^id(NSString *userNameText,NSString *pwdText){
        return @(userNameText.length > 0 && pwdText.length > 0);
    }];
    
    [RACObserve(self.loginBtn, enabled) subscribeNext:^(NSNumber *x) {
        @strongify(self)
        [UIView animateWithDuration:0.3 animations:^{
            x.boolValue ? [self.loginBtn OrangeRoundButtonStyle] : [self.loginBtn GrayRoundButtonStyle];
        }];
    }];
    
    [[self.loginBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
       @strongify(self)
        //登录
        [self showHudInView:self.view hint:@"正在登录"];
        [LTSDBManager POST:kLTSDBLogin params:@{@"userName":self.user_tf.text,@"password":self.password_tf.text} block:^(id responseObject, NSError *error) {
            NSLog(@"登录成功后的信息 === %@",responseObject);
            if (![responseObject isKindOfClass:[NSDictionary class]]) {
                [self showErrorInView:self.view hint:@"登录失败"];
                return ;
            }
            if ([responseObject[@"success"] isEqual:@1]) {
                [self showSuccessInView:self.view hint:@"登录成功"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    [self hideHud];
                    LTSUser *user = [LTSUser mj_objectWithKeyValues:responseObject[@"obj"]];
                    
                    user.token = responseObject[@"token"];
                    if (responseObject) {
                        
                    }
                    user.openfireUserId = responseObject[@"attributes"][@"openfire"][@"openfireUserId"];
                    user.openfireUserName = responseObject[@"attributes"][@"openfire"][@"openfireUserName"];
                    user.userID = responseObject[@"attributes"][@"openfire"][@"userId"];
                    user.empName = responseObject[@"obj"][@"empName"];

                    [LTSUserDefault setObject:[user dataFromUser] forKey:KPath_UserDes];
                    [LTSUserDefault setBool:YES forKey:KPath_UserLoginState];
                    [LTSUserDefault setBool:self.autoLoginBtn.selected forKey:KPath_AutoLogin];
                    LTSTabBarController *tabbar = [LTSTabBarController new];
                    LTSAppDelegated.window.rootViewController = tabbar;
                    
                     [[XMPPManager defaultManager] loginwithName:LTSUserDes.openfireUserId andPassword:@"123456"];
                    
                    if ([LTSUserDefault valueForKey:Device_Token]) {
                       
                        
                        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@:9090/",OpenFireUrl]]];
                        NSURLSessionDataTask *task = [manager GET:@"plugins/push/subm" parameters:@{@"companyid":LTSUserDes.empId,@"stype":@"modifyToken",@"username":LTSUserDes.openfireUserId,@"devicetoken":[LTSUserDefault objectForKey:Device_Token]} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                            NSLog(@"绑定成功");
                            
                        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                            
                        }];
                        NSLog(@"%@",task.currentRequest.URL);
                    }
                    
                });
                
            }else{
                [self showErrorInView:self.view hint:responseObject[@"msg"]];
            }
        }];

        
    }];
    
    //忘记密码
    
    
    
    
    
    //自动登录
    [[self.autoLoginBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
       @strongify(self)
        self.autoLoginBtn.selected = !self.autoLoginBtn.selected;
//        [LTSUserDefault setBool:self.autoLoginBtn.selected forKey:KPath_AutoLogin];
    }];
    
  


}

//添加触摸收回键盘事件
-(void)addTouchClick {
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self.user_tf resignFirstResponder];
    [self.password_tf resignFirstResponder];
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
