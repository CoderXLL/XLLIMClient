//
//  UIImage+Orientation.h
//  BirdDriver
//
//  Created by 肖乐 on 2018/5/23.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Orientation)

/** 解决旋转90°问题 */
+ (UIImage *)fixOrientation:(UIImage *)aImage;

- (UIImage *)clipCircularImage:(CGSize)imageSize;

@end
