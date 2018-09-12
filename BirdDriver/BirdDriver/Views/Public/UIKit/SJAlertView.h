//
//  SJAlertView.h
//  BirdDriver
//
//  Created by 肖乐 on 2018/5/24.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SJAlertModel : NSObject

- (instancetype)initWithTitle:(NSString *)title
                      handler:(void(^)(id))handler;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) void(^handler)(id);

@end

typedef NS_ENUM(NSInteger, SJAlertShowType) {
    
    SJAlertShowTypeNormal,   //正常类型
    SJAlertShowTypeSubTitle, //副标题
    SJAlertShowTypeInput     //输入类型
};

@interface SJAlertView : UIView

/**
 初始化alertView实例

 @param title 标题
 @param message 副标题或者placeHolder
 @return 实例对象
 */
+ (instancetype)alertWithTitle:(NSString *)title
                       message:(NSString *)message
                          type:(SJAlertShowType)type
                   alertModels:(NSArray <SJAlertModel *>*)alertModels;

- (void)showAlertView;

@end
