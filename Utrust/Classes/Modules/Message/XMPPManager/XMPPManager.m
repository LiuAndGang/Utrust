//
//  XMPPManager.m
//  Xmpp
//
//  Created by leetangsong_macbk on 16/4/7.
//  Copyright © 2016年 macbook. All rights reserved.
//
@import UIKit;
#import "XMPPManager.h"

//#import "UILocalNotification.h"
@interface XMPPManager(){
   
}
@property (nonatomic,copy)NSString *password;

@end
@implementation XMPPManager

+ (XMPPManager *)defaultManager{
    static XMPPManager *_share=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _share=[[XMPPManager alloc] init];
        _share.xmppStream.enableBackgroundingOnSocket = YES;
    });
    return _share;
}

-(instancetype)init{
    if ([super init]){
        //1.初始化xmppStream，登录和注册的时候都会用到它
        self.xmppStream = [[XMPPStream alloc]init];
        //设置服务器地址,这里用的是本地地址（可换成公司具体地址）
        self.xmppStream.hostName = OpenFireUrl;
        //    设置端口号
        self.xmppStream.hostPort = 5222;
        //    设置代理
        
        [self.xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];

        //断线重连
        self.xmppReconnect = [[XMPPReconnect alloc] init];
        
        [self.xmppReconnect activate:self.xmppStream];
        
        [self.xmppReconnect addDelegate:self delegateQueue:dispatch_get_main_queue()];
        
    }
    return self;
}
    
-(void)logout{//表示离线不可用
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
    //向服务器发送离线消息
    [self.xmppStream sendElement:presence];
    //断开链接
    [self.xmppStream disconnect];
}
    
-(void)loginwithName:(NSString *)userName andPassword:(NSString *)password{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    //标记连接服务器的目的
    self.connectServerPurposeType = ConnectServerPurposeLogin;
    //这里记录用户输入的密码，在登录（注册）的方法里面使用
    self.password = @"123456";
    
//    NSString *sysUser = [NSString stringWithFormat:@"%@%@",[LTSUserDefault objectForKey:KPath_sysToken],userName];
    
    //  创建xmppjid（用户0,  @param NSString 用户名，域名，登录服务器的方式（苹果，安卓等）
    XMPPJID *jid = [XMPPJID jidWithUser:userName domain:@"zhuoxitec" resource:[NSString stringWithFormat:@"%f",[NSDate date].timeIntervalSinceNow]];

    self.xmppStream.myJID = jid;
    //连接到服务器
    [self connectToServer];
}

-(void)registerWithName:(NSString *)userName andPassword:(NSString *)password{
    self.password = password;
    //0.标记连接服务器的目的
    self.connectServerPurposeType = ConnectServerPurposeRegister;
    //1. 创建一个jid
    XMPPJID *jid = [XMPPJID jidWithUser:userName domain:@"zhuoxitec" resource:[NSString stringWithFormat:@"%f",[NSDate date].timeIntervalSinceNow]];
    //2.将jid绑定到xmppStream
    self.xmppStream.myJID = jid;
    //3.连接到服务器
    [self connectToServer];
}




-(void)connectToServer{
     //如果已经存在一个连接，需要将当前的连接断开，然后再开始新的连接
     if ([self.xmppStream isConnected]) {
         [self logout];
     }
     NSError *error = nil;
     [self.xmppStream connectWithTimeout:10.0f error:&error];
     if (error) {
         NSLog(@"error = %@",error);
     }
}

#pragma mark -- XMPPStreamDelegate --
//连接服务器失败的方法
-(void)xmppStreamConnectDidTimeout:(XMPPStream *)sender{
    NSLog(@"连接服务器失败的方法，请检查网络是否正常");
}
//连接服务器成功的方法
-(void)xmppStreamDidConnect:(XMPPStream *)sender{
    NSLog(@"连接服务器成功的方法");
    
    //登录
    if (self.connectServerPurposeType == ConnectServerPurposeLogin) {
        NSError *error = nil;
        //向服务器发送密码验证
        //验证可能失败或者成功
        [sender authenticateWithPassword:self.password error:&error];
    }//注册
    else{
        //向服务器发送一个密码注册（成功或者失败）
        [sender registerWithPassword:self.password error:nil];
    
    }
}

//验证登录成功的方法
-(void)xmppStreamDidAuthenticate:(XMPPStream *)sender{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    NSLog(@"验证成功的方法");
    
    /* unavailable 离线       
     available  上线       
     away  离开       
     do not disturb 忙碌 */
//    [ActivityHub ShowHub:@"openfire成功"];
     XMPPPresence *presence = [XMPPPresence presenceWithType:@"available"];
    [self.xmppStream sendElement:presence];
    if (self.manageDelegate &&[self.manageDelegate respondsToSelector:@selector(managerLoginSuccess)]) {
        [self.manageDelegate managerLoginSuccess];
    }
}

//验证失败的方法
-(void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
//     [ActivityHub ShowHub:@"请检查你的用户名或密码是否正确"];
    NSLog(@"验证失败的方法,请检查你的用户名或密码是否正确,%@",error);
}


#pragma mark 注册成功的方法
-(void)xmppStreamDidRegister:(XMPPStream *)sender{
    NSLog(@"注册成功的方法");
}
#pragma mark 注册失败的方法
-(void)xmppStream:(XMPPStream *)sender didNotRegister:(DDXMLElement *)error{
    NSLog(@"注册失败执行的方法");
    NSLog(@"error = %@",error);

}


//发送消息
- (void)sendMessage:(NSString *) message toUser:(NSString *) user {
//    NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
//    [body setStringValue:message];
//    NSXMLElement *meg = [NSXMLElement elementWithName:@"message"];
//    [meg addAttributeWithName:@"type" stringValue:@"chat"];
     NSString *to = [NSString stringWithFormat:@"%@@127.0.0.1", user];
//    [meg addAttributeWithName:@"to" stringValue:to];
//    [meg addChild:body];
//    [self.xmppStream sendElement:meg];
    NSString *siID = [XMPPStream generateUUID];
    //发送消息
    XMPPJID *jid = [XMPPJID jidWithString:to];
    XMPPMessage *mesg = [XMPPMessage messageWithType:@"chat" to:jid elementID:siID];
    NSXMLElement *receipt = [NSXMLElement elementWithName:@"request" xmlns:@"urn:xmpp:receipts"];
    [mesg addChild:receipt];
    [mesg addBody:@"测试"];
    [self.xmppStream sendElement:mesg];
}



//收到回执消息
- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message
{
    NSLog(@"收到消息了");

   
    [LTSNotification postNotificationName:KNotification_MessageChange object:nil];
     NSString *messageBody = [[message elementForName:@"body"] stringValue];
    NSLog(@"%@",messageBody);
    NSLog(@"%@",message.from);
//     [ActivityHub ShowHub:[NSString stringWithFormat:@"收到消息了:%@",messageBody]];
   //回执判断
   NSXMLElement *request = [message elementForName:@"request"];
   if (request)
     {
        if ([request.xmlns isEqualToString:@"urn:xmpp:receipts"])//消息回执
      {
             //组装消息回执
            XMPPMessage *msg = [XMPPMessage messageWithType:[message attributeStringValueForName:@"type"] to:message.from elementID:[message attributeStringValueForName:@"id"]];
           NSXMLElement *recieved =[NSXMLElement elementWithName:@"received" xmlns:@"urn:xmpp:receipts"];
        [msg addChild:recieved];
       //发送回执
        [self.xmppStream sendElement:msg];
              }
             }else
            {
               NSXMLElement *received = [message elementForName:@"received"];
             if (received)
                   {
             if ([received.xmlns isEqualToString:@"urn:xmpp:receipts"])//消息回执
                 {
            //发送成功
                  NSLog(@"message send success!");
              }
           }
         }
    
             //消息处理
            //...
//  if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateBackground)
//    {
//        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
//        localNotification.alertAction = @"Ok";
//        localNotification.alertBody = [NSString stringWithFormat:@"From: %@\n\n%@",@"test",@"This is a test message"];//通知主体
//        localNotification.soundName = @"crunch.wav";//通知声音
//        localNotification.applicationIconBadgeNumber = 1;//标记数
//        [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];//发送通知
//    }else{//如果程序在后台运行，收到消息以通知类型来显示
//       
//    }
}

-  (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error{
   [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
//    [ActivityHub ShowHub:@"断开连接了"];
    NSLog(@"fsdf");
}


//重连机制的代理方法
#pragma  mark ---- XMPPReconnectDelegate ----
-(BOOL)xmppReconnect:(XMPPReconnect *)sender shouldAttemptAutoReconnect:(SCNetworkConnectionFlags)connectionFlags{
//     [ActivityHub ShowHub:@"开始尝试自动连接"];
    NSLog(@"开始尝试自动连接:%u", connectionFlags);
    
    return YES;
    
}

-(void)xmppReconnect:(XMPPReconnect *)sender didDetectAccidentalDisconnect:(SCNetworkConnectionFlags)connectionFlags{
    
     NSLog(@"检测到意外断开连接:%u",connectionFlags);
    
}

@end
