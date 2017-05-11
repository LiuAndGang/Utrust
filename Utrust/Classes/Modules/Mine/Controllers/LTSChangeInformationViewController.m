//
//  LTSChangeInformationViewController.m
//  SAIFAMC
//
//  Created by leetangsong_macbk on 16/4/15.
//  Copyright © 2016年 macbook. All rights reserved.
//

#import "LTSChangeInformationViewController.h"
#import "LeftLabelTextField.h"
@interface LTSChangeInformationViewController ()<UITextFieldDelegate>

@property (strong, nonatomic) UIBarButtonItem *commit;
@property (nonatomic, copy)  NSString *originalMessage;
@property (nonatomic,copy)NSString *leftTitle;

@property (nonatomic,copy)NSString *nav_title;
@end

@implementation LTSChangeInformationViewController

- (instancetype)initWithNavTitle:(NSString *)nav_title message:(NSString *)message title:(NSString *)title{
    if (self == [super init]) {
       
        if (!([message isEqualToString:@"未绑定"]||[message isEqualToString:@"未设置"])) {
            self.originalMessage = message;
        }
        self.leftTitle = title;
        
        self.nav_title = nav_title;
        
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.nav_title;
    
    [self addEvents];
}
- (void)initUI
{
    CGFloat padding = 20;
    CGFloat textFieldH = 40;
    CGFloat textFieldPadding = 10;
    
    self.tf_title = [[LeftLabelTextField alloc] initWithTitle:self.leftTitle placeHolder:[NSString stringWithFormat:@"请输入%@",self.leftTitle]];
    self.tf_title.text = self.originalMessage;
    self.tf_title.delegate = self;
    
    
    [self.view addSubview:self.tf_title];
    [self.tf_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(20);
        make.left.equalTo(self.view).with.offset(padding);
        make.right.equalTo(self.view.mas_right).with.offset(-padding);
        make.height.mas_equalTo(textFieldH);
    }];
    

}



- (void)initNav{
    
    self.commit = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(click)];
    _commit.enabled = NO;
    
    [[self.tf_title rac_signalForControlEvents:UIControlEventEditingChanged]subscribeNext:^(id x) {
        if (!self.tf_title.text.length) {
            _commit.enabled = NO;
        }
        else _commit.enabled = YES;
    }];
    [_commit setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = _commit;
    

}
- (void)click{
    [self.view endEditing:YES];
    self.commit.enabled = NO;
    if ([self.tf_title.text isEqualToString:self.originalMessage]) {
        return;
    }
    NSMutableDictionary *params = [@{@"id":LTSUserDes.empId} mutableCopy];
    
    
    
    
    
    if ([self.leftTitle isEqualToString:@"姓名"]) {
       
         params[@"userName"] = self.tf_title.text;
        if (!LTSUserDes.userName.length) {
             params[@"nickName"] = @" ";
        }else  params[@"nickName"] = LTSUserDes.userName;
        
       
        
    }
    
    if ([self.leftTitle isEqualToString:@"座机"]) {
        self.tf_title.keyboardType = UIKeyboardTypeNumberPad;
        params[@"jobPhone"] = self.tf_title.text;
    }
    
    if ([self.leftTitle isEqualToString:@"手机号码"]) {
       self.tf_title.keyboardType = UIKeyboardTypeNumberPad;
        if (![TextChecker isTelephone:self.tf_title.text]) {
            [ActivityHub ShowHub:@"请输入正确的手机号码"];
            return;
        }
        params[@"phone"] = self.tf_title.text;
        
    }
    if ([self.leftTitle isEqualToString:@"邮箱"]) {
        if (![TextChecker isEmailAddress:self.tf_title.text]) {
            [ActivityHub ShowHub:@"请输入正确的邮箱"];
            return;
        }
        params[@"jobEmail"] = self.tf_title.text;
    }

    if ([self.leftTitle isEqualToString:@"地址"]) {
        params[@"address"] = self.tf_title.text;
    }
    if ([self.leftTitle isEqualToString:@"QQ"]) {
        params[@"qq"] = self.tf_title.text;
    }
    LTSUser *user = LTSUserDes;
    [self showHudInView:self.view hint:@"正在保存"];

    [LTSDBManager POST:kLTSDBChangeUserInfo params:params block:^(id responseObject, NSError *error) {
        [self hideHud];
        if ([responseObject[@"success"] isEqual:@1]) {
            [self showSuccessInView:self.view hint:@"保存成功"];
            if ([self.leftTitle isEqualToString:@"姓名"]) {
                
                user.userName = self.tf_title.text;
                
            }
            
            if ([self.leftTitle isEqualToString:@"座机"]) {
                user.jobPhone = self.tf_title.text;
              
            }
            if ([self.leftTitle isEqualToString:@"手机号码"]) {
                
                user.phone = self.tf_title.text;
                
            }
            if ([self.leftTitle isEqualToString:@"邮箱"]) {
               
                user.jobEmail = self.tf_title.text;
            }
            
            if ([self.leftTitle isEqualToString:@"地址"]) {
               user.address = self.tf_title.text;
            }
            if ([self.leftTitle isEqualToString:@"QQ"]) {
                user.qq = self.tf_title.text;
            }
            
            [LTSUserDefault setObject:[user dataFromUser]  forKey:KPath_UserDes];
            
            [LTSNotification postNotificationName:KNotification_UserInfoUpdate object:nil];
            [self.navigationController popViewControllerAnimated:YES];
            self.updateSuccessBlck(self.tf_title.text);
        }else{
            [self showErrorInView:self.view hint:responseObject[@"msg"]];
        }
        
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
