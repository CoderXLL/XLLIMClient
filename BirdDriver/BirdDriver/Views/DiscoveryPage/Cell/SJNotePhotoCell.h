//
//  SJPhotoCell.h
//  BirdDriver
//
//  Created by 肖乐 on 2018/5/22.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SJNotePhotoCell : UICollectionViewCell

@property (nonatomic, strong) id model;
@property (nonatomic, copy) void (^removeBlock)(id model);

@end

