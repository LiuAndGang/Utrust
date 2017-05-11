//
//  LTSCheckUpdate.h
//  SAIFAMC
//
//  Created by 李棠松 on 16/11/11.
//  Copyright © 2016年 李棠松. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^LTSCheckUpdateBlock)(BOOL data,NSString *message);
@interface LTSCheckUpdate : NSObject
@property (nonatomic,strong)NSString *baseUrl;

@property (nonatomic,strong)NSString *versionName;

@property (nonatomic,strong)NSString *fileUrl;
+(instancetype)shareUpdate;
-(void)checkUpdateWithBlock:(LTSCheckUpdateBlock) block;
- (void)installAPP;
@end
