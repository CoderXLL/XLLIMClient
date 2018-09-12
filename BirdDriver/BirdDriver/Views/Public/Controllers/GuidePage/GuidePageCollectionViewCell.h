//
//  GuidePageCollectionViewCell.h
//  GuidePage
//
//  Created by 宋明月 on 2018/1/5.
//  Copyright © 2018年 宋明月. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GuidePageCollectionViewCell : UICollectionViewCell

@property(nonatomic,strong)UIImageView *imageView;
@property (nonatomic, strong)UIButton *button;

-(void)setButtonSizeWith:(CGSize)size bottom:(CGFloat)bottom;


@end
