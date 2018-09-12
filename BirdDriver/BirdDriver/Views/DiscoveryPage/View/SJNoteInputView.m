//
//  SJNoteInputView.m
//  BirdDriver
//
//  Created by 肖乐 on 2018/7/17.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJNoteInputView.h"
#import "JABBSModel.h"

@interface SJNoteInputView ()

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *phraseBtn;
@property (weak, nonatomic) IBOutlet UILabel *phraseLabel;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;

@end

@implementation SJNoteInputView

+ (instancetype)createCellWithXib
{
    return [[[NSBundle mainBundle] loadNibNamed:@"SJNoteInputView" owner:nil options:nil] objectAtIndex:0];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    UIView *leftView = [[UIView alloc] init];
    leftView.size = CGSizeMake(10, self.textField.height);
    self.textField.leftViewMode = UITextFieldViewModeAlways;
    self.textField.leftView = leftView;
}

- (void)setDetailModel:(JABBSModel *)detailModel
{
    _detailModel = detailModel;
    self.phraseLabel.text = [NSString stringWithFormat:@"赞 %zd", detailModel.detail.praises];
    self.phraseBtn.selected = !kStringIsEmpty(detailModel.praiseId);
}

- (IBAction)sendBtnClick:(UIButton *)sender {
    [sender setEnabled:NO];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSendComment:ResultBlock:)])
    {
        [self.delegate didSendComment:self.textField.text
                          ResultBlock:^(BOOL isSuccess) {

          dispatch_async(dispatch_get_main_queue(), ^{
              if (isSuccess) {
                  self.textField.text = @"";
                  [self.textField resignFirstResponder];
              }
              [sender setEnabled:YES];
          });
        }];
    }
}

- (IBAction)phraseBtnClick:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didPraiseWithIsCancel:ResultBlock:)])
    {
        [self.delegate didPraiseWithIsCancel:self.phraseBtn.selected ResultBlock:^(BOOL isSuccess) {
            if (isSuccess) {
                self.phraseBtn.selected = !self.phraseBtn.selected;
                self.phraseLabel.text = [NSString stringWithFormat:@"赞 %zd", self.phraseBtn.selected?self.detailModel.detail.praises+1:self.detailModel.detail.praises-1];
            }
        }];
    }
}

@end
