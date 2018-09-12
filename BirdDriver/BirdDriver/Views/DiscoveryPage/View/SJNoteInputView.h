//
//  SJNoteInputView.h
//  BirdDriver
//
//  Created by 肖乐 on 2018/7/17.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JABBSModel;

@protocol SJNoteInputViewDelegate <NSObject>

//发送评论
- (void)didSendComment:(NSString *)commentText ResultBlock:(void(^)(BOOL))resultBlock;
//点赞
- (void)didPraiseWithIsCancel:(BOOL)isCancel ResultBlock:(void(^)(BOOL))resultBlock;

@end

@interface SJNoteInputView : UIView

@property (nonatomic, strong) JABBSModel *detailModel;
+ (instancetype)createCellWithXib;

@property (nonatomic, weak) id <SJNoteInputViewDelegate> delegate;

@end
