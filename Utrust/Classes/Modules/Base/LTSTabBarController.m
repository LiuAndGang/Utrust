//
//  LTSTabbarViewController.m
//  SAIFAMC
//
//  Created by 李棠松 on 16/8/15.
//  Copyright © 2016年 leetangsong. All rights reserved.
//

#import "LTSTabBarController.h"

#import "LTSBaseNavigationController.h"
#import "LTSLoginViewController.h"


#define kClassKey   @"rootVCClassString"
#define kTitleKey   @"title"
#define kImgKey     @"imageName"
#define kSelImgKey  @"selectedImageName"

@interface LTSTabBarController ()

@end

@implementation LTSTabBarController


- (void)dealloc{
    
    [LTSUserDefault setBool:0 forKey:KPath_UserLoginState];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpTabBarViewController];
    
    
    
    if (![LTSUserDefault objectForKey:KPath_CheckVersion]) {
//        [JSDBManager checkVersionWithBlock:^(NSDictionary *dic) {
//            if (![dic[@"versionShort"] isEqual:Current_Version] ) {
//                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"检测到有新版本" message:dic[@"changelog"] preferredStyle:UIAlertControllerStyleAlert];
//                UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"不再提醒" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//                    [JSUserDefault setObject:@"1" forKey:KPath_CheckVersion];
//                }];
//                UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"立即更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:dic[@"update_url"]]];
//                }];
//                [alertController addAction:action1];
//                [alertController addAction:action2];
//                [self presentViewController:alertController animated:YES completion:nil];
//                
//            }
//            
//        }];
        
    }
    
    [LTSUserDefault setBool:0 forKey:KPath_UserIsFirstLogin];
}


- (void)setUpTabBarViewController
{
  
    
    NSArray *childItemsArray = @[
                                 @{kClassKey  : @"LTSMessageViewController",
                                   kTitleKey  : @"消息",
                                   kImgKey    : @"icon_tab_message",
                                   kSelImgKey : @"icon_tab_message_selected"},
                                 
                                 @{kClassKey  : @"LTSProjectViewController",
                                   kTitleKey  : @"工作",
                                   kImgKey    : @"icon_tab_work",
                                   kSelImgKey : @"icon_tab_work_selected"},
                                 
                                 @{kClassKey  : @"LTSMineViewController",
                                   kTitleKey  : @"我的",
                                   kImgKey    : @"icon_tab_mine",
                                   kSelImgKey : @"icon_tab_mine_selected"}
                                 ];
    
    [childItemsArray enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL *stop) {
        UIViewController *vc = [NSClassFromString(dict[kClassKey]) new];
        vc.title = dict[kTitleKey];
        self.tabBar.tintColor = BlueColor;
        LTSBaseNavigationController *nav = [[LTSBaseNavigationController alloc] initWithRootViewController:vc];
        
        UITabBarItem *item = nav.tabBarItem;
        item.title = dict[kTitleKey];
        item.image = [UIImage imageNamed:dict[kImgKey]];
        item.selectedImage = [[UIImage imageNamed:dict[kSelImgKey]] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [item setTitlePositionAdjustment:UIOffsetMake(0, -4)];
        [item setTitleTextAttributes:@{NSForegroundColorAttributeName : BlueColor} forState:UIControlStateSelected];
        [self addChildViewController:nav];
    }];
    
    self.tabBar.backgroundColor = [UIColor whiteColor];
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
