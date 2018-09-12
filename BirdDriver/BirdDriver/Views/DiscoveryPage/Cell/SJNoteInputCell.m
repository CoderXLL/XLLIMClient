//
//  SJNoteInputCell.m
//  BirdDriver
//
//  Created by 肖乐 on 2018/5/22.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJNoteInputCell.h"
#import "SJBuildNoteModel.h"

@interface SJNoteInputCell () <UITextViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UILabel *placeHolderLabel;

@end

@implementation SJNoteInputCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    //设置textField左间距
    self.titleField.leftViewMode = UITextFieldViewModeAlways;
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, self.titleField.frame.size.height)];
    self.titleField.leftView = leftView;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setNoteModel:(SJBuildNoteModel *)noteModel
{
    _noteModel = noteModel;
    self.titleField.text = noteModel.note_title;
    self.placeHolderLabel.hidden = !kStringIsEmpty(noteModel.note_content);
    self.inputView.text = noteModel.note_content;
}

- (IBAction)actionChoosePhoto:(id)sender {

}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.noteModel.note_title = textField.text;
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
        textField.text = self.noteModel.note_title;
        // 重新设置光标的位置
        selectedRange.location -= (tmpSTR.length - self.noteModel.note_title.length);
        [self updateSelectedTextRange:selectedRange];
    } else {
        self.noteModel.note_title = textField.text;
    }
}

//获取textField的当前光标range
- (NSRange)selectedRange
{
    //获取一开始的position
    UITextPosition *beginning = self.titleField.beginningOfDocument;
    //获取光标选中的textRange
    UITextRange *selectedRange = self.titleField.selectedTextRange;
    UITextPosition *selectedStart = selectedRange.start;
    UITextPosition *selectedEnd = selectedRange.end;
    //获取文本起始点与光标起始点的偏移量（光标location）
    NSInteger location = [self.titleField offsetFromPosition:beginning toPosition:selectedStart];
    NSInteger length = [self.titleField offsetFromPosition:selectedStart toPosition:selectedEnd];
    return NSMakeRange(location, length);
}

- (void)updateSelectedTextRange:(NSRange)selectedRange
{
    UITextPosition *beginning = self.titleField.beginningOfDocument;
    UITextPosition *startPosition = [self.titleField positionFromPosition:beginning offset:selectedRange.location];
    UITextPosition *endPosition = [self.titleField positionFromPosition:beginning offset:selectedRange.location + selectedRange.length];
    UITextRange *selectTextRange = [self.titleField textRangeFromPosition:startPosition toPosition:endPosition];
    [self.titleField setSelectedTextRange:selectTextRange];
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

//这个地方做字符限制
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
        textView.attributedText = self.noteModel.note_attributedText;
        selectedRange.location -= (tmpSTR.length - self.noteModel.note_content.length);
        [textView setSelectedRange:selectedRange];
    } else {
        self.noteModel.note_content = textView.text;
        [textView setNeedsDisplay];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    self.noteModel.note_attributedText = textView.attributedText;
    
    if (self.reloadBlock) {
        self.reloadBlock();
    }
}

@end
