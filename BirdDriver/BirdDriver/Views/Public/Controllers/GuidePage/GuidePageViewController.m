//
//  GuidePageViewController.m
//  GuidePage
//
//  Created by 宋明月 on 2018/1/5.
//  Copyright © 2018年 宋明月. All rights reserved.
//

#import "GuidePageViewController.h"
#import "GuidePageCollectionViewCell.h"

//UIPageControl默认数据
static CGFloat  kpagecontrolheight = 40;
static CGFloat  kpagecontrolBottom = 30;

//UIButton默认数据
static CGFloat  kbuttonCorners = 0;
static NSString *buttonTitle = @"立即体验";
static CGFloat  kButtonheight = 0;
static CGFloat  kButtonBottom = 0;
static CGFloat  kButtonwidth = 0;



@interface GuidePageViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property(assign, nonatomic)BOOL containsButtons;
@property(assign, nonatomic)BOOL containsPageControl;

@property (nonatomic, strong)UICollectionView *mainCollectionView;
@property (nonatomic, strong)UIPageControl *pageControl;
@property (nonatomic, strong)NSMutableArray *imageArray;
//UIPageControl默认颜色
@property (nonatomic, strong) UIColor *currentPageTintColor;
@property (nonatomic, strong) UIColor *pageTintColor;
//UIButton默认颜色
@property (nonatomic, strong) UIColor *buttonBgColor;
@property (nonatomic, strong) UIColor *buttontitleColor;
@property (nonatomic, strong) UIImage *buttonImage;


@end

@implementation GuidePageViewController


- (instancetype)initWithImageArray:(NSArray *)imageArray containsButtons:(BOOL)containsButtons containsPageControl:(BOOL)containsPageControl{
    if (self = [super init]) {
        self.imageArray = [imageArray copy];
        self.containsPageControl = containsPageControl;
        self.containsButtons = containsButtons;
        
        self.currentPageTintColor = [UIColor redColor];
        self.pageTintColor = [UIColor lightGrayColor];
        self.buttontitleColor = [UIColor whiteColor];
        self.buttonBgColor = [UIColor lightGrayColor];
    }
    return self;
}

-(void)setPageControlStyleWithCurrentPageTintColor:(UIColor *)currentColor pageColor:(UIColor *)pageColor pagecontrolBottom:(CGFloat)pagecontrolBottom{
    if (currentColor) {
        self.currentPageTintColor = currentColor;
    }
    if (pageColor) {
        self.pageTintColor = pageColor;
    }
    if (pagecontrolBottom > 0) {
        kpagecontrolBottom = pagecontrolBottom;
    }
}

-(void)setButtonStyleWithTitle:(NSString *)title
                    titleColor:(UIColor *)titleColor
                       BgColor:(UIColor *)bgColor{
    if (title && title.length > 0) {
        buttonTitle = title;
    }
    if (titleColor) {
        self.buttontitleColor = titleColor;
    }
    if (bgColor) {
        self.buttonBgColor = bgColor;
    }
}
-(void)setButtonStyleWithButtonImage:(UIImage *)buttonImage{
    if (buttonImage) {
        self.buttonImage = buttonImage;
        kButtonheight = self.buttonImage.size.height;
        kButtonwidth = self.buttonImage.size.width;
    }
}

-(void)setButtonStyleWithCornerRadius:(CGFloat)cornerRadius
                        height:(CGFloat)height
                         width:(CGFloat)width
                        bottom:(CGFloat)bottom{
    if (cornerRadius > 0) {
       kbuttonCorners = cornerRadius;
    }
    if (height > 0) {
        kButtonheight = height;
    }
    if (width > 0) {
        kButtonwidth = width;
    }
    if (bottom > 0) {
        kButtonBottom = bottom;
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.mainCollectionView];
    if (self.containsPageControl) {
        [self.view addSubview:self.pageControl];
    }
}

/**
 *  初始化CollectionView
 *
 *  @return CollectionView
 */
-(UICollectionView *)mainCollectionView{
    if (!_mainCollectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        layout.itemSize = [UIScreen mainScreen].bounds.size;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _mainCollectionView = [[UICollectionView alloc] initWithFrame:[UIScreen mainScreen].bounds collectionViewLayout:layout];
        _mainCollectionView.bounces = NO;
        _mainCollectionView.backgroundColor = [UIColor whiteColor];
        _mainCollectionView.showsHorizontalScrollIndicator = NO;
        _mainCollectionView.showsVerticalScrollIndicator = NO;
        _mainCollectionView.pagingEnabled = YES;
        _mainCollectionView.dataSource = self;
        _mainCollectionView.delegate = self;
        
        [_mainCollectionView registerClass:[GuidePageCollectionViewCell class] forCellWithReuseIdentifier:@"GuidePageCollectionViewCell"];
    }
    return _mainCollectionView;
}

/**
 *  初始化pageControl
 *
 *  @return pageControl
 */
- (UIPageControl *)pageControl {
    if (_pageControl == nil) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.currentPageIndicatorTintColor = self.currentPageTintColor;
        _pageControl.pageIndicatorTintColor = self.pageTintColor;
        _pageControl.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, kpagecontrolheight);
        _pageControl.center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2, [UIScreen mainScreen].bounds.size.height - kpagecontrolBottom - kpagecontrolheight/2);
        _pageControl.numberOfPages = self.imageArray.count;
        _pageControl.userInteractionEnabled= NO;
    }
    return _pageControl;
}



#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.pageControl.currentPage = (scrollView.contentOffset.x / [UIScreen mainScreen].bounds.size.width);
    if (self.containsPageControl) {
        if (self.pageControl.currentPage == self.imageArray.count - 1) {
            self.pageControl.hidden = YES;
        } else {
            self.pageControl.hidden = NO;
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.imageArray count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    GuidePageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GuidePageCollectionViewCell" forIndexPath:indexPath];
    UIImage *image = [UIImage imageNamed:[self.imageArray objectAtIndex:indexPath.item]];
    cell.imageView.image = image;
    if (self.containsButtons) {
        if (indexPath.item == self.imageArray.count - 1) {
            [cell.button setHidden:NO];
            [cell setButtonSizeWith:CGSizeMake(kButtonwidth, kButtonheight) bottom:kButtonBottom];
            cell.button.layer.cornerRadius = kbuttonCorners;
            if (self.buttonImage) {
                [cell.button setImage:self.buttonImage forState:UIControlStateNormal];
            } else {
                cell.button.backgroundColor = self.buttonBgColor;
                [cell.button setTitle:buttonTitle forState:UIControlStateNormal];
                [cell.button setTitleColor:self.buttontitleColor forState:UIControlStateNormal];
            }
        } else {
            [cell.button setHidden:YES];
        }
    } else {
        [cell.button setHidden:YES];
    }
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.item == [self.imageArray count] - 1) {
        if(self.guidePageBlock){
            self.guidePageBlock();
        }
    }
}


@end
