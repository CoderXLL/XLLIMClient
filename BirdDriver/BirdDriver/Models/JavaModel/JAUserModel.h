//
//  JAUserModel.h
//  BirdDriverAPI
//
//  Created by Soul on 2018/5/22.
//  Copyright © 2018年 Hangzhou Eneesi Technology Co.,Ltd. All rights reserved.
//

#import "JAResponseModel.h"
#import "JAUserAccount.h"

@interface JAUserModel : JAResponseModel

@property (nonatomic, strong) JAUserAccount *data;

@end



