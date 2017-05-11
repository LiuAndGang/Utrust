//
//  LTSWarnAlertView.m
//  SAIFAMC
//
//  Created by 李棠松 on 16/8/26.
//  Copyright © 2016年 leetangsong. All rights reserved.
//

#import "LTSWarnAlertView.h"

@interface LTSWarnAlertView()
@property (nonatomic,strong)UIButton *cancel;

@property (nonatomic,strong)UIButton *commit;


@property (nonatomic,strong)UILabel *messageLabel;
@end
@implementation LTSWarnAlertView

- (void)initUI{
    [super initUI];
    
    self.alertView = ({UIView *view =[UIView new];
        view.backgroundColor = [UIColor whiteColor];
      
        
        self.messageLabel = [UILabel new];
        self.messageLabel.font = [UIFont systemFontOfSize:16];
        [view addSubview:self.messageLabel];
        self.messageLabel.textAlignment = NSTextAlignmentCenter;
        self.messageLabel.numberOfLines = 0;
        
       
        UIButton *cancel = [UIButton new];
        cancel.titleLabel.font = [UIFont systemFontOfSize:16];
        [cancel setTitleColor:SecondaryText forState:UIControlStateNormal];
        [cancel setTitle:@"取消" forState:UIControlStateNormal];
        cancel.tag = 0;
        [view addSubview:cancel];
        self.cancel = cancel;
        @weakify(self)
        [[self.cancel rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            
            @strongify(self)
            if (self.delegate && [self.delegate respondsToSelector:@selector(alertView:clickButtonAtIndex:)]) {
                [self.delegate alertView:self clickButtonAtIndex:0];
                
            }
            [self dismissWithAnimation:YES];
        }];
        
        
        UIButton *create = [UIButton new];
        create.titleLabel.font = [UIFont systemFontOfSize:16];
        [create setTitleColor:OrangeColor forState:UIControlStateNormal];
        [create setTitle:@"确定" forState:UIControlStateNormal];
        [view addSubview:create];
        create.tag = 1;
        
        self.commit = create;
        
        [[self.commit rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
             @strongify(self)
            if (self.delegate && [self.delegate respondsToSelector:@selector(alertView:clickButtonAtIndex:)]) {
                [self.delegate alertView:self clickButtonAtIndex:1];
              
            }
              [self dismissWithAnimation:YES];
        }];

        
         view;
        
    });
    
    
    
}
- (void)dismissWithAnimation:(BOOL)animation{
    [super dismissWithAnimation:animation];
    self.messageLabel = nil;
    self.commit = nil;
    self.cancel = nil;
    
}
- (void)setMessage:(NSString *)message{
    _message = message;
    self.messageLabel.text = message;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.width.mas_equalTo(Screen_Width-80);
        make.top.mas_equalTo(15);
    }];
    [self.cancel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
         make.height.mas_equalTo(44);
        make.width.mas_equalTo(self.alertView.mas_width).multipliedBy(0.5);
        make.top.mas_equalTo(self.messageLabel.mas_bottom).with.offset(15);
    }];
    [self.commit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(44);
        make.width.mas_equalTo(self.alertView.mas_width).multipliedBy(0.5);
        make.top.mas_equalTo(self.messageLabel.mas_bottom).with.offset(15);
    }];
   
    
    
    [self layoutIfNeeded];
    UIView *midLine = [UIView new];
    
    midLine.backgroundColor = lineBGColor;
    [self.alertView addSubview:midLine];
    [midLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.cancel.mas_top).with.offset(0);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
//
//    
    

    ViewRadius(self.alertView, 5);
    
    self.alertView.frame = CGRectMake(0, 0, Screen_Width-40, CGRectGetMaxY(self.cancel.frame));
    self.alertView.center = self.alertWindow.center;
    
    UIView *line = [UIView new];
    
    line.backgroundColor = lineBGColor;
    [self.alertView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.cancel.mas_top).with.offset(0);
        make.width.mas_equalTo(0.5);
        make.left.mas_equalTo((Screen_Width-40)/2);
        make.bottom.mas_equalTo(0);
    }];
}

@end
