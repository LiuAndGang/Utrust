//
//  LTSCheckUpdate.m
//  SAIFAMC
//
//  Created by 李棠松 on 16/11/11.
//  Copyright © 2016年 李棠松. All rights reserved.
//

#import "LTSCheckUpdate.h"

@implementation LTSCheckUpdate
+(instancetype)shareUpdate{
    static LTSCheckUpdate *update = nil;
  
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        update = [LTSCheckUpdate new];
        
    });
    return update;
}
//检查更新
-(void)checkUpdateWithBlock:(LTSCheckUpdateBlock)block{
    
    
    [LTSDBManager POST:kLTSDBGetAppEdition params:nil block:^(id responseObject, NSError *error) {
        if ([responseObject[@"success"] isEqual:@1]) {
            
            self.versionName = responseObject[@"attributes"][@"versionName"];
            BOOL update = ![_versionName isEqualToString:Current_Version];
//            self.fileUrl = responseObject[@"attributes"][@"url"];
                if (block) {
                    block(update,responseObject[@"attributes"][@"context"]);
                }
            
        }
    }];
    
    

}

//- (void)setFileUrl:(NSString *)fileUrl{
//    
////    NSString *str = [kLTSDBBaseUrl stringByAppendingPathComponent:fileUrl];
//    
//    _fileUrl = [NSString stringWithFormat:@"itms-services://?action=download-manifest&url=https://app.utrustfrg.com:10443/ca/appInfo.plist"];
//    
//}
//-(void)setFileUrl:(NSString *)fileUrl {
//    
//    _fileUrl =  @"itms-services://?action=download-manifest&url=https://app.utrustfrg.com:10443/ca/appInfo.plist";
//}
-(NSString *)fileUrl {
    if (!_fileUrl) {
        _fileUrl = @"itms-services://?action=download-manifest&url=https://app.utrustfrg.com:10443/ca/appInfo.plist";
    }
    return _fileUrl;
}
- (void)installAPP{
    
     [[UIApplication sharedApplication]openURL:[NSURL URLWithString:self.fileUrl]];
}

@end
