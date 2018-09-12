//
//  SJCollectionView.h
//  BirdDriver
//
//  Created by 肖乐 on 2018/5/24.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJCollectionView.h"
#import "SJAddPictureCell.h"

// 角度转换
#define angelToRandian(x)  ((x)/180.0*M_PI)
@interface SJCollectionView ()

//长按手势
@property (nonatomic, strong) UILongPressGestureRecognizer *longGesture;
//长按点位
@property (nonatomic, assign) CGPoint touchPoint;
//当前长按的indexPath
@property (nonatomic, strong) NSIndexPath *currentIndexPath;
//cell快照
@property (nonatomic, strong) UIView *snapMoveCell;

@end

@implementation SJCollectionView
@dynamic dataSource, delegate;

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    if (self = [super initWithFrame:frame collectionViewLayout:layout])
    {
        // 添加长按手势
        [self addLongGesture];
    }
    return self;
}

- (void)addLongGesture
{
    UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    longGesture.minimumPressDuration = 1.0;
    [self addGestureRecognizer:longGesture];
    self.longGesture = longGesture;
}

//长按处理
- (void)longPress:(UILongPressGestureRecognizer *)longGesture
{
    switch (longGesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            [self beginGesture:longGesture];
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            [self changeGesture:longGesture];
        }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        {
            [self endOrCancelGesture:longGesture];
        }
            break;
        default:
            break;
    }
}

//开启手势
- (void)beginGesture:(UILongPressGestureRecognizer *)longGesture
{
    //1.获取触摸点位
    CGPoint touchPoint = [longGesture locationOfTouch:0 inView:longGesture.view];
    self.touchPoint = touchPoint;
    self.currentIndexPath = [self indexPathForItemAtPoint:touchPoint];
    //2.根据indexPath获取cell
    UICollectionViewCell *cell = [self cellForItemAtIndexPath:self.currentIndexPath];
    if ([cell isKindOfClass:[SJAddPictureCell class]]) return;
//    //3.代理
//    if (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:didLongPressed:)])
//    {
//        [self.delegate collectionView:self didLongPressed:cell];
//    }
    //4.生成一个cell快照
    UIView *snapMoveCell = [cell snapshotViewAfterScreenUpdates:NO];
    //5.设置快照frame
    cell.hidden = YES;
    snapMoveCell.frame = cell.frame;
    [self addSubview:snapMoveCell];
    self.snapMoveCell = snapMoveCell;
    //6.开始抖动
    [self beginShakeAllCell];
    if (self.delegate && [self.delegate respondsToSelector:@selector(dragCellCollectionViewCellBeginMoving:indexPath:)])
    {
        [self.delegate dragCellCollectionViewCellBeginMoving:self indexPath:self.currentIndexPath];
    }
}

//手势中
- (void)changeGesture:(UILongPressGestureRecognizer *)longGesture
{
    //X轴移动距离
    CGFloat spacingX = [longGesture locationOfTouch:0 inView:longGesture.view].x - self.touchPoint.x;
    //Y轴移动距离
    CGFloat spacingY = [longGesture locationOfTouch:0 inView:longGesture.view].y - self.touchPoint.y;
    //得到快照中心点通过矩阵移动之后的位置
    self.snapMoveCell.center = CGPointApplyAffineTransform(self.snapMoveCell.center, CGAffineTransformMakeTranslation(spacingX, spacingY));
    //重置起始点
    self.touchPoint = [longGesture locationOfTouch:0 inView:longGesture.view];
    //移动cell
    [self moveCell];
}

//手势结束
- (void)endOrCancelGesture:(UILongPressGestureRecognizer *)longGesture
{
    UICollectionViewCell *cell = [self cellForItemAtIndexPath:self.currentIndexPath];
    self.userInteractionEnabled = NO;
    //通知代理
    if ([self.delegate respondsToSelector:@selector(dragCellCollectionViewCellEndMoving:)])
    {
        [self.delegate dragCellCollectionViewCellEndMoving:self];
    }
    [UIView animateWithDuration:.25f animations:^{
        
        self.snapMoveCell.center = cell.center;
    } completion:^(BOOL finished) {
        
        [self stopAllCellShake];
        [self.snapMoveCell removeFromSuperview];
        cell.hidden = NO;
        self.userInteractionEnabled = YES;
    }];
}

//移动cell
- (void)moveCell
{
    for (UICollectionViewCell *cell in self.visibleCells) {
        
        if ([cell isKindOfClass:[SJAddPictureCell class]]) continue;
        if ([self indexPathForCell:cell] == self.currentIndexPath)
            continue;
        //计算快照中心点与此cell中心点X轴位置
        CGFloat spacingX = fabs(cell.center.x - self.snapMoveCell.center.x);
        //计算快照中心店与cell中心店Y轴位置
        CGFloat spacingY = fabs(cell.center.y - self.snapMoveCell.center.y);
        if (spacingX <= self.snapMoveCell.bounds.size.width * 0.5 && spacingY <= self.snapMoveCell.bounds.size.height * 0.5)
        {
            NSIndexPath *indexPath = [self indexPathForCell:cell];
            //开始交换位置
            //1.首先交换数据源
            [self updateDataSource:indexPath];
            //2.交换cell
            [self moveItemAtIndexPath:self.currentIndexPath toIndexPath:indexPath];
            //3.更新当前indexPath
            self.currentIndexPath = indexPath;
            break;
        }
    }
}

//交换数据源
- (void)updateDataSource:(NSIndexPath *)indexPath
{
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(dataSourceOfCollectionView:)])
    {
        NSMutableArray *dataArrayM = [[self.dataSource dataSourceOfCollectionView:self] mutableCopy];
        //这里先就默认为1组了
        if (indexPath.item > self.currentIndexPath.item)
        {
            for (NSInteger i = self.currentIndexPath.item; i < indexPath.item; i++)
            {
                [dataArrayM exchangeObjectAtIndex:i withObjectAtIndex:i+1];
            }
        } else {
            for (NSInteger i = self.currentIndexPath.item; i > indexPath.item; i--)
            {
                [dataArrayM exchangeObjectAtIndex:i withObjectAtIndex:i-1];
            }
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:newDataSourceAfterMove:)])
        {
            [self.delegate collectionView:self newDataSourceAfterMove:[dataArrayM copy]];
        }
    }
}

//开始抖动
- (void)beginShakeAllCell
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
    animation.values = @[
                         @(angelToRandian(4)),
                         @(angelToRandian(-4)),
                         @(angelToRandian(4))
                         ];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.repeatCount = MAXFLOAT;
    animation.duration = 0.2;
    NSArray *allCells = [self visibleCells];
    for (UICollectionViewCell *cell in allCells) {
        
        if ([cell isKindOfClass:[SJAddPictureCell class]]) continue;
        if (![cell.layer animationForKey:@"shake"])
        {
            [cell.layer addAnimation:animation forKey:@"shake"];
        }
    }
    if (![self.snapMoveCell.layer animationForKey:@"shake"])
    {
        [self.snapMoveCell.layer addAnimation:animation forKey:@"shake"];
    }
}

- (void)stopAllCellShake
{
    for (UICollectionViewCell *cell in self.visibleCells) {
        [cell.layer removeAllAnimations];
    }
    [self.snapMoveCell.layer removeAllAnimations];
}

@end

