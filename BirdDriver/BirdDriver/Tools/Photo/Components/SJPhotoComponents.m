//
//  SJPhotoComponents.m
//  BirdDriver
//
//  Created by 肖乐 on 2018/5/23.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJPhotoComponents.h"
#import <Photos/Photos.h>

/** cell间距 */
CGFloat const SJPhotoCellSpacing = 5.0;
/** 内间距 */
CGFloat const SJPhotoMargin = 15.0;
/** 相册间距 */
CGFloat const SJBrowserMargin = 30.f;

@implementation SJPhotoComponents
static CGSize kAssetCellSize;

+ (void)initialize
{
    CGFloat kCellWidth = (kScreenWidth - SJPhotoMargin*2 - 3*SJPhotoCellSpacing)/4.0;
    kAssetCellSize = CGSizeMake(kCellWidth, kCellWidth);
}

+ (CGSize)assetGridCellSize
{
    return kAssetCellSize;
}

//请求相册访问权限
+ (void)requestPhotoAuthorizationWithCompletionHandler:(void (^)(BOOL))handler
{
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            switch (status) {
                case PHAuthorizationStatusAuthorized:
                    handler(YES);
                    break;
                default:
                    handler(NO);
                    break;
            }
        });
    }];
}

+ (NSData *)imageCompressForSize:(UIImage *)sourceImage targetPx:(NSInteger)targetPx
{
    //1.尺寸压缩后的新图
    UIImage *newImage = nil;
    //2.源图片的size
    CGSize imageSize = sourceImage.size;
    //3.源图片的宽
    CGFloat width = imageSize.width;
    //4.原图片的高
    CGFloat height = imageSize.height;
    //5.是否需要重绘图片 默认是NO
    BOOL drawImge = NO;
    //6.压缩比例
    CGFloat scaleFactor = 0.0;
    //7.压缩时的宽度 默认是参照像素
    CGFloat scaledWidth = targetPx;
    //8.压缩是的高度 默认是参照像素
    CGFloat scaledHeight = targetPx;
    
    // 先进行图片的尺寸的判断
    // a.图片宽高均≤参照像素时，图片尺寸保持不变
    if (width < targetPx && height < targetPx) {
        
        newImage = sourceImage;
    }  else if (width > targetPx && height > targetPx) {
        // b.宽或高均＞1280px时
        drawImge = YES;
        CGFloat factor = width / height;
        if (factor <= 2) {
            // b.1图片宽高比≤2，则将图片宽或者高取大的等比压缩至1280px
            scaleFactor = width > height ? targetPx / width : targetPx / height;
        } else {
            // b.2图片宽高比＞2时，则宽或者高取小的等比压缩至1280px
            scaleFactor = width > height ? targetPx / height : targetPx / width;
        }
    } else if (width > targetPx &&  height < targetPx ) {
        // c.宽高一个＞1280px，另一个＜1280px 宽大于1280
        if (width / height > 2) {
            newImage = sourceImage;
        } else {
            drawImge = YES;
            scaleFactor = targetPx / width;
        }
    } else if (width < targetPx &&  height > targetPx) {
        // c.宽高一个＞1280px，另一个＜1280px 高大于1280
        if (height / width > 2) {
            newImage = sourceImage;
        } else {
            drawImge = YES;
            scaleFactor = targetPx / height;
        }
    }
    
    // 如果图片需要重绘 就按照新的宽高压缩重绘图片
    if (drawImge == YES)
    {
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        UIGraphicsBeginImageContext(CGSizeMake(scaledWidth, scaledHeight));
        // 绘制改变大小的图片
        [sourceImage drawInRect:CGRectMake(0, 0, scaledWidth,scaledHeight)];
        // 从当前context中创建一个改变大小后的图片
        newImage =UIGraphicsGetImageFromCurrentImageContext();
        // 使当前的context出堆栈
        UIGraphicsEndImageContext();
    }
    // 防止出错  可以删掉的
    if (newImage == nil) {
        newImage = sourceImage;
    }
    // 如果图片大小大于200kb 在进行质量上压缩
    NSData * scaledImageData = nil;
    if (UIImageJPEGRepresentation(newImage, 1) == nil)
    {
        scaledImageData = UIImagePNGRepresentation(newImage);
    }else{
        scaledImageData = UIImageJPEGRepresentation(newImage, 1);
        if (scaledImageData.length >= 1024 * 200)
        {
            scaledImageData =   UIImageJPEGRepresentation(newImage, 0.9);
        }
    }
    
    return scaledImageData;
}


@end
