//
//  SJTeamListModel.h
//  BirdDriver
//
//  Created by 宋明月 on 2018/7/18.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "JAResponseModel.h"

@class JAUserData;

@interface SJTeamListModel : JAResponseModel

@property (nonatomic, strong) NSArray<JAUserData *> *userAccountPOsList;

@end

@interface JAUserData : NSObject

@property (nonatomic, assign) NSInteger Id;

@property (nonatomic, assign) NSArray *labelsList;//用户标签

@property (nonatomic, copy) NSString *nickName;//昵称

@property (nonatomic, copy) NSString *photoSrc;//头像

@end
