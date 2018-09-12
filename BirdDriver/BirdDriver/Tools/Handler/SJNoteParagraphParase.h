//
//  SJNoteParagraphParase.h
//  BirdDriver
//
//  Created by Soul on 2018/7/5.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SJNoteParagraphCell.h"

@interface SJNoteParagraphParase : NSObject

/**
 将正文段落组装成Html用于展示

 @param paragraphModels 段落Model数组
 @return Html正文
 */
+ (NSString *)buildNoteHTMLWithParagraphs:(NSArray <SJNoteParagraphModel *>*)paragraphModels;

/**
 将正文段落解析出使用的图片地址集合，用于时光轴展示

 @param paragraphModels paragraphModels 段落Model数组
 @return 帖子/活动图片地址，以英文逗号分隔
 */
+ (NSString *)buildAssetsUrlsWithParagraphs:(NSArray <SJNoteParagraphModel *>*)paragraphModels;

@end
