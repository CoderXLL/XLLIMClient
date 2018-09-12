//
//  JAReadAllMsgModel.h
//  BirdDriver
//
//  Created by 肖乐 on 2018/9/5.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "JAResponseModel.h"

@class JAReadAllMsgDataModel;
@interface JAReadAllMsgModel : JAResponseModel

@property (nonatomic, strong) JAReadAllMsgDataModel *data;

@end

@interface JAReadAllMsgDataModel : JAResponseModel

@property (nonatomic, assign) NSInteger nsjMessageId;

@end

