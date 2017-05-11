//
//  URLConst.h
//  SAIFAMC
//
//  Created by 李棠松 on 16/8/23.
//  Copyright © 2016年 leetangsong. All rights reserved.
//

#ifndef URLConst_h
#define URLConst_h

///基本地址
#pragma mark ----  检测更新 ----
//文件最新版本获取接口  apkoripa=1&packAge=com.ucg.app.saifu
#define kLTSDBGetAppEdition    @"appVersionController.do?getIpAndPort&appType=1"


//#define  kLTSDBBaseUrl  @"http://192.168.55.36:8080/GDFRGC_OSS/"
//#define  kLTSDBBaseUrl  @"http://192.168.55.34:8080/GDFRGC_OSS/"
//#define  kLTSDBBaseUrl  @"http://192.168.13.77:8080/GDFRGC_OSS/"
//#define  kLTSDBBaseUrl   @"http://tft456.imwork.net:14650/GDFRGC_OSS/"
#define  kLTSDBBaseUrl   @"http://183.62.44.126:8801/"
#define OpenFireUrl @"120.24.175.12"
///登录
#define   kLTSDBLogin  @"appInterfaceController.do?getUserInfo"
//../upload/edition/000016_1479343945953.plist


//修改密码
#define    kLTSDBChangePassword @"appInterfaceController.do?changePassword"


//修改个人信息
#define    kLTSDBChangeUserInfo @"appInterfaceController.do?userInfoSimpleSave"
//头像上传
#define    kLTSDBChangePortrait  @"appInterfaceController.do?uploadPortraitFile"

#endif /* URLConst_h */
