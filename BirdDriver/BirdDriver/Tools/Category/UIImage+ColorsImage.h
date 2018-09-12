//
//  UIImage+ColorsImage.h
//  BirdDriver
//
//  Created by Soul on 2017/7/27.
//  Copyright © 2017年 YingTaoLiCai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum  {
    topToBottom = 0,//从上到小
    leftToRight = 1,//从左到右
    upleftTolowRight = 2,//左上到右下
    uprightTolowLeft = 3,//右上到左下
}GradientType;

@interface UIImage (ColorsImage)

/**
 渐变背景色图片

 @param colors 颜色数组
 @param size 大小
 @return 渐变色图片
 */
+ (UIImage*)imageFromColors:(NSArray*)colors Size:(CGSize)size;

/**
 生成纯色图片

 @param color 颜色
 @return 纯色图片
 */
+ (UIImage *)imageWithBgColor:(UIColor *)color;

/**
 获取缩略图

 @param videoURL 视频地址
 @param time 视频时间
 @return 获取缩略图
 */
- (UIImage*)thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time ;


/**
 渐变颜色转水平渐变图片
 
 @param colors 颜色数组
 @param size 图片大小
 @return 图片
 */
+(UIImage*)horizontallyImageWithColors:(NSArray*)colors size:(CGSize)size;

/**
 渐变颜色转垂直渐变图片
 
 @param colors 颜色数组
 @param size 图片大小
 @return 图片
 */
+(UIImage*)verticallyImageWithColors:(NSArray*)colors size:(CGSize)size;


/**
 颜色转图片
 
 @param color 颜色
 @return 图片
 */
+ (UIImage*)imageWithColor:(UIColor*)color;

/**
 图片转成圆形
 
 @return 圆形图片
 */
- (UIImage *)circleImage;

/**
 UIView转图片
 
 @param view view
 @return 图片
 */
+ (UIImage*)imageWithUIView:(UIView*)view;

/**
 颜色渐变
 
 @return 图片
 */
+ (UIImage*) buttonImageFromColors:(NSArray*)colors ByGradientType:(GradientType)gradientType frame:(CGRect )frame;

/**
 裁剪图片

 @param image 目标图片
 @param targetSize 目标裁剪尺寸
 @return 完成后图片
 */
+ (UIImage *)dealImage:(UIImage *)image scaleToSize:(CGSize)targetSize;

@end
