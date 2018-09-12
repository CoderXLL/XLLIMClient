//
//  SJZoomImageView.h
//  BirdDriver
//
//  Created by 肖乐 on 2018/5/25.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SJZoomImageView : UIView

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImage *image;

@property (nonatomic, assign) CGFloat zoomScale;

@end
