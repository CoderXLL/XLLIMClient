//
//  SJAttributedHeaderView.m
//  BirdDriver
//
//  Created by 肖乐 on 2018/8/7.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJAttributedHeaderView.h"
#import "SJPhotoModel.h"
#import "SJBuildNoteModel.h"
#import "SJAttributedView.h"

@interface SJAttributedHeaderView () <UITextFieldDelegate, SJAttributedViewDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *coverHeightCons;
@property (weak, nonatomic) IBOutlet SJAttributedView *attributedView;
@property (weak, nonatomic) IBOutlet UITextField *tf_title;

@end

@implementation SJAttributedHeaderView

+ (instancetype)createCellWithXib
{
    return [[[NSBundle mainBundle] loadNibNamed:@"SJAttributedHeaderView" owner:nil options:nil] objectAtIndex:0];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    UIView *leftView = [[UIView alloc] init];
    leftView.size = CGSizeMake(10, 20);
    self.tf_title.leftViewMode = UITextFieldViewModeAlways;
    [self.tf_title addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.tf_title.leftView = leftView;
    
    self.attributedView.attributeDelegate = self;
    __weak typeof(self)weakSelf = self;
    self.attributedView.heightBlock = ^(CGFloat attributedViewHeight) {
        weakSelf.coverHeightCons.constant = MAX(222, attributedViewHeight+55);
        if (weakSelf.heightBlock) {
            weakSelf.heightBlock(MAX(attributedViewHeight+55+15+35+30+30, 222+55+15+35+30+30));
        }
    };
}

- (void)insertPhotoModel:(SJPhotoModel *)photoModel
{
    [self.attributedView addAttributesImage:photoModel.resultImage];
}

- (void)setNoteModel:(SJBuildNoteModel *)noteModel
{
    _noteModel = noteModel;
    self.tf_title.text = noteModel.note_title;
    
    NSMutableAttributedString *attributedM = [[NSMutableAttributedString alloc] initWithAttributedString:noteModel.note_attributedText];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentLeft;
    paragraphStyle.lineSpacing = 0.0f;
    paragraphStyle.paragraphSpacing = 10.f;
    
    [attributedM addAttributes:@{NSParagraphStyleAttributeName:paragraphStyle, NSFontAttributeName:SPFont(14.0)} range:NSMakeRange(0, noteModel.note_attributedText.length)];
    self.attributedView.attributedText = attributedM;
    if (noteModel.isNeedReload)
    {
        noteModel.isNeedReload = NO;
        [self.attributedView reloadHeight];
    }
}


- (IBAction)addPhotoBtnClick:(id)sender {
    
    if (self.addBlock) {
        self.addBlock();
    }
}

#pragma mark - SJAttributedViewDelegate
- (void)didEndEdit:(SJAttributedView *)attributedView
{
    self.noteModel.note_attributedText = attributedView.attributedText;
}

#pragma mark - UITextFieldDelegate
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
        //强制挽回遗憾
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
    UITextPosition *beginning = self.tf_title.beginningOfDocument;
    //获取光标选中的textRange
    UITextRange *selectedRange = self.tf_title.selectedTextRange;
    UITextPosition *selectedStart = selectedRange.start;
    UITextPosition *selectedEnd = selectedRange.end;
    //获取文本起始点与光标起始点的偏移量（光标location）
    NSInteger location = [self.tf_title offsetFromPosition:beginning toPosition:selectedStart];
    NSInteger length = [self.tf_title offsetFromPosition:selectedStart toPosition:selectedEnd];
    return NSMakeRange(location, length);
}

- (void)updateSelectedTextRange:(NSRange)selectedRange
{
    UITextPosition *beginning = self.tf_title.beginningOfDocument;
    UITextPosition *startPosition = [self.tf_title positionFromPosition:beginning offset:selectedRange.location];
    UITextPosition *endPosition = [self.tf_title positionFromPosition:beginning offset:selectedRange.location + selectedRange.length];
    UITextRange *selectTextRange = [self.tf_title textRangeFromPosition:startPosition toPosition:endPosition];
    [self.tf_title setSelectedTextRange:selectTextRange];
}


#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.noteModel.note_title = textField.text;
}

@end
