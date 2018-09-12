//
//  SJPhotoCell.h
//  BirdDriver
//
//  Created by 肖乐 on 2018/5/22.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SJPhotoModel, JAPhotoModel;
@interface SJPhotoCell : UICollectionViewCell

@property (nonatomic, strong) SJPhotoModel *photoModel;
@property (nonatomic, strong) JAPhotoModel *pictureModel;

@property (nonatomic, copy) void (^photoCallBack)(id);

@end
