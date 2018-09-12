//
//  SJHobbyCell.m
//  BirdDriver
//
//  Created by 肖乐 on 2018/6/29.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJHobbyCell.h"

@interface SJHobbyCell ()

@property (weak, nonatomic) IBOutlet UILabel *hobbyLabel;

@end

@implementation SJHobbyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
//    self.hobbyLabel.layer.cornerRadius = self.hobbyLabel.height*0.5;
    self.hobbyLabel.layer.borderColor = [UIColor colorWithHexString:@"BDBDBD" alpha:1].CGColor;
    self.hobbyLabel.layer.borderWidth = 1.0;
//    self.hobbyLabel.clipsToBounds = YES;
}

- (void)setHobby:(NSString *)hobby
{
    _hobby = [hobby copy];
    self.hobbyLabel.text = hobby;
}

@end
