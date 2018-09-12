//
//  SJNoteReplyProtocol.h
//  BirdDriver
//
//  Created by 肖乐 on 2018/8/9.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

// commentModel可能为JACommentVOModel, JAPostCommentItemModel
@protocol SJNoteReplyProtocol <NSObject>

//点击头像
- (void)didClickUserHead:(id)commentModel;
//点击举报
- (void)noteCommentModel:(id)commentModel didClickReportBtn:(CGPoint)currentPoint;
//点击查看更多回复
- (void)didClickMoreReply:(id)commentModel;
//点击回复
- (void)didClickReply:(id)commentModel;

@end
