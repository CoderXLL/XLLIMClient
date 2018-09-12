//
//  SJNoviceHobbiesLayout.m
//  BirdDriver
//
//  Created by Soul on 2018/8/28.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJNoviceHobbiesLayout.h"

@implementation SJNoviceHobbiesLayout


const NSInteger kMaxCellSpacing = 1;

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    NSArray *currentLayout = [super layoutAttributesForElementsInRect:rect];

    if (currentLayout && currentLayout.count >= 1) {
       UICollectionViewLayoutAttributes *firstCell = currentLayout[0];
        
        //避免首个cell自动居中
        CGRect frame = firstCell.frame;
        frame.origin.x = self.sectionInset.left;
        frame.origin.y = self.sectionInset.top;
        
        firstCell.frame = frame;
    }
    
    return currentLayout;
}

@end
