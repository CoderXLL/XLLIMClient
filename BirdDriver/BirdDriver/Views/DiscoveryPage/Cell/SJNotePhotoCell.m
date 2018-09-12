//
//  SJNotePhotoCell.m
//  BirdDriver
//
//  Created by 肖乐 on 2018/5/22.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJNotePhotoCell.h"
#import "SJPhotoModel.h"

@interface SJNotePhotoCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *removeBtn;

@end

@implementation SJNotePhotoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(id)model
{
    _model = model;
    if (model) {
        
        if ([model isKindOfClass:[SJPhotoModel class]]) {
            
            [self setPhotoModel:model];
        } else if ([model isKindOfClass:[NSString class]]) {
            
            NSString *img = (NSString *)model;
            [self.imageView sd_setImageWithURL:img.mj_url];
        }
        self.removeBtn.hidden = NO;
    } else {
        self.imageView.image = [UIImage imageNamed:@"discovery_addPict"];
        self.removeBtn.hidden = YES;
    }
}

- (void)setPhotoModel:(SJPhotoModel *)photoModel
{
    self.imageView.image = photoModel.thumbnailImage;
}

- (IBAction)removeBtnClick:(id)sender {
    
    if (self.removeBlock)
    {
        self.removeBlock(self.model);
    }
}


@end
