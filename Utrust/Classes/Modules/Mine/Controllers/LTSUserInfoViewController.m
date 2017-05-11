//
//  LTSUserInfoViewController.m
//  CMSP
//
//  Created by 李棠松 on 2016/12/8.
//  Copyright © 2016年 李棠松. All rights reserved.
//

#import "LTSUserInfoViewController.h"
#import "LTSSetGesturePwdViewController.h"
#import "LTSLoginViewController.h"
#import "LTSChangeInformationViewController.h"
#import "LTSMineViewController.h"


@interface LTSUserInfoViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic,strong) UIImagePickerController *imagePickerController;

@property (nonatomic,strong)SettingView *tableView;

@property (nonatomic,strong)UIButton *outButton;

@property (nonatomic, strong) NSString *str;

@end

@implementation LTSUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的";
    // Do any additional setup after loading the view.
}
- (void)initUI{
    self.tableView = ({SettingView *tableView = [[SettingView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.backgroundColor = BGColorGray;
        tableView.sectionHeaderHeight = 8;
        tableView.bottomLineLeftOffset = 0;
        [self.view addSubview:tableView];
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        tableView;});
    
    [self addGroup1];
    [self addGroup2];
    [self addGroup3];
    [self addGroup4];
}
- (void)addGroup1{
    SettingGroup *group = [self.tableView addGroup];
    @weakify(self)

    _str = [kLTSDBBaseUrl stringByAppendingString:LTSUserDes.portraitUrl];
    SettingHeadImageItem *item1 = [SettingHeadImageItem itemWithTitle:@"头像" defaultImageName:_str];
    item1.rowHeight = 70;
    item1.operation =  ^(){
         @strongify(self)
        
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *alertAction1 = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            
            [self presentViewController:self.imagePickerController animated:YES completion:nil];
        }];
        UIAlertAction *alertAction2 = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            
            [self presentViewController:self.imagePickerController animated:YES completion:nil];
            
        }];
        
        UIAlertAction *alertAction3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertC addAction:alertAction1];
        [alertC addAction:alertAction2];
        [alertC addAction:alertAction3];
        [self presentViewController:alertC animated:YES completion:nil];
    };
    [[self rac_signalForSelector:@selector(imagePickerController:didFinishPickingMediaWithInfo:) fromProtocol:@protocol(UIImagePickerControllerDelegate)] subscribeNext:^(RACTuple *tuple) {
        @strongify(self)
        LTSUser *user = LTSUserDes;
        UIImagePickerController *picker = tuple.first;
        NSDictionary *info = tuple.second;
        UIImage *image = info[@"UIImagePickerControllerEditedImage"];
        //获得编辑后的图片
        UIImage *editedImage = (UIImage *)info[UIImagePickerControllerEditedImage];
        
        [picker dismissViewControllerAnimated:YES completion:^{
            
            
        }];
        
        UIImage *newImage = [UIImage imageWithImage:image toNewSize:CGSizeMake(300, 300)];
        NSData *data = UIImagePNGRepresentation(newImage);
        
        NSMutableDictionary *params =[@{} mutableCopy];
        params[@"portraitUrl"] = LTSUserDes.portraitUrl;
        
        
        //修改头像
        
        NSString *imageName = [NSString stringWithFormat:@"header.png"];
        [self showHudInView:self.view hint:@"正在上传"];
        [LTSDBManager UP_POST:kLTSDBChangePortrait params:@{@"employeeId":LTSUserDes.empId} andFileName:imageName progress:nil  type:nil dataName:@"file" mimeType:@"image/png" data:data block:^(id responseObject, NSError *error) {
            [self hideHud];
            if ([responseObject[@"success"] isEqual:@1]) {
                
                [self showSuccessInView:self.view hint:@"上传成功"];
                item1.urlString = [kLTSDBBaseUrl stringByAppendingString:responseObject[@"obj"]];
                user.portraitUrl  =  responseObject[@"obj"];
                [LTSUserDefault setObject:[user dataFromUser] forKey:KPath_UserDes];
                [LTSUserDefault setObject:[user dataFromUser]  forKey:KPath_UserDes];
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                [self leftBarButtonClick:editedImage];

                [self.tableView reloadData];
                
                
            }else{
                item1.urlString = responseObject[@"obj"];
                user.portraitUrl = responseObject[@"obj"];

                [self.tableView reloadData];

                [self leftBarButtonClick:editedImage];
                [self showErrorInView:self.view hint:responseObject[@"msg"]];
               
            }
            
            
        }];
        
        
        
    }];
    
    [[self rac_signalForSelector:@selector(imagePickerControllerDidCancel:) fromProtocol:@protocol(UIImagePickerControllerDelegate)] subscribeNext:^(RACTuple *tuple) {
        @strongify(self)
        
        
        UIImagePickerController *picker = tuple.first;
        [picker dismissViewControllerAnimated:YES completion:^{
        }];
    }];
    
    //证件类型
    
    group.items = @[item1];
    
    
}
- (void)addGroup2{
    SettingGroup *group = [self.tableView addGroup];
    
    SettingItem *item0 = [SettingArrowItem itemWithTitle:@"姓名"];
    item0.subtitle = @"未设置";
    item0.subtitleColor = HexColor(@"#676769");
    item0.operation = ^(){
        
    };

    
    SettingItem *item1 = [SettingArrowItem itemWithTitle:@"座机"];
    item1.subtitle = @"未设置";
    item1.subtitleColor = HexColor(@"#676769");
    item1.operation = ^(){
        
    };
    
    
  
    SettingItem *item2 = [SettingArrowItem itemWithTitle:@"手机号码"];
    item2.subtitle = @"未绑定";
    item2.subtitleColor = HexColor(@"#676769");
    item2.operation = ^(){
        
    };
    
//    SettingItem *item3 = [SettingArrowItem itemWithTitle:@"邮箱"];
//    item3.subtitle = @"未绑定";
//    item3.subtitleColor = HexColor(@"#676769");
//    item3.operation = ^(){
//        
//    };
    
    SettingItem *item4 = [SettingArrowItem itemWithTitle:@"QQ"];
    item4.subtitle = @"未绑定";
    item4.subtitleColor = HexColor(@"#676769");
    item4.operation = ^(){
        
    };
    if ( LTSUserDes.userName.length) {
        item0.subtitle =  LTSUserDes.userName;
    }
    if ( LTSUserDes.jobPhone.length) {
        item1.subtitle =  LTSUserDes.jobPhone;
    }
    if ( LTSUserDes.phone.length) {
        item2.subtitle =  LTSUserDes.phone;
    }

//    if ( LTSUserDes.jobEmail.length) {
//        item3.subtitle =  LTSUserDes.jobEmail;
//    }

    if ( LTSUserDes.qq.length) {
        item4.subtitle =  LTSUserDes.qq;
    }

    
    
    group.items = @[item0,item1,item2,item4];
    
    @weakify(self)
    for (SettingItem *setting in  group.items) {
        @weakify(setting)
        setting.operation = ^(id data){
            @strongify(self,setting)
            if (![setting.title isEqualToString:@"姓名"]) {
                LTSChangeInformationViewController *changeVC = [[LTSChangeInformationViewController alloc]initWithNavTitle:[NSString stringWithFormat:@"修改%@",setting.title] message:setting.subtitle title:setting.title];
                [self.navigationController pushViewController:changeVC animated:YES];
                changeVC.updateSuccessBlck = ^(NSString *message){
                    
                    setting.subtitle = message;
                    [self.tableView reloadData];
                };
                
            }
            
        };
        
    }

    
    
}
- (void)addGroup3{
    SettingGroup *group = [self.tableView addGroup];
    
    SettingItem *item1 = [SettingArrowItem itemWithTitle:@"地址"];
    item1.subtitleColor = HexColor(@"#676769");
    item1.subtitle = @"未设置";
    item1.operation = ^(){
        
    };
    
    
    
    SettingItem *item2 = [SettingArrowItem itemWithTitle:@"邮箱"];
    item2.subtitle = @"未绑定";
    item2.subtitleColor = HexColor(@"#676769");
    item2.operation = ^(){
        
    };
    
    if ( LTSUserDes.address.length) {
        item1.subtitle =  LTSUserDes.address;
    }
    if ( LTSUserDes.jobEmail.length) {
        item2.subtitle =  LTSUserDes.jobEmail;
    }

    
    
    group.items = @[item1,item2];
    
    @weakify(self)
    for (SettingItem *setting in  group.items) {
        @weakify(setting)
        setting.operation = ^(id data){
            @strongify(self,setting)
            if (![setting.subtitle isEqualToString:@"姓名"]) {
                LTSChangeInformationViewController *changeVC = [[LTSChangeInformationViewController alloc]initWithNavTitle:[NSString stringWithFormat:@"修改%@",setting.title] message:setting.subtitle title:setting.title];
                [self.navigationController pushViewController:changeVC animated:YES];
                changeVC.updateSuccessBlck = ^(NSString *message){
                    
                    setting.subtitle = message;
                    [self.tableView reloadData];
                };
                
            }
            
        };
        
    }
    
    
    
}
- (void)addGroup4{
    @weakify(self)
    SettingGroup *group = [self.tableView addGroup];
    
//    SettingItem *item1 = [SettingArrowItem itemWithTitle:@"账号绑定"];
//    item1.operation = ^(){
//       
//    };
    SettingItem *item2 = [SettingArrowItem itemWithTitle:@"手势密码"];
    item2.operation = ^(){
        @strongify(self)
        LTSSetGesturePwdViewController *setGseture = [LTSSetGesturePwdViewController new];
        [self.navigationController pushViewController:setGseture animated:YES];
    };
    
    //底部视图
    {
        UIView *footerView = [UIView new];
        footerView.frame = CGRectMake(0, 0, Screen_Width, 100);
        group.footerView = footerView;
        self.outButton = ({UIButton *button = [UIButton new];
            [footerView addSubview:button];
            [button setTitle:@"退出" forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:18];
            [button setTitleColor:BlueColor forState:UIControlStateNormal];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.left.mas_equalTo(0);
                make.top.mas_equalTo(25);
                make.height.mas_equalTo(44);
                
            }];
            button.backgroundColor =[UIColor whiteColor];
            button;
        });
    }
     
    group.items = @[item2];
    
}
- (void)addEvents{
    @weakify(self)
            [[self.outButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                @strongify(self)
                LTSLoginViewController *loginVC = [LTSLoginViewController new];
                [self presentViewController:loginVC animated:YES completion:nil];
            }];
}

-(UIImagePickerController *)imagePickerController
{
    if (!_imagePickerController) {
        _imagePickerController = [[UIImagePickerController alloc] init];
        _imagePickerController.delegate = self;
        _imagePickerController.allowsEditing = YES;
    }
    return _imagePickerController;
}

- (void)leftBarButtonClick: (UIImage *) image{
    [self.delegate returnName:UIImagePNGRepresentation(image)];
    [self.navigationController popViewControllerAnimated:YES];
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
