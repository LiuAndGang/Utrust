//
//  XMPPManager.h
//  Xmpp
//
//  Created by leetangsong_macbk on 16/4/7.
//  Copyright © 2016年 macbook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPPFramework.h"
#import "XMPPReconnect.h"


typedef NS_ENUM(NSInteger,ConnectServerPurposeType){
    ConnectServerPurposeLogin = 0,
    ConnectServerPurposeRegister
};

@protocol XMPPManagerDelegate;

@interface XMPPManager : NSObject<XMPPStreamDelegate,XMPPReconnectDelegate>

@property (nonatomic,assign) ConnectServerPurposeType connectServerPurposeType;

//通信管道，输入输出流
@property(nonatomic,strong)XMPPStream *xmppStream;
@property (nonatomic,strong)XMPPReconnect *xmppReconnect;

@property (nonatomic,weak)id<XMPPManagerDelegate> manageDelegate;
//单例方法
+(XMPPManager *)defaultManager;
//登录的方法
-(void)loginwithName:(NSString *)userName andPassword:(NSString *)password;
//注册
-(void)registerWithName:(NSString *)userName andPassword:(NSString *)password;

-(void)logout;

- (void)sendMessage:(NSString *) message toUser:(NSString *) user;

@end

@protocol XMPPManagerDelegate <NSObject>
- (void)managerLoginSuccess;
- (void)managerLoginFail;

@end
