//
//  SJAttributesCell.m
//  BirdDriver
//
//  Created by liuzhangyong on 2018/7/13.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJAttributesCell.h"
#import "SJAttributedView.h"
#import "SJBuildNoteModel.h"
#import "SJHtmlTransfer.h"
#import "SJPhotoModel.h"

@interface SJAttributesCell () <SJAttributedViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *coverView;
@property (weak, nonatomic) IBOutlet SJAttributedView *attributedView;
@property (nonatomic, weak) UITableView *tableView;

@end

@implementation SJAttributesCell

+ (instancetype)xibCell:(UITableView *)tableView
{
    SJAttributesCell *cell = [super xibCell:tableView];
    cell.tableView = tableView;
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.coverView.layer.cornerRadius = 2.0;
    self.coverView.clipsToBounds = YES;
    self.attributedView.attributeDelegate = self;
    self.attributedView.scrollEnabled = NO;
}

- (void)setBuildNoteModel:(SJBuildNoteModel *)buildNoteModel
{
    _buildNoteModel = buildNoteModel;
    
    NSMutableAttributedString *attributedM = [[NSMutableAttributedString alloc] initWithAttributedString:buildNoteModel.note_attributedText];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentLeft;
    paragraphStyle.lineSpacing = 0.0f;
    paragraphStyle.paragraphSpacing = 10.f;
    
    [attributedM addAttributes:@{NSParagraphStyleAttributeName:paragraphStyle, NSFontAttributeName:SPFont(14.0)} range:NSMakeRange(0, buildNoteModel.note_attributedText.length)];
    self.attributedView.attributedText = attributedM;
    
    if (buildNoteModel.isNeedReload)
    {
        buildNoteModel.isNeedReload = NO;
        [self didChangeEdit:self.attributedView];
    }
}

- (void)insertPhotoModel:(SJPhotoModel *)photoModel
{
    [self.attributedView addAttributesImage:photoModel.resultImage];
}

#pragma mark - SJAttributedViewDelegate
- (void)didEndEdit:(SJAttributedView *)attributedView
{
    self.buildNoteModel.note_attributedText = attributedView.attributedText;
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

- (void)didChangeEdit:(SJAttributedView *)attributedView
{
    CGFloat newHeight = [self.attributedView sizeThatFits:CGSizeMake(attributedView.width, MAXFLOAT)].height+15+20+45+10;
    id <SJAttributesCellDelegate> delegate = (id<SJAttributesCellDelegate>)self.tableView.delegate;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:self];
    CGFloat oldHeight = [delegate tableView:self.tableView heightForRowAtIndexPath:indexPath];
    if (fabs(newHeight - oldHeight) > 0.1)
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(tableView:updatedHeight:atIndexPath:)])
        {
            [delegate tableView:self.tableView updatedHeight:newHeight atIndexPath:indexPath];
        }
        [self.tableView beginUpdates];
        [self.tableView endUpdates];
    }
}

- (IBAction)addPhotoBtnClick:(id)sender {
    if (self.addBlock) {
        self.addBlock();
    }
}


@end
