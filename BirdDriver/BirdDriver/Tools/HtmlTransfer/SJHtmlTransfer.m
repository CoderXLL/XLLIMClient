//
//  XLLHtmlTransfer.m
//  XLLWriterTest
//
//  Created by liuzhangyong on 2018/7/11.
//  Copyright © 2018年 liuzhangyong. All rights reserved.
//

#import "SJHtmlTransfer.h"
#import "SJAttachment.h"
#import <UIKit/UIKit.h>
#import "OCGumbo.h"
#import "UIImage+Orientation.h"

@implementation SJHtmlTransfer

+ (NSDictionary *)getParagraphDict
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentLeft;
    paragraphStyle.lineSpacing = 0.0f;
    paragraphStyle.paragraphSpacing = 10.f;
    return  @{
              NSParagraphStyleAttributeName:paragraphStyle,
              NSFontAttributeName:[UIFont systemFontOfSize:16.0]
              };
}

+ (NSAttributedString *)transferAttributedTextWithHtml:(NSString *)htmlContent isFixed:(BOOL)isFixed
{
    //    NSData *data = [htmlContent dataUsingEncoding:NSUTF8StringEncoding];
    //    NSDictionary *options = @{
    //                              NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType
    //                              };
    //    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithData:data options:options documentAttributes:nil error:nil];
    //    return attributedText;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    OCGumboDocument *document = [[OCGumboDocument alloc] initWithHTMLString:htmlContent];
    OCGumboElement *body = document.body;
    for (OCGumboNode *node in body.childNodes) {
        
        if ([node isKindOfClass:[OCGumboElement class]]) {
            
            if ([node.nodeName isEqualToString:@"img"])
            {
                NSArray *attributeArray = ((OCGumboElement *)node).attributes;
                for (OCGumboAttribute *attr in attributeArray) {
                    
                    if ([attr.name isEqualToString:@"src"])
                    {
                        CGFloat expendWidth = [UIScreen mainScreen].bounds.size.width-30-12.f;
                        CGSize expendSize = CGSizeMake(expendWidth, expendWidth*0.5);
                        NSString *attrValue = attr.value;
                        UIImage *image;
                        if (attrValue.length < 4) continue;
                        if ([[attrValue substringToIndex:4].uppercaseString isEqualToString:@"HTTP"])
                        {
                            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:attrValue]];
                            image = [UIImage imageWithData:imageData];
                        } else {
                            NSData *imageData = [[NSData alloc] initWithContentsOfFile:attrValue];
                            image = [UIImage imageWithData:imageData];
                        }
                        if (!isFixed) {
                            expendSize = CGSizeMake(expendWidth, expendWidth*image.size.height*1.0/image.size.width);
                        }
                        SJAttachment *attachment = [SJAttachment attachmentWithImage:image imageSize:expendSize isNeedCut:isFixed];
                        if ([[attrValue substringToIndex:4].uppercaseString isEqualToString:@"HTTP"])
                        {
                            attachment.netPath = attrValue;
                        }
                        NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:attachment];
                        [attributedString insertAttributedString:attachmentString atIndex:attributedString.string.length];
//                        [attributedString appendAttributedString:attachmentString];
                    }
                }
            } else if ([node.nodeName isEqualToString:@"p"]) {
                
                if (node.childNodes.count > 0)
                {
                    OCGumboText *gumboText = node.childNodes.firstObject;
                    if (!kStringIsEmpty(gumboText.nodeValue)) {
                        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:gumboText.nodeValue attributes:[self getParagraphDict]];
                        if ([gumboText.nodeValue isEqualToString:@"\n"]) {
                            //关键字分段
                            [attributedText addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, attributedText.length)];
                        }
                        [attributedString insertAttributedString:attributedText atIndex:attributedString.string.length];
//                        [attributedString appendAttributedString:attributedText];
                    } else {
                        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:@"\n" attributes:[self getParagraphDict]];
                        [attributedText addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, attributedText.length)];
                        [attributedString insertAttributedString:attributedText atIndex:attributedString.string.length];
//                        [attributedString appendAttributedString:attributedText];
                    }
                } else {
                    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:@"" attributes:[self getParagraphDict]];
                    [attributedText addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, attributedText.length)];
                    [attributedString insertAttributedString:attributedText atIndex:attributedString.string.length];
//                    [attributedString appendAttributedString:attributedText];
                }
            }
        }
    }
    
    return attributedString;
}

//由attributedText->html
+ (NSString *)xll_transferHtmlWithAttributedText:(NSAttributedString *)attributedText isPublish:(BOOL)isPublish
{
    BOOL isNewParagraph = YES;
    BOOL isFirstLoop = YES;
    BOOL lastIsText = NO;
    
    
    NSMutableString *htmlContent = [NSMutableString string];
    NSRange effectiveRange = NSMakeRange(0, 0);
    while (effectiveRange.location + effectiveRange.length < attributedText.length) {
        
        NSDictionary *attributes = [attributedText attributesAtIndex:effectiveRange.location effectiveRange:&effectiveRange];
        SJAttachment *attachment = attributes[@"NSAttachment"];
        if (attachment)
        {
            if (lastIsText) {
                if (htmlContent.length > 5) {
                    NSString *subStr = [htmlContent substringFromIndex:htmlContent.length-5];
                    if (![subStr containsString:@"</p>"]) {
                        [htmlContent appendString:@"</p>"];
                    }
                }
            }
            lastIsText = NO;
            [htmlContent appendString:[NSString stringWithFormat:@"<img src=\"%@\" width=\"100%%\"/>", attachment.netPath?attachment.netPath:attachment.localPath]];
            isNewParagraph = YES;
        } else {
            lastIsText = YES;
            NSString *text = [[attributedText string] substringWithRange:effectiveRange];
            if (isFirstLoop || isNewParagraph)
            {
                [htmlContent appendString:@"<p>"];
                isNewParagraph = NO;
            }
            if ([text containsString:@"\n"])
            {
                if (lastIsText) {
                    if (isPublish) {
                        //去除两个p标签问题
                        [htmlContent appendFormat:@"%@</p>", text];
                    } else {
                        //为了草稿进行区分段落
                        [htmlContent appendFormat:@"</p><p>%@</p>", text];
                    }
                } else {
                    [htmlContent appendFormat:@"<p>%@</p>", text];
                }
                isNewParagraph = YES;
            } else {
                [htmlContent appendString:text];
            }
            if (effectiveRange.location + effectiveRange.length >= attributedText.length && ![htmlContent hasSuffix:@"</p>"])
            {
                //补上</p>
                [htmlContent appendString:@"</p>"];
            }
        }
        effectiveRange = NSMakeRange(effectiveRange.location + effectiveRange.length, 0);
        isFirstLoop = NO;
    }
    return [htmlContent copy];
}


//由attributedText->html
+ (NSString *)transferHtmlWithAttributedText:(NSAttributedString *)attributedText
{
    BOOL isNewParagraph = YES;
    NSMutableString *htmlContent = [NSMutableString string];
    NSRange effectiveRange = NSMakeRange(0, 0);
    while (effectiveRange.location + effectiveRange.length < attributedText.length) {
        
        NSDictionary *attributes = [attributedText attributesAtIndex:effectiveRange.location effectiveRange:&effectiveRange];
        SJAttachment *attachment = attributes[@"NSAttachment"];
        if (attachment)
        {
            if (htmlContent.length > 5) {
                NSString *subStr = [htmlContent substringFromIndex:htmlContent.length-5];
                if (![subStr containsString:@"</p>"]) {
//                if (![subStr isEqualToString:@"</p>"]) {
                    [htmlContent appendString:@"</p>"];
                }
            }
            [htmlContent appendString:[NSString stringWithFormat:@"<img src=\"%@\" width=\"100%%\"/>", attachment.netPath?attachment.netPath:attachment.localPath]];
        } else {
            NSString *text = [[attributedText string] substringWithRange:effectiveRange];
            BOOL isFirst = YES;
            NSArray *components = [text componentsSeparatedByString:@"\n"];
            for (NSInteger i = 0; i < components.count; i ++) {
                NSString *content = components[i];
                if (!isFirst && !isNewParagraph) {
                    [htmlContent appendString:@"</p>"];
                    isNewParagraph = YES;
                }
                if (isNewParagraph && (content.length > 0 || i < components.count - 1)) {
                    [htmlContent appendString:@"<p>"];
                    isNewParagraph = NO;
                }
                if (isFirst) {
                    //style='display:inline-block'
                    [htmlContent appendString:@"<p>"];
                    [htmlContent appendString:content];
                } else {
                    [htmlContent appendString:[NSString stringWithFormat:@"\n%@", content]];
                }
                isFirst = NO;
            }
            if (effectiveRange.location + effectiveRange.length >= attributedText.length && ![htmlContent hasSuffix:@"</p>"])
            {
                //补上</p>
                [htmlContent appendString:@"</p>"];
            }
        }
        effectiveRange = NSMakeRange(effectiveRange.location + effectiveRange.length, 0);
    }
    return [htmlContent copy];
}

+ (NSArray <SJAttachment *>*)getAttributedAttachment:(NSAttributedString *)attributedText
{
    NSMutableArray <SJAttachment *>*attachments = [NSMutableArray array];
    NSRange effectiveRange = NSMakeRange(0, 0);
    while (effectiveRange.location + effectiveRange.length < attributedText.length) {
        NSDictionary *attributes = [attributedText attributesAtIndex:effectiveRange.location effectiveRange:&effectiveRange];
        SJAttachment *attachment = attributes[@"NSAttachment"];
        if (attachment) {
            [attachments addObject:attachment];
        }
        effectiveRange = NSMakeRange(effectiveRange.location + effectiveRange.length, 0);
    }
    return attachments;
}


//异步加载
+ (void)transferAttributedTextWithHtml:(NSString *)htmlContent ResultBlock:(void(^)(NSAttributedString *))resultBlock
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    OCGumboDocument *document = [[OCGumboDocument alloc] initWithHTMLString:htmlContent];
    OCGumboElement *body = document.body;
    NSMutableArray <SJAttachment *>*attathments = [NSMutableArray array];
    for (OCGumboNode *node in body.childNodes) {
        
        if ([node isKindOfClass:[OCGumboElement class]]) {
            
            if ([node.nodeName isEqualToString:@"img"])
            {
                NSArray *attributeArray = ((OCGumboElement *)node).attributes;
                for (OCGumboAttribute *attr in attributeArray) {
                    
                    if ([attr.name isEqualToString:@"src"])
                    {
                        CGFloat expendWidth = [UIScreen mainScreen].bounds.size.width-30-12.f;
                        CGSize expendSize = CGSizeMake(expendWidth, expendWidth*0.5);
                        NSString *attrValue = attr.value;
                        UIImage *image = [UIImage imageNamed:@"default_picture"];
                        SJAttachment *attachment = [SJAttachment attachmentWithImage:image imageSize:expendSize isNeedCut:YES];
                        if ([[attrValue substringToIndex:4].uppercaseString isEqualToString:@"HTTP"])
                        {
                            attachment.netPath = attrValue;
                        }
                        [attathments addObject:attachment];
                        NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:attachment];
                        [attributedString appendAttributedString:attachmentString];
                    }
                }
            } else if ([node.nodeName isEqualToString:@"p"]) {
                
                if (node.childNodes.count > 0)
                {
                    OCGumboText *gumboText = node.childNodes.firstObject;
                    if (!kStringIsEmpty(gumboText.nodeValue)) {
                        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:gumboText.nodeValue attributes:[self getParagraphDict]];
                        [attributedString appendAttributedString:attributedText];
                    }
                }
            }
        }
    }
    
    if (resultBlock) {
        resultBlock(attributedString);
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (SJAttachment *attachment in attathments) {
            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:attachment.netPath]];
            UIImage *image = [UIImage imageWithData:imageData];
            CGFloat expendWidth = [UIScreen mainScreen].bounds.size.width-30-12.f;
            CGSize expendSize = CGSizeMake(expendWidth, expendWidth*0.5);
            attachment.bounds = CGRectMake(0, 0, expendSize.width, expendSize.height);
            //使其能够填充显示
            image = [image clipCircularImage:CGSizeMake(expendSize.width, expendSize.height)];
            attachment.image = image;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (resultBlock) {
                resultBlock(attributedString);
            }
        });
    });
}

@end

