//
//  SJReplyView.h
//  BirdDriver
//
//  Created by 肖乐 on 2018/8/10.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SJReplyView : UIView

+ (instancetype)replyViewWithPlaceHolder:(NSString *)placeHolder SendBlock:(void(^)(NSString *))sendBlock;

- (void)show;
- (void)dismiss;

@end
