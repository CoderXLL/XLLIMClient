//
//  XLLAttachment.h
//  XLLWriterTest
//
//  Created by liuzhangyong on 2018/7/11.
//  Copyright © 2018年 liuzhangyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SJAttachment : NSTextAttachment

//优化体验，用户选择时，不要立刻上传。使用localPath
@property (nonatomic, copy) NSString *localPath;
//图片网络路径
@property (nonatomic, copy) NSString *netPath;

/**
 初始化SJAttachment实例
 
 @param image 图片
 @param imageSize 自定义size
 @return 实例对象
 */
+ (instancetype)attachmentWithImage:(UIImage *)image imageSize:(CGSize)imageSize isNeedCut:(BOOL)isNeedCut;

@end

