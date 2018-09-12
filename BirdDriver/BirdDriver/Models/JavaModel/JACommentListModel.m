//
//  SJCommentListModel.m
//  BirdDriver
//
//  Created by 肖乐 on 2018/7/16.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "JACommentListModel.h"

@implementation JACommentListModel


+ (NSDictionary *)objectClassInArray
{
    return @{@"commentsList" : [JACommentModel class]};
}

@end


@implementation JACommentModel

- (NSString *)commentText
{
    if (kStringIsEmpty(self.replyNickName)) {
        return _commentText;
    }
    return [NSString stringWithFormat:@"回复了@%@：%@", self.replyNickName, _commentText];
}

- (CGFloat)cellHeight
{
    CGFloat commentHeight = [self.commentText boundingRectWithSize:CGSizeMake(kScreenWidth-2*kSJMargin, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:SPFont(14.0)} context:nil].size.height;
    commentHeight = MAX(commentHeight, 20);
    if (self.sonComments > 1 && !kObjectIsEmpty(self.childComment)) {
        return commentHeight+150;
    } else if (self.sonComments == 1 && !kObjectIsEmpty(self.childComment)) {
        return commentHeight+120;
    }
    return commentHeight+75;
}

- (NSString *)nickName
{
    return kStringIsEmpty(_nickName)?[NSString stringWithFormat:@"用户%zd", self.commentUserId]:_nickName;
}

@end
