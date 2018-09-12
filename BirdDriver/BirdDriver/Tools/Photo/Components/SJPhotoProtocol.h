//
//  SJPhotoProtocol.h
//  BirdDriver
//
//  Created by 肖乐 on 2018/5/23.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SJPhotosController, SJPhotoModel;

@protocol SJPhotoProtocol <NSObject>

- (void)photoController:(SJPhotosController *)photoVC didSelectedPhotos:(NSArray <SJPhotoModel *>*)photos;

@end
