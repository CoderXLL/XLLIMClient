//
//  SJNoviceHobbiesCell.m
//  BirdDriver
//
//  Created by Soul on 2018/8/24.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJNoviceHobbiesCell.h"

@implementation SJNoviceHobbiesModel

@end

@implementation SJNoviceHobbiesCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.lbl_hobby.layer.borderColor = SJ_LINE_COLOR.CGColor;
    self.lbl_hobby.layer.borderWidth = 1.0f;
    self.lbl_hobby.layer.cornerRadius = 4.0f;
}

- (void)setModel:(SJNoviceHobbiesModel *)model{
    _model = model;
    
    if(model.title){
        self.lbl_hobby.text = [NSString stringWithFormat:@" %@  ",model.title];
    }
    
    if (model.canBeDeleted) {
        [self.btn_del setHidden:NO];
    }else{
        [self.btn_del setHidden:YES];
    }
    
}

@end
