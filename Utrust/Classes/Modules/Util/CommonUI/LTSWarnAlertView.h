//
//  LTSWarnAlertView.h
//  SAIFAMC
//
//  Created by 李棠松 on 16/8/26.
//  Copyright © 2016年 leetangsong. All rights reserved.
//

#import "LTSBaseAlertView.h"
@class LTSWarnAlertView;
@protocol LTSWarnAlertViewDelegate <NSObject>

- (void)alertView:(LTSWarnAlertView *)alertView clickButtonAtIndex:(NSInteger)buttonIndex;

@end

@interface LTSWarnAlertView : LTSBaseAlertView


@property (nonatomic,strong)NSString *message;

@property (nonatomic,weak)id<LTSWarnAlertViewDelegate> delegate;

@end
