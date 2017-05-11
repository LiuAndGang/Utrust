//
//  LTSUserInfoViewController.h
//  CMSP
//
//  Created by 李棠松 on 2016/12/8.
//  Copyright © 2016年 李棠松. All rights reserved.
//

#import "LTSBaseViewController.h"
@protocol OtherDelegate
- (void)returnName:(NSData *)image;
@end

typedef void(^UpdateImageBlock)(NSString *);

@interface LTSUserInfoViewController : LTSBaseViewController

@property (nonatomic, retain) id <OtherDelegate> delegate;
@property (nonatomic, copy) UpdateImageBlock updateImageBlck;
@end
