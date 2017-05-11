//
//  LTSAppDelegate.m
//  CMSP
//
//  Created by 李棠松 on 2016/11/28.
//  Copyright © 2016年 李棠松. All rights reserved.
//

#import "LTSAppDelegate.h"
#import "LTSTabBarController.h"
#import "LTSLoginViewController.h"
#import "LTSBaseNavigationController.h"
#import "JinnLockViewController.h"
#import <UserNotifications/UserNotifications.h>
#import "UMessage.h"
@interface LTSAppDelegate ()<JinnLockViewControllerDelegate,UNUserNotificationCenterDelegate>
@property (nonatomic, strong) UINavigationController *navigationController;
@end

@implementation LTSAppDelegate


- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
    return UIInterfaceOrientationMaskPortrait;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
     [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    

    //是否自动登录
    BOOL isAutoLogin = [LTSUserDefault boolForKey:KPath_AutoLogin];
    
    
    
    if (isAutoLogin) {
        if (LTSUserDes.userID.length) {
            [[XMPPManager defaultManager] loginwithName:LTSUserDes.openfireUserId andPassword:@"123456"];
        }
        LTSTabBarController *tabbar = [LTSTabBarController new];
        
        self.window.rootViewController = tabbar;
    }else{
        
        LTSLoginViewController *loginVC = [LTSLoginViewController new];
        LTSBaseNavigationController *loginNavi = [[LTSBaseNavigationController alloc]initWithRootViewController:loginVC];
        self.window.rootViewController = loginNavi;
    }
    
    
    if (isAutoLogin && [JinnLockTool isGestureUnlockEnabled]) {
        [self verify];
    }
    
    [self.window makeKeyAndVisible];
    
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    
    manager.shouldResignOnTouchOutside = YES;
    manager.keyboardDistanceFromTextField = 0;
    
    manager.enableAutoToolbar = YES;
    
    
    //友盟推送
    [UMessage startWithAppkey:@"58661a41f29d9809ca000efc" launchOptions:launchOptions];
    //注册通知
    [UMessage registerForRemoteNotifications];
    
    //iOS10必须加下面这段代码。
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate=self;
    UNAuthorizationOptions types10=UNAuthorizationOptionBadge|UNAuthorizationOptionAlert|UNAuthorizationOptionSound;
    [center requestAuthorizationWithOptions:types10 completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            //点击允许
            
        } else {
            //点击不允许
            
        }
    }];
    
    
    //如果你期望使用交互式(只有iOS 8.0及以上有)的通知，请参考下面注释部分的初始化代码
    UIMutableUserNotificationAction *action1 = [[UIMutableUserNotificationAction alloc] init];
    action1.identifier = @"action1_identifier";
    action1.title=@"打开应用";
    action1.activationMode = UIUserNotificationActivationModeForeground;//当点击的时候启动程序
    
    UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];  //第二按钮
    action2.identifier = @"action2_identifier";
    action2.title=@"忽略";
    action2.activationMode = UIUserNotificationActivationModeBackground;//当点击的时候不启动程序，在后台处理
    action2.authenticationRequired = YES;//需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
    action2.destructive = YES;
    UIMutableUserNotificationCategory *actionCategory1 = [[UIMutableUserNotificationCategory alloc] init];
    actionCategory1.identifier = @"category1";//这组动作的唯一标示
    [actionCategory1 setActions:@[action1,action2] forContext:(UIUserNotificationActionContextDefault)];
    NSSet *categories = [NSSet setWithObjects:actionCategory1, nil];
    
    //如果要在iOS10显示交互式的通知，必须注意实现以下代码
    if ([[[UIDevice currentDevice] systemVersion]intValue]>=10) {
        UNNotificationAction *action1_ios10 = [UNNotificationAction actionWithIdentifier:@"action1_ios10_identifier" title:@"打开应用" options:UNNotificationActionOptionForeground];
        UNNotificationAction *action2_ios10 = [UNNotificationAction actionWithIdentifier:@"action2_ios10_identifier" title:@"忽略" options:UNNotificationActionOptionForeground];
        
        //UNNotificationCategoryOptionNone
        //UNNotificationCategoryOptionCustomDismissAction  清除通知被触发会走通知的代理方法
        //UNNotificationCategoryOptionAllowInCarPlay       适用于行车模式
        UNNotificationCategory *category1_ios10 = [UNNotificationCategory categoryWithIdentifier:@"category101" actions:@[action1_ios10,action2_ios10]   intentIdentifiers:@[] options:UNNotificationCategoryOptionCustomDismissAction];
        NSSet *categories_ios10 = [NSSet setWithObjects:category1_ios10, nil];
        [center setNotificationCategories:categories_ios10];
    }else
    {
        [UMessage registerForRemoteNotifications:categories];
    }
    
    //如果对角标，文字和声音的取舍，请用下面的方法
    //UIRemoteNotificationType types7 = UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound;
    //UIUserNotificationType types8 = UIUserNotificationTypeAlert|UIUserNotificationTypeSound|UIUserNotificationTypeBadge;
    //[UMessage registerForRemoteNotifications:categories withTypesForIos7:types7 withTypesForIos8:types8];
    
    //打开日志方便调试
    [UMessage setLogEnabled:YES];
    
    
    
    
    return YES;
}
- (void)verify{
   
        JinnLockViewController *lockViewController = [[JinnLockViewController alloc] initWithDelegate:self
                                                                                                 type:JinnLockTypeVerify
                                                                                           appearMode:JinnLockAppearModePresent];
        self.window.rootViewController = lockViewController;
    
    
}
- (void)passcodeDidVerify:(NSString *)passcode{
    LTSTabBarController *tabbar = [LTSTabBarController new];
    
    self.window.rootViewController = tabbar;
}

#pragma mark -------------------- Push Noti ---------------------

- (void)application:(UIApplication *)applicatdidReceiveRemoteNotificationion didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    //
    NSString *devToken = [[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]
                           stringByReplacingOccurrencesOfString: @">" withString: @""]
                          stringByReplacingOccurrencesOfString: @" " withString: @""]
    ;
    [[NSUserDefaults standardUserDefaults] setObject:devToken forKey:Device_Token];
    
    //绑定Device_Token
    if ([LTSUserDefault valueForKey:KPath_UserDes]) {
       
        
        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@:9090/",OpenFireUrl]]];
        [manager GET:@"plugins/push/subm" parameters:@{@"companyid":LTSUserDes.empId,@"stype":@"modifyToken",@"username":LTSUserDes.openfireUserId,@"devicetoken":[LTSUserDefault objectForKey:Device_Token]} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"%@",responseObject);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
    }
    else {
        [[NSNotificationCenter defaultCenter] postNotificationName:KNotification_CanBindDeviceToken object:nil];
    }

    //        NSLog(@"%@",task.currentRequest.URL);
    
    
    
    //    [UMessage registerDeviceToken:deviceToken];
    NSLog(@"deviceToken - %@",devToken );
    
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"Register Remote Notifications error:{%@}",error);
    //    NSLog(@"Register Remote Notifications error:{%@}",error.localizedDescription);
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
