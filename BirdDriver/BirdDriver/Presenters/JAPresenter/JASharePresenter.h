//
//  JASharePresenter.h
//  BirdDriver
//
//  Created by 肖乐 on 2018/6/28.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "JAPresenter.h"

@interface JASharePresenter : JAPresenter


/**
 分享后任务

 @param shareType 分享类型  1.自己主页  2.他人主页  3.帖子  4.活动
 @param retBlock 回执
 */
+ (void)postShareActivity:(NSInteger)shareType
                detailsId:(NSInteger)detailsId
                   Result:(void (^_Nonnull)(JAResponseModel * _Nullable model))retBlock;

@end
