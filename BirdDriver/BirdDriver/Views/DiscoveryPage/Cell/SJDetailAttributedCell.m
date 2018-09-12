//
//  SJDetailAttributedCell.m
//  BirdDriver
//
//  Created by 肖乐 on 2018/7/16.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJDetailAttributedCell.h"
#import "SJAttachment.h"
#import "SJHtmlTransfer.h"

static float detailHeight = 100.0;             //Cell 高度 (估高)

@interface SJDetailAttributedCell () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation SJDetailAttributedCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.textView.editable = NO;
    self.textView.scrollEnabled = NO;
}

- (void)setAttributedString:(NSAttributedString *)attributedString
{
    NSMutableAttributedString *attributedM = [[NSMutableAttributedString alloc] initWithAttributedString:attributedString];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentLeft;
    paragraphStyle.lineSpacing = 0.0f;
    paragraphStyle.paragraphSpacing = 10.f;
    
    [attributedM addAttributes:@{NSParagraphStyleAttributeName:paragraphStyle, NSFontAttributeName:SPFont(14.0)} range:NSMakeRange(0, attributedString.length)];
    _attributedString = [attributedString copy];
    self.textView.attributedText = attributedM;
    detailHeight = [self.textView sizeThatFits:self.textView.size].height;
}

+ (CGFloat)cellHeightWithAttributedString:(NSAttributedString *)attributedString
{
    CGFloat fixHeight = 20+5;
    return fixHeight+detailHeight;
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction
API_AVAILABLE(ios(10.0)){
    
    if (interaction == UITextItemInteractionInvokeDefaultAction)
    {
        SJAttachment *attachment = (SJAttachment *)textAttachment;
        NSArray <SJAttachment *>*attachments = [SJHtmlTransfer getAttributedAttachment:textView.attributedText];
        NSInteger currentIndex = [attachments indexOfObject:attachment];
        if (self.clickBlock) {
            self.clickBlock(attachments, currentIndex);
        }
        return YES;
    }
    return NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
