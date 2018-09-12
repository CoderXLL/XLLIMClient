//
//  JAPostCommentModel.m
//  BirdDriver
//
//  Created by 肖乐 on 2018/9/3.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "JAPostCommentModel.h"

@implementation JAPostCommentModel

@end

@implementation JAPostCommentDataModel

- (instancetype)init
{
    if (self = [super init])
    {
        self.list = [NSMutableArray array];
    }
    return self;
}

+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"list":@"JAPostCommentItemModel"
             };
}

@end

@implementation JAPostCommentItemModel

- (CGFloat)cellHeight
{
    CGFloat commentHeight = [self.content boundingRectWithSize:CGSizeMake(kScreenWidth-2*kSJMargin, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:SPFont(14.0)} context:nil].size.height;
    commentHeight = MAX(commentHeight, 20);
    if (self.childCommentNum > 1) {
        return commentHeight+150;
    } else if (self.childCommentNum == 1) {
        return commentHeight+120;
    }
    return commentHeight+75;
}

@end

@implementation JACommentVOModel

- (NSString *)content
{
    if (kStringIsEmpty(self.replyNickName)) {
        return _content;
    }
    return [NSString stringWithFormat:@"回复了@%@：%@", self.replyNickName, _content];
}

- (CGFloat)cellHeight
{
    CGFloat commentHeight = [self.content boundingRectWithSize:CGSizeMake(kScreenWidth-2*kSJMargin, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:SPFont(14.0)} context:nil].size.height;
    commentHeight = MAX(commentHeight, 20);
    return commentHeight+75;
}

@end
