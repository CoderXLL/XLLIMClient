//
//  SJPhotoComponents.h
//  BirdDriver
//
//  Created by 肖乐 on 2018/5/23.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

/** cell间距 */
UIKIT_EXTERN CGFloat const SJPhotoCellSpacing;
/** 内间距 */
UIKIT_EXTERN CGFloat const SJPhotoMargin;
/** 相册间距 */
UIKIT_EXTERN CGFloat const SJBrowserMargin;

@interface SJPhotoComponents : NSObject

/**
 相册中,展示图片的宽高
 */
+ (CGSize)assetGridCellSize;

/**
 获取能否访问相册权限
 
 @param handler 结果回调
 */
+ (void)requestPhotoAuthorizationWithCompletionHandler:(void(^)(BOOL isAllowed))handler;

/**
 压缩图片至大小指定像素左右

 @param sourceImage 原图片
 @param targetPx 指定像素
 @return 压缩后二进制
 */
+ (NSData *)imageCompressForSize:(UIImage *)sourceImage
                        targetPx:(NSInteger)targetPx;

@end
