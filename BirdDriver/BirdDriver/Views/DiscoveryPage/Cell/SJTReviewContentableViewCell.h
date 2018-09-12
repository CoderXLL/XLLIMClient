//
//  SJTReviewContentableViewCell.h
//  BirdDriver
//
//  Created by 宋明月 on 2018/7/18.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPCustomButtonView.h"

@interface SJTReviewContentableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextView *contectView;
@property (weak, nonatomic) IBOutlet UICollectionView *pictureCollectionView;

@property (weak, nonatomic) IBOutlet SPCustomButtonView *sureBtn;



@end
