//
//  SJHomeRecViewRow.m
//  BirdDriver
//
//  Created by Soul on 2018/5/17.
//  Copyright © 2018年 Hangzhou Eneesi Technology Co.,Ltd. All rights reserved.
//

#import "SJHomeRecViewRow.h"
#import "SJHomeRecViewCell.h"
#import "JABannerListModel.h"
#import "SJBannerFlowLayout.h"

#define MCTotalRowsInSection (5000 * self.bannerList.count)
#define MCDefaultRow (NSUInteger)(MCTotalRowsInSection * 0.5)

@interface SJHomeRecViewRow()<UICollectionViewDataSource,UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate>
{
    NSInteger _currentIndex;
}

@property (nonatomic, strong) NSTimer *timer;
@property (weak, nonatomic) IBOutlet UICollectionView *cv_rec;
@property (weak, nonatomic) IBOutlet UIPageControl *pc_dot;

@end

@implementation SJHomeRecViewRow

- (void)addTimer {
    // 先移除,再添加
    [self removeTimer];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(nextBanner) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)removeTimer {
    
    [self.timer invalidate];
    self.timer = nil;
}

- (void)nextBanner
{
    if ((_currentIndex % self.bannerList.count)  == 0)
    {
        [self scrollToItemAtIndex:MCDefaultRow animated:NO];
        _currentIndex = MCDefaultRow;
    }
    _currentIndex++;
    [self scrollToItemAtIndex:_currentIndex animated:YES];
}

#pragma mark - UIScrollViewDelegate
/**
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
//    if (scrollView == self.cv_rec) {
//        CGFloat width = kScreenWidth *260.0f/375;
//        CGFloat pageSpacing = width+kSJMargin; // width + space
//        float currentOffset = scrollView.contentOffset.x;
//        float targetOffset = targetContentOffset->x;
//
//        float newTargetOffset = 0;
//        if (targetOffset > currentOffset) {
//            newTargetOffset = ceilf(currentOffset / pageSpacing) * pageSpacing;
//        } else {
//            newTargetOffset = floorf(currentOffset / pageSpacing) * pageSpacing;
//        }
//        if (newTargetOffset < 0) {
//            newTargetOffset = 0;
//        } else if (newTargetOffset > scrollView.contentSize.width) {
//            newTargetOffset = scrollView.contentSize.width;
//        }
//        targetContentOffset->x = currentOffset;
//        [scrollView setContentOffset:CGPointMake(newTargetOffset, 0) animated:YES];
//    }
}
*/

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self removeTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    //260/375
    CGFloat width = kScreenWidth *260.0f/375;
    CGFloat pageSpacing = width+kSJMargin;
    _currentIndex = roundf(scrollView.contentOffset.x*1.0/pageSpacing);
    [self addTimer];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger currentPage = roundf(scrollView.contentOffset.x/(kScreenWidth *260.0f/375+15));
    self.pc_dot.currentPage = currentPage % self.bannerList.count;
}

- (void)scrollToItemAtIndex:(NSInteger)index animated:(BOOL)animated
{
    CGFloat contentOffsetX = index * (15+kScreenWidth *260.0f/375);
    [self.cv_rec setContentOffset:CGPointMake(contentOffsetX, 0) animated:animated];
}


- (void)dealloc{
    
    [self removeTimer];
    self.cv_rec.delegate = nil;
    self.cv_rec.dataSource = nil;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.cv_rec registerNib:[UINib nibWithNibName:NSStringFromClass([SJHomeRecViewCell class]
                                                                           )
                                                  bundle:[NSBundle mainBundle]]
        forCellWithReuseIdentifier:NSStringFromClass([SJHomeRecViewCell class])];
    
    self.cv_rec.backgroundColor = SP_CLEAR_COLOR;
    self.cv_rec.dataSource = self;
    self.cv_rec.delegate = self;
    self.cv_rec.pagingEnabled = NO;
    
    self.pc_dot.currentPageIndicatorTintColor = SJ_MAIN_COLOR;
    self.pc_dot.pageIndicatorTintColor = HEXCOLOR(@"CCCCCC");
    self.pc_dot.hidesForSinglePage = YES;
//    self.backgroundColor = [UIColor colorWithRed:(random()%256)/255.0 green:(random()%256)/255.0 blue:(random()%256)/255.0 alpha:1.0];
}

- (void)setBannerList:(NSArray<JABannerModel *> *)bannerList
{
    _bannerList = bannerList;
    if (bannerList.count>1) {
        [self addTimer];
    }
    [self.cv_rec reloadData];
    self.pc_dot.numberOfPages = bannerList.count;
}


- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    SJHomeRecViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([SJHomeRecViewCell class]) forIndexPath:indexPath];
    if (!cell) {
        cell = [SJHomeRecViewCell new];
    }
    cell.bannerModel = self.bannerList[indexPath.item%self.bannerList.count];
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return MCTotalRowsInSection;
}

//定义每个Cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat width = kScreenWidth *260.0f/375;
    CGSize size = CGSizeMake(width, collectionView.height); //150
    return size;
}

//这个是两行cell之间的间距（左右行cell的间距）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 15.0f;
}

//两个cell之间的间距（上下行的cell的间距）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return kLine_HeightT_1_PPI;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(kLine_HeightT_1_PPI, 15, kLine_HeightT_1_PPI, 15);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    JABannerModel *bannerModel = self.bannerList[indexPath.item%self.bannerList.count];
    if (self.detailBlock) {
        self.detailBlock(bannerModel);
    }
}

@end
