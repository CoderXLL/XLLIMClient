//
//  SJZoomImageView.h
//  BirdDriver
//
//  Created by 肖乐 on 2018/5/25.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJZoomImageView.h"

@interface SJZoomImageView () <UIScrollViewDelegate>

@property (nonatomic, weak) UIScrollView *scrollView;

@end

@implementation SJZoomImageView
@synthesize zoomScale = _zoomScale;

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setupBase];
    }
    return self;
}

- (void)setupBase
{
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.delegate = self;
    scrollView.minimumZoomScale = 1;
    scrollView.maximumZoomScale = 3;
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:scrollView];
    self.scrollView = scrollView;
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    [scrollView addSubview:imageView];
    self.imageView = imageView;
    
    UITapGestureRecognizer *doubleGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleGestureClick:)];
    doubleGesture.numberOfTapsRequired = 2;
    [self addGestureRecognizer:doubleGesture];
}

- (void)doubleGestureClick:(UITapGestureRecognizer *)doubleGesture
{
    if (self.scrollView.zoomScale > 1)
    {
        [self.scrollView setZoomScale:1 animated:YES];
        
    } else {
        
        CGPoint touchPoint = [doubleGesture locationInView:self.imageView];
        CGFloat newZoomScale = self.scrollView.maximumZoomScale;
        CGFloat zoomWidth = kScreenWidth / newZoomScale;
        CGFloat zoomHeight = kScreenHeight / newZoomScale;
        [self.scrollView zoomToRect:CGRectMake(touchPoint.x - zoomWidth/2, touchPoint.y - zoomHeight/2, zoomWidth, zoomHeight) animated:YES];
    }
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    
    scrollView.subviews[0].center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,scrollView.contentSize.height * 0.5 + offsetY);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.scrollView.frame = self.bounds;
}

- (void)setFrame:(CGRect)frame
{
    
    if (self.scrollView.zoomScale == 1)
    {
        [super setFrame:frame];
        self.imageView.center = self.center;
    }
    
}

- (void)setImage:(UIImage *)image
{
    if (!image) return;
    _image = image;
    self.imageView.image = image;
    
    CGFloat imageWidth = _image.size.width;
    CGFloat imageHeight = _image.size.height;
    
    CGFloat scaleWidth = kScreenWidth / imageWidth;
    CGFloat scaleHeight = kScreenHeight / imageHeight;
    
    CGRect cFrame = self.imageView.frame;
    if (scaleWidth > scaleHeight) {
        cFrame.size = CGSizeMake(imageWidth * scaleHeight, kScreenHeight);
    } else {
        cFrame.size = CGSizeMake(kScreenWidth, imageHeight * scaleWidth);
    }
    self.imageView.frame = cFrame;
    
    if (self.scrollView.zoomScale == 1)
    {
        self.imageView.center = self.center;
    }
}

- (CGFloat)zoomScale
{
    return self.scrollView.zoomScale;
}

- (void)setZoomScale:(CGFloat)zoomScale
{
    _zoomScale = zoomScale;
    [self.scrollView setZoomScale:zoomScale];
}

@end

