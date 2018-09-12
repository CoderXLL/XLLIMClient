//
//  JAPhotoListModel.h
//  BirdDriverAPI
//
//  Created by Soul on 2018/6/4.
//  Copyright © 2018年 Hangzhou Eneesi Technology Co.,Ltd. All rights reserved.
//

#import "JAResponseModel.h"
#import "JAAtlasListModel.h"

@class JAPhotoModel;

@interface JAPhotoListModel : JAResponseModel

@property (nonatomic, strong) NSArray<JAPhotoModel *> *pictureList;

@end


@interface JAPhotoModel : SPBaseModel

@property (nonatomic, assign) NSInteger ID;

/**
 相关图册id
 */
@property (nonatomic, assign) NSInteger atlasId;

/**
 信息生成时间 
 */
@property (nonatomic, assign) long long createTime;

/**
 图片地址
 */
@property (nonatomic, copy) NSString *address;

#pragma mark - 自定义属性
@property (nonatomic, assign) SJMyPictureShowType showType;
@property (nonatomic, assign, getter=selected) BOOL isSelected;

@end

