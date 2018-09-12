//
//  SJNoDataFootView.m
//  BirdDriver
//
//  Created by 宋明月 on 2018/5/29.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJNoDataFootView.h"

@interface SJNoDataFootView ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnTopCons;

@end

@implementation SJNoDataFootView

+ (instancetype)createCellWithXib{
    return [[[NSBundle mainBundle] loadNibNamed:@"SJNoDataFootView" owner:nil options:nil] objectAtIndex:0];
}

-(void)awakeFromNib{
    [super awakeFromNib];
    self.buttonView.hidden = YES;
    self.describeLabel.hidden = YES;
}

- (void)setExceptionStyle:(SJExceptionStyle)exceptionStyle
{
    _exceptionStyle = exceptionStyle;
    switch (exceptionStyle) {
        case SJExceptionStyleNoData:
        {
            self.buttonView.hidden = YES;
            self.describeLabel.hidden = NO;
            self.imageView.image = [UIImage imageNamed:@"search_noData"];
        }
            break;
        case SJExceptionStyleUnLogin:
        {
            self.buttonView.hidden = NO;
            self.describeLabel.hidden = YES;
            self.describeLabel.text = @"空空如也";
            self.imageView.image = [UIImage imageNamed:@"mine_icon"];
            self.buttonView.customBtnTitle = @"登录／注册";
            self.buttonView.customBtnEnable = YES;
            self.buttonView.customBtnGradientColors = @[HEXCOLOR(@"303850"),HEXCOLOR(@"6E7EAF")];
            self.buttonView.customBtnTitleColor = HEXCOLOR(@"FFBB04");
            self.buttonView.cornerRadius = 20.0f;
        }
            break;
        case SJExceptionStyleNoNet:
        {
            self.buttonView.hidden = NO;
            self.describeLabel.hidden = NO;
            self.describeLabel.font = SPBFont(18.0);
            self.describeLabel.text = @"网络开小差了...";
            self.imageView.image = [UIImage imageNamed:@"noNet"];
            self.buttonView.customBtnTitle = @"点击刷新";
            self.buttonView.customBtnEnable = YES;
            self.buttonView.customBtnGradientColors = @[HEXCOLOR(@"303850"),HEXCOLOR(@"6E7EAF")];
            self.buttonView.customBtnTitleColor = HEXCOLOR(@"FFBB04");
            self.buttonView.cornerRadius = 20.0f;
            self.btnTopCons.constant = 65;
        }
            
        default:
            break;
    }
}

-(void)reloadView{
    if (self.isShow) {
        self.buttonView.hidden = NO;
        self.describeLabel.hidden = YES;
    } else {
        self.buttonView.hidden = YES;
        self.describeLabel.hidden = NO;
    }
    self.buttonView.customBtnTitle = @"登录／注册";
    self.buttonView.customBtnEnable = YES;
    self.buttonView.customBtnGradientColors = @[HEXCOLOR(@"303850"),HEXCOLOR(@"6E7EAF")];
    self.buttonView.customBtnTitleColor = HEXCOLOR(@"FFBB04");
    self.buttonView.cornerRadius = 20.0f;
}


@end
