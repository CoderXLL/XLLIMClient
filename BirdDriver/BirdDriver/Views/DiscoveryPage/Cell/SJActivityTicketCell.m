//
//  SJActivityTicketCell.m
//  BirdDriver
//
//  Created by 肖乐 on 2018/5/25.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJActivityTicketCell.h"
#import "SJBuildNoteModel.h"
#import "SJPhotoModel.h"

@interface SJActivityTicketCell () <UITextViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UILabel *placeHolderLabel;


@end

@implementation SJActivityTicketCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (IBAction)addBtnClick:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickAddPicture)])
    {
        [self.delegate didClickAddPicture];
    }
}

- (void)setBuildModel:(SJBuildNoteModel *)buildModel
{
    _buildModel = buildModel;
    SJPhotoModel *photoModel = buildModel.photos.firstObject;
    if (photoModel)
    {
        self.iconView.image = photoModel.thumbnailImage;
    }
    self.textView.text = buildModel.note_content;
    self.nameField.text = buildModel.note_title;
    self.placeHolderLabel.hidden = !kStringIsEmpty(buildModel.note_content);
}


#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    UITextRange *markRange = textView.markedTextRange;
    UITextPosition *pos = [textView positionFromPosition:markRange.start offset:0];
    if (markRange && pos)
    {
        return YES;
    }
    if (textView.text.length+text.length > 1000)
    {
        return NO;
    }
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    self.buildModel.note_content = textView.text;
    if (self.reloadBlock) {
        self.reloadBlock();
    }
}

- (void)textViewDidChange:(UITextView *)textView
{
    self.placeHolderLabel.hidden = !kStringIsEmpty(textView.text);
    UITextRange *markRange = textView.markedTextRange;
    UITextPosition *pos = [textView positionFromPosition:markRange.start offset:0];
    if (markRange && pos) {
        [textView setNeedsDisplay];
        return;
    }
    if (textView.text.length > 1000)
    {
        NSRange selectedRange = textView.selectedRange;
        NSString *tmpSTR = textView.text;
        textView.text = self.buildModel.note_content;
        selectedRange.location -= (tmpSTR.length - self.buildModel.note_content.length);
        [textView setSelectedRange:selectedRange];
    } else {
        self.buildModel.note_content = textView.text;
        [textView setNeedsDisplay];
    }
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.buildModel.note_title = textField.text;
    if (self.reloadBlock) {
        self.reloadBlock();
    }
}

//未渲染，扼杀在摇篮里
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    UITextRange *markRange = textField.markedTextRange;
    UITextPosition *pos = [textField positionFromPosition:markRange.start offset:0];
    if (markRange && pos)
    {
        //如果是高亮状态，尽管输
        return YES;
    }
    //限制字符输入
    if (textField.text.length + string.length > 20)
    {
        return NO;
    }
    return YES;
}


//已经渲染
- (void)textFieldDidChange:(UITextField *)textField
{
    //输入汉字时的高亮范围
    UITextRange *markRange = textField.markedTextRange;
    UITextPosition *pos = [textField positionFromPosition:markRange.start offset:0];
    //如果真的处于高亮状态
    if (markRange && pos) return;
    if (textField.text.length > 20) {
        
        //强制挽回遗憾
        // 保留光标的位置信息
        NSRange selectedRange = [self selectedRange];
        // 保留当前文本的内容
        NSString *tmpSTR = textField.text;
        // 设置了文本,光标到了最后
        textField.text = self.buildModel.note_title;
        // 重新设置光标的位置
        selectedRange.location -= (tmpSTR.length - self.buildModel.note_title.length);
        [self updateSelectedTextRange:selectedRange];
    } else {
        self.buildModel.note_title = textField.text;
    }
}

//获取textField的当前光标range
- (NSRange)selectedRange
{
    //获取一开始的position
    UITextPosition *beginning = self.nameField.beginningOfDocument;
    //获取光标选中的textRange
    UITextRange *selectedRange = self.nameField.selectedTextRange;
    UITextPosition *selectedStart = selectedRange.start;
    UITextPosition *selectedEnd = selectedRange.end;
    //获取文本起始点与光标起始点的偏移量（光标location）
    NSInteger location = [self.nameField offsetFromPosition:beginning toPosition:selectedStart];
    NSInteger length = [self.nameField offsetFromPosition:selectedStart toPosition:selectedEnd];
    return NSMakeRange(location, length);
}

- (void)updateSelectedTextRange:(NSRange)selectedRange
{
    UITextPosition *beginning = self.nameField.beginningOfDocument;
    UITextPosition *startPosition = [self.nameField positionFromPosition:beginning offset:selectedRange.location];
    UITextPosition *endPosition = [self.nameField positionFromPosition:beginning offset:selectedRange.location + selectedRange.length];
    UITextRange *selectTextRange = [self.nameField textRangeFromPosition:startPosition toPosition:endPosition];
    [self.nameField setSelectedTextRange:selectTextRange];
}

@end
