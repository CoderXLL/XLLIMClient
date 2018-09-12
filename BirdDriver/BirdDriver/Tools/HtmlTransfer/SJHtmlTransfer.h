//
//  XLLHtmlTransfer.h
//  XLLWriterTest
//
//  Created by liuzhangyong on 2018/7/11.
//  Copyright © 2018年 liuzhangyong. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SJAttachment;

@interface SJHtmlTransfer : NSObject


/**
 由attributedText转为htmlContent
 
 @param attributedText 富文本
 @return html代码
 */
+ (NSString *)transferHtmlWithAttributedText:(NSAttributedString *)attributedText;

+ (NSString *)xll_transferHtmlWithAttributedText:(NSAttributedString *)attributedText isPublish:(BOOL)isPublish;

/**
 由htmlContent转为富文本
 
 @param htmlContent html代码
 @param isFixed 是否滚定宽高
 @return 富文本
 
 @discussion 此方法有耗时操作，建议在子线程中调用
 */
+ (NSAttributedString *)transferAttributedTextWithHtml:(NSString *)htmlContent isFixed:(BOOL)isFixed;

/**
 异步加载富文本

 @param htmlContent html代码
 @param resultBlock 回执
 */
+ (void)transferAttributedTextWithHtml:(NSString *)htmlContent ResultBlock:(void(^)(NSAttributedString *))resultBlock;

/**
 获取富文本中的attachment

 @param attributedText 富文本
 @return attachment集合
 */
+ (NSArray <SJAttachment *>*)getAttributedAttachment:(NSAttributedString *)attributedText;

@end


