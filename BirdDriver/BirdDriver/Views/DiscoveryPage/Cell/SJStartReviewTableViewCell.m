//
//  SJStartReviewTableViewCell.m
//  BirdDriver
//
//  Created by 宋明月 on 2018/7/18.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJStartReviewTableViewCell.h"

@implementation SJStartReviewTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.count = -1;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.v_star];
    if((point.x>0 && point.x<self.v_star.frame.size.width)&&(point.y>0 && point.y<self.v_star.frame.size.height)){
        self.canAddStar = YES;
        [self changeStarForegroundViewWithPoint:point];
        
    }else{
        self.canAddStar = NO;
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if(self.canAddStar){
        UITouch *touch = [touches anyObject];
        CGPoint point = [touch locationInView:self.v_star];
        [self changeStarForegroundViewWithPoint:point];
        
    }
    return;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if(self.canAddStar){
        UITouch *touch = [touches anyObject];
        CGPoint point = [touch locationInView:self.v_star];
        [self changeStarForegroundViewWithPoint:point];
    }
    self.canAddStar = NO;
    return;
}


-(void)changeStarForegroundViewWithPoint:(CGPoint)point{
    if(self.v_count.hidden){
        self.v_count.hidden = NO;
    }
    NSInteger count = 0;
    count = count + [self changeImg:point.x image:self.img_star1];
    count = count + [self changeImg:point.x image:self.img_star2];
    count = count + [self changeImg:point.x image:self.img_star3];
    count = count + [self changeImg:point.x image:self.img_star4];
    count = count + [self changeImg:point.x image:self.img_star5];
    if(count==0){
        count = 1;
        [self.img_star1 setImage:[UIImage imageNamed:@"review_starHalf"]];
    }
    self.count = count;
    if(count==10){
        self.v_count.text = @"10.0分";
    }else{
        self.v_count.text = [NSString stringWithFormat:@"%ld.0分",count];
    }
}

-(NSInteger)changeImg:(float)x image:(UIImageView*)img{
    if(x> img.frame.origin.x + img.frame.size.width/2){
        [img setImage:[UIImage imageNamed:@"review_starSel"]];
        return 2;
    }else if(x> img.frame.origin.x){
        [img setImage:[UIImage imageNamed:@"review_starHalf"]];
        return 1;
    }else{
        [img setImage:[UIImage imageNamed:@"review_starNor"]];
        return 0;
    }
}

-(void)setImageAnimation:(UIView *)v{
    CGRect rec = v.frame;
    [UIView animateWithDuration:0.1 animations:^{
        v.frame = CGRectMake(v.frame.origin.x, v.frame.origin.y -3, v.frame.size.width, v.frame.size.height);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            v.frame = rec;
        } completion:^(BOOL finished) {
            v.frame = rec;
        }];
    }];
}



@end
