//
//  SJNoteParagraphParase.m
//  BirdDriver
//
//  Created by Soul on 2018/7/5.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJNoteParagraphParase.h"

@implementation SJNoteParagraphParase

+ (NSString *)buildNoteHTMLWithParagraphs:(NSArray<SJNoteParagraphModel *> *)paragraphModels{
    NSMutableString *resultStr = [NSMutableString stringWithString:@""];
    for (SJNoteParagraphModel *model in paragraphModels) {
        NSMutableString *tempStr = [[NSMutableString alloc] initWithString:@""];
        if (model.inputDes) {
            [tempStr appendString:[NSString stringWithFormat:@"<p>%@</p>",model.inputDes]];
        }
        
        if (model.selectedPhoto) {
            [tempStr appendString:[NSString stringWithFormat:@"<img src=\"%@\"/>",model.selectedPhoto.urlStr]];
        }
        
        [resultStr appendString:tempStr];
    }
    
    LogD(@"拼接转换成正文的HTML:%@",resultStr);
    return resultStr;
}

+ (NSString *)buildAssetsUrlsWithParagraphs:(NSArray<SJNoteParagraphModel *> *)paragraphModels{
    NSMutableString *resultStr = [NSMutableString stringWithString:@""];
    for (SJNoteParagraphModel *model in paragraphModels) {
        if (model.selectedPhoto) {
            [resultStr appendString:[NSString stringWithFormat:@"%@,",model.selectedPhoto.urlStr]];
        }
    }
    
    if(resultStr.length>=1 && [[resultStr substringFromIndex:resultStr.length-1]isEqualToString:@","]){
        [resultStr replaceCharactersInRange:NSMakeRange(resultStr.length-1, 1) withString:@""];
    }
    
    LogD(@"拼接发布正文的图片地址集合:%@",resultStr);
    return resultStr;
}

@end
