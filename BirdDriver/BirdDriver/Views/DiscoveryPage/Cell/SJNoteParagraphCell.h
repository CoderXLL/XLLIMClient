//
//  SJNoteParagraphCell.h
//  BirdDriverBuildNoteDemo
//
//  Created by Soul on 2018/7/4.
//  Copyright © 2018年 Hangzhou Eneesi Technology Co.,Ltd. All rights reserved.
//

#import "SPBaseCell.h"
#import "SJPhotoModel.h"

@class SJNoteParagraphModel;

typedef void(^BuildNotePhotoBlock)(NSInteger paragraphId);
typedef void(^BuildParagraphBlock)(NSString *paragraphStr);

@interface SJNoteParagraphCell : SPBaseCell<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *tv_des;
@property (weak, nonatomic) IBOutlet UIButton *btn_selectImage;
@property (weak, nonatomic) IBOutlet UIButton *btn_delImage;

@property (strong, nonatomic) SJNoteParagraphModel *paragrapModel;

@property (copy, nonatomic) BuildNotePhotoBlock photoBlock;
@property (copy, nonatomic) BuildParagraphBlock textBlock;

@end

@interface SJNoteParagraphModel:NSObject

@property (assign, nonatomic) NSInteger paragraphId;        //段落id，用于区分正在操作的段落
@property (copy, nonatomic) NSString *inputDes;             //输入的正文段落文字
@property (strong, nonatomic) SJPhotoModel *selectedPhoto;  //已添加的图片上传返回的资源地址

@end
