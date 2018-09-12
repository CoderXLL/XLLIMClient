//
//  UIImage+Orientation.m
//  BirdDriver
//
//  Created by 肖乐 on 2018/5/23.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "UIImage+Orientation.h"
#import <SDWebImage/UIImage+WebP.h>
#import <SDWebImage/NSData+ImageContentType.h>

@implementation UIImage (Orientation)

+ (void)load
{
    /** 获取系统imageWithData方法 */
    Method originalM = class_getClassMethod([self class], @selector(imageWithData:));
    /** 获取自定义euc_imageWithData方法 */
    Method exchangeM = class_getClassMethod([self class], @selector(sj_imageWithData:));
    /** 方法交换 */
    method_exchangeImplementations(originalM, exchangeM);
}

+ (UIImage *)sj_imageWithData:(NSData *)data
{
    // 查看sd的处理方式
    UIImage *image;
    SDImageFormat imageFormat = [NSData sd_imageFormatForImageData:data];
    if (imageFormat == SDImageFormatWebP)
    {
        image = [UIImage sd_imageWithWebPData:data];
    } else {
        image = [self sj_imageWithData:data];
    }
    return image;
}

/** 解决旋转90度问题 */
+ (UIImage *)fixOrientation:(UIImage *)aImage
{
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

- (UIImage *)clipCircularImage:(CGSize)imageSize
{
    //    UIGraphicsBeginImageContext(self.size);
    //    CGContextRef context = UIGraphicsGetCurrentContext();
    //    CGContextBeginPath(context);
    //    CGContextAddRect(context, CGRectMake(ABS(self.size.width-imageSize.width)*0.5, ABS(self.size.height-imageSize.height)*0.5, MIN(self.size.width, imageSize.width), MIN(self.size.height, imageSize.height)));
    //    CGContextClip(context);
    //    CGRect myRect = CGRectMake(0 , 0, self.size.width ,  self.size.height);
    //    [self drawInRect:myRect];
    //    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    //    UIGraphicsEndImageContext();
    //    return  newImage;
    //1.将UIImage转换成CGImageRef
    CGImageRef imageRef = [self CGImage];
    //2.按照给定的矩形区域进行剪裁
    CGImageRef newImageRef = CGImageCreateWithImageInRect(imageRef,  CGRectMake(ABS(self.size.width-imageSize.width)*0.5, ABS(self.size.height-imageSize.height)*0.5, MIN(self.size.width, imageSize.width), MIN(self.size.height, imageSize.height)));
    //3.将CGImageRef转换成UIImage
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    CGImageRelease(imageRef);
    return newImage;
}

@end
