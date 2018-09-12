//
//  SJPhotoModel.h
//  BirdDriver
//
//  Created by 肖乐 on 2018/5/22.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

@interface SJPhotoModel : NSObject

/**
 初始化模型实例

 @param mAsset 照片原始数据
 @return 实例
 */
- (instancetype)initWithAsset:(PHAsset *)mAsset;

/**
 照片原始数据
 */
@property (nonatomic, strong, readonly) PHAsset *mAsset;

/**
 原始UIImage
 */
@property (nonatomic, strong) UIImage *resultImage;

/**
 图片缩略图
 */
@property (nonatomic, strong) UIImage *thumbnailImage;

/**
 图片标识
 */
@property (nonatomic, copy) NSString *localIdentifier;

/**
 是否选中
 */
@property (nonatomic, assign, getter=selected) BOOL isSelected;


//==============
@property (copy, nonatomic) NSString *urlStr;


@end
