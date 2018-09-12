//
//  JAConfigPresenter.h
//  BirdDriver
//
//  Created by liuzhangyong on 2018/7/6.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "JAPresenter.h"
#import "JAWXKeyModel.h"

@interface JAConfigPresenter : JAPresenter

/**
 获取小程序原始id

 @param retBlock 回执
 */
+ (void)postWXKeyWithResult:(void (^)(JAWXKeyModel * _Nullable))retBlock;

@end
