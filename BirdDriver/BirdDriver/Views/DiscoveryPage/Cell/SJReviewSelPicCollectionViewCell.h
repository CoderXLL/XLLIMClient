//
//  SJReviewSelPicCollectionViewCell.h
//  BirdDriver
//
//  Created by 宋明月 on 2018/7/18.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SJPhotoModel.h"


typedef void(^deletePictureBlock) (SJPhotoModel * model);


@interface SJReviewSelPicCollectionViewCell : UICollectionViewCell


@property (weak, nonatomic) IBOutlet UIImageView *pictureImageView;
@property (weak, nonatomic) IBOutlet UIButton *detBtn;

@property (nonatomic)deletePictureBlock deletepicBlock;

-(void)setPic:(SJPhotoModel *)photoModel;

@end
