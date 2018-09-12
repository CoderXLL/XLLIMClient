//
//  XLLAttachment.m
//  XLLWriterTest
//
//  Created by liuzhangyong on 2018/7/11.
//  Copyright © 2018年 liuzhangyong. All rights reserved.
//

#import "SJAttachment.h"
#import "UIImage+Orientation.h"

@interface SJAttachment ()

@property (nonatomic, assign) CGSize imageSize;

@end

@implementation SJAttachment

+ (instancetype)attachmentWithImage:(UIImage *)image imageSize:(CGSize)imageSize isNeedCut:(BOOL)isNeedCut
{
    SJAttachment *attachment = [[SJAttachment alloc] init];
    attachment.bounds = CGRectMake(0, 0, imageSize.width, imageSize.height);
    if (isNeedCut) {
        //使其能够填充显示
        image = [image clipCircularImage:CGSizeMake(imageSize.width, imageSize.height)];
    }
    attachment.image = image;
    attachment.imageSize = imageSize;
    return attachment;
}

- (CGRect)attachmentBoundsForTextContainer:(NSTextContainer *)textContainer proposedLineFragment:(CGRect)lineFrag glyphPosition:(CGPoint)position characterIndex:(NSUInteger)charIndex
{
    return CGRectMake(0, 0, self.imageSize.width, self.imageSize.height);
}

@end

