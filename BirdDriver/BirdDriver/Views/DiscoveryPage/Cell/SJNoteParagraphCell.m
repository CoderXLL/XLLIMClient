//
//  SJNoteParagraphCell.m
//  BirdDriverBuildNoteDemo
//
//  Created by Soul on 2018/7/4.
//  Copyright © 2018年 Hangzhou Eneesi Technology Co.,Ltd. All rights reserved.
//

#import "SJNoteParagraphCell.h"

#import <objc/runtime.h>
#import <objc/message.h>

@implementation SJNoteParagraphCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    // _placeholderLabel
    UILabel *placeHolderLabel = [[UILabel alloc] init];
    placeHolderLabel.text = @"添加正文";
    placeHolderLabel.numberOfLines = 0;
    placeHolderLabel.textColor = HEXCOLOR(@"BDBDBD");
    [placeHolderLabel sizeToFit];
    [self.tv_des addSubview:placeHolderLabel];
    
    // same font
    self.tv_des.font = [UIFont fontWithName:@"PingFangSC-Light" size:14];
    placeHolderLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:14];
    
    [self.tv_des setValue:placeHolderLabel forKey:@"_placeholderLabel"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)actionAddPhoto:(id)sender {
    if (self.photoBlock) {
        self.photoBlock(self.paragrapModel.paragraphId);
    }
}

- (IBAction)actionDelPhoto:(id)sender {
    SJNoteParagraphModel *currentModel = self.paragrapModel;
    currentModel.selectedPhoto = nil;
    self.paragrapModel = currentModel;
}

- (void)setParagrapModel:(SJNoteParagraphModel *)paragrapModel{
    _paragrapModel = paragrapModel;
    
    if (paragrapModel.selectedPhoto) {
//        [self.btn_selectImage setTitle:@"更换图片" forState:UIControlStateNormal];
        [self.btn_selectImage setImage:paragrapModel.selectedPhoto.resultImage forState:UIControlStateNormal];
        [self.btn_selectImage.imageView setContentMode:UIViewContentModeScaleAspectFit];
        [self.btn_delImage setHidden:NO];
    }else{
//        [self.btn_selectImage setTitle:@"添加图片(每段最多一张)" forState:UIControlStateNormal];
        [self.btn_selectImage setImage:[UIImage imageNamed:@"note_camera_icon"] forState:UIControlStateNormal];
        [self.btn_selectImage.imageView setContentMode:UIViewContentModeCenter];
        [self.btn_delImage setHidden:YES];
    }
    
    if (paragrapModel.inputDes) {
        self.tv_des.text = paragrapModel.inputDes;
    }else{
        self.tv_des.text = @"";
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
  
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    if (self.textBlock) {
        self.textBlock(textView.text);
    }
}

@end

@implementation SJNoteParagraphModel

@end
