//
//  LTSBaseNavigationController.m
//  SAIFAMC
//
//  Created by 李棠松 on 16/8/14.
//  Copyright © 2016年 leetangsong. All rights reserved.
//

#import "LTSBaseNavigationController.h"
#import "LTSLoginViewController.h"
#import "LTSMineViewController.h"
#import "UIBarButtonItem+Style.h"
#import "LTSProjectViewController.h"
#import "LTSMessageViewController.h"
#import "LTSMessageOtherViewController.h"

#import "LTSBaseWebViewController.h"
@interface LTSBaseNavigationController ()<UIViewControllerTransitioningDelegate,UINavigationControllerDelegate>

@end

@implementation LTSBaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
//  
    
    
    self.delegate = self;
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont systemFontOfSize:18]}];
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        self.interactivePopGestureRecognizer.enabled = YES;
        self.interactivePopGestureRecognizer.delegate = nil;
    }

    
    
    
    [ self.navigationBar setBackgroundImage:[UIImage imageWithColor:BlueColor]  forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    
    [self.navigationBar setTintColor:[UIColor whiteColor]];
    // Do any additional setup after loading the view.
}

- (void)removeAllChildVC
{
    
    NSMutableArray *navArray = [NSMutableArray arrayWithArray:self.viewControllers];
    
    for (NSUInteger i = navArray.count - 1 ; i > 0; i-- ) {
        [navArray removeObjectAtIndex:i];
    }
    
    self.viewControllers = navArray;
    
}

- (void)pushViewController:(LTSBaseViewController *)viewController animated:(BOOL)animated
{
    
    if (self.viewControllers.count > 0) {
        
        //        if ([viewController isMemberOfClass:[JSBaseWebViewController class]]) {
        //            self.navigationItem.leftItemsSupplementBackButton = YES;
        //        }
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonWithType:BarButtonBack];
        
        viewController.hidesBottomBarWhenPushed = YES;
        
    }
  
    viewController.navigationItem.leftBarButtonItem.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
     if ([viewController isMemberOfClass:
             [LTSBaseWebViewController class]]) {
            [viewController.navigationController popViewControllerAnimated:YES];
        }
        
        
        
        else  [viewController leftBarButtonClick];
        return [RACSignal empty];
    }];
    
    
    
    [super pushViewController:viewController animated:animated];
}


- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
    if ( [viewController isKindOfClass:[LTSMineViewController class]] || [viewController isKindOfClass:[LTSLoginViewController class]] || [viewController isKindOfClass:[LTSProjectViewController class]] || [viewController isKindOfClass:[LTSMessageViewController class]]|| [viewController isKindOfClass:[LTSMessageOtherViewController class]]) {
        
        [navigationController setNavigationBarHidden:YES animated:animated];
        
    } else if ( [navigationController isNavigationBarHidden] ) {
        [navigationController setNavigationBarHidden:NO animated:animated];
    }
   
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
