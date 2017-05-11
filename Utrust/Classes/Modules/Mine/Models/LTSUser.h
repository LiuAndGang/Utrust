//
//  JSUser.h
//  SAIFAMC
//
//  Created by leetangsong_macbk on 16/4/14.
//  Copyright © 2016年 macbook. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LTSUser : NSObject<NSCoding>
@property (nonatomic,copy)NSString * userID;

@property (nonatomic,copy)NSString *userName;

@property (nonatomic,copy)NSString *userType;

@property (nonatomic,copy)NSString *password;

@property (nonatomic,copy)NSString *qq;

@property (nonatomic,copy)NSString *telephone;

@property (nonatomic,copy)NSString *sex;

@property (nonatomic,copy)NSString *empId;

@property (nonatomic,copy)NSString *empName;

@property (nonatomic,copy)NSString *empEmail;

@property (nonatomic,copy)NSString *jobAddress;

@property (nonatomic,copy)NSString *jobEmail;

@property (nonatomic,copy)NSString *phone;

@property (nonatomic,copy)NSString *jobPhone;

@property (nonatomic,copy)NSString *email;

@property (nonatomic,copy)NSString *portraitUrl;

@property (nonatomic,copy)NSString *token;

@property (nonatomic,copy)NSString *address;

//@property (nonatomic,strong) NSNumber *ID;
@property (nonatomic,copy) NSString *openfireUserName;
@property (nonatomic,copy)NSString *openfireUserId;
@property (nonatomic,copy)NSString *userId;

+(LTSUser *)userFromData:(NSData *)data;

- (NSData *)dataFromUser;
@end

@interface UserOpenfire : NSObject


@end
