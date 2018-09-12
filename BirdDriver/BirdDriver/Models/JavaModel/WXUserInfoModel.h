//
//  WXUserInfoModel.h
//  BirdDriverAPI
//
//  Created by Soul on 2018/5/31.
//  Copyright © 2018年 Hangzhou Eneesi Technology Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WXUserInfoModel : NSObject

@property (nonatomic, copy) NSString *openid;

@property (nonatomic, copy) NSString *city;

@property (nonatomic, copy) NSString *country;

@property (nonatomic, copy) NSString *nickname;

@property (nonatomic, strong) NSArray *privilege;

@property (nonatomic, copy) NSString *language;

@property (nonatomic, copy) NSString *headimgurl;

@property (nonatomic, copy) NSString *unionid;

@property (nonatomic, assign) NSInteger sex;

@property (nonatomic, copy) NSString *province;

@end

