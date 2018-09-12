//
//  SJReviewSelPicCollectionViewCell.m
//  BirdDriver
//
//  Created by 宋明月 on 2018/7/18.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJReviewSelPicCollectionViewCell.h"

@interface SJReviewSelPicCollectionViewCell ()

@property (retain, nonatomic) SJPhotoModel *model;


@end

@implementation SJReviewSelPicCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
   
}

-(void)deleteAction{
    self.deletepicBlock(self.model);
}

-(void)setPic:(SJPhotoModel *)photoModel{
    self.model = photoModel;
     [self.detBtn addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
}



@end
