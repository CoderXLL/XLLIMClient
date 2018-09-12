//
//  GBTagListView.m
//  升级版流式标签支持点击
//
//  Created by 张国兵 on 15/8/16.
//  Copyright (c) 2015年 zhangguobing. All rights reserved.
//

#import "GBTagListView.h"
#define HORIZONTAL_PADDING 7.0f
#define VERTICAL_PADDING   3.0f
#define LABEL_MARGIN       10.0f
#define BOTTOM_MARGIN      10.0f
#define KBtnTag            1000
#define R_G_B_16(rgbValue)\
\
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 \
alpha:1.0]

@implementation GBTagListView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        totalHeight=0;
        self.frame=frame;
        
        _tagArr=[[NSMutableArray alloc]init];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        totalHeight=0;
        _tagArr=[[NSMutableArray alloc]init];
        if (self.frame.size.width > kScreenWidth - 30) {
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, kScreenWidth - 30, self.frame.size.height);
        }
    }
    return self;
}

-(void)setTagWithTagArray:(NSArray*)arr{
    previousFrame = CGRectZero;
    totalHeight = 0;
    [_tagArr addObjectsFromArray:arr];
    for (UIButton *btn  in self.subviews) {
        [btn removeFromSuperview];
    }
    __weak typeof(self) weakSelf = self;
    [arr enumerateObjectsUsingBlock:^(NSString*str, NSUInteger idx, BOOL *stop) {
        UIButton*tagBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        tagBtn.frame=CGRectZero;
        if(weakSelf.signalTagColor){
            //可以单一设置tag的颜色
            tagBtn.backgroundColor=weakSelf.signalTagColor;
        }else{
            //tag颜色多样
            tagBtn.backgroundColor=[UIColor colorWithRed:random()%255/255.0 green:random()%255/255.0 blue:random()%255/255.0 alpha:1];
        }
        if(weakSelf.canTouch){
            tagBtn.userInteractionEnabled=YES;
            
        }else{
            tagBtn.userInteractionEnabled=NO;
        }
        [tagBtn setTitleColor:self.signalTagTextColor?self.signalTagTextColor:SJ_TITLE_COLOR forState:UIControlStateNormal];
        [tagBtn setTitleColor:self.signalTagTextColor?self.signalTagTextColor:SJ_TITLE_COLOR forState:UIControlStateSelected];
        tagBtn.titleLabel.font=[UIFont systemFontOfSize:11];
        [tagBtn addTarget:self action:@selector(tagBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [tagBtn setTitle:str forState:UIControlStateNormal];
        tagBtn.tag=KBtnTag+idx;
        tagBtn.layer.borderColor=self.signalTagTextColor?self.signalTagTextColor.CGColor:HEXCOLOR(@"939FC7").CGColor;
        tagBtn.layer.borderWidth=0.5;
        tagBtn.clipsToBounds=YES;
        NSDictionary *attrs = @{NSFontAttributeName : [UIFont systemFontOfSize:11]};
        CGSize Size_str=[str sizeWithAttributes:attrs];
        Size_str.width += HORIZONTAL_PADDING*3;
        if (self.signalHeight > 0)
        {
            Size_str.height = self.signalHeight;
        } else {
            Size_str.height += VERTICAL_PADDING*4;
        }
        tagBtn.layer.cornerRadius=self.signalCornerRadius>0?self.signalCornerRadius:4;
        
        CGRect newRect = CGRectZero;
        
        if (self->previousFrame.origin.x + previousFrame.size.width + Size_str.width + LABEL_MARGIN > self.bounds.size.width) {
            
            newRect.origin = CGPointMake(10, previousFrame.origin.y + Size_str.height + BOTTOM_MARGIN);
            totalHeight +=Size_str.height + BOTTOM_MARGIN;
        }
        else {
            newRect.origin = CGPointMake(previousFrame.origin.x + previousFrame.size.width + LABEL_MARGIN, previousFrame.origin.y);
            
        }
        newRect.size = Size_str;
        [tagBtn setFrame:newRect];
        previousFrame=tagBtn.frame;
        [self setHight:self andHight:totalHeight+Size_str.height + BOTTOM_MARGIN];
        [self addSubview:tagBtn];
        
        UIImageView *delete = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hobbies_delete"]];
        delete.userInteractionEnabled = NO;
        [self addSubview:delete];
        [delete mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(tagBtn);
            make.bottom.equalTo(tagBtn.mas_top).with.offset(6);
        }];
        delete.hidden = weakSelf.deleteHide;
    }
     
     ];
    if(_GBbackgroundColor){
        
        self.backgroundColor=_GBbackgroundColor;
        
    }else{
        
        self.backgroundColor=[UIColor whiteColor];
        
    }
}

#pragma mark-改变控件高度
- (void)setHight:(UIView *)view andHight:(CGFloat)hight
{
    CGRect tempFrame = view.frame;
    tempFrame.size.height = hight;
    view.frame = tempFrame;
}
-(void)tagBtnClick:(UIButton*)button{
    button.selected=!button.selected;
    if(button.selected==YES){
        button.backgroundColor=[UIColor clearColor];
    }else if (button.selected==NO){
        button.backgroundColor=[UIColor clearColor];
    }
    [self didSelectItems:button.tag];
}

-(void)didSelectItems:(NSInteger)tag{
    NSMutableArray*arr=[[NSMutableArray alloc]init];
    NSInteger index = tag-KBtnTag;
    [arr addObject:_tagArr[tag-KBtnTag]];
    self.didselectItemBlock(arr,index);
    
}

+ (CGFloat)calculateTagHeight:(NSMutableArray *)tagArr cellWidth:(CGFloat)cellWidth
{
    __block CGRect lastFrame = CGRectZero;
    __block CGFloat tempHeight = 0;
    __block CGFloat resultHeight = 0;
    [tagArr enumerateObjectsUsingBlock:^(NSString *str, NSUInteger idx, BOOL *stop) {

        NSDictionary *attrs = @{NSFontAttributeName : SPFont(11)};
        CGSize Size_str = [str sizeWithAttributes:attrs];
        Size_str.width += HORIZONTAL_PADDING*3;
        Size_str.height += VERTICAL_PADDING*4;
        
        CGRect newRect = CGRectZero;
        if (lastFrame.origin.x + lastFrame.size.width + Size_str.width + LABEL_MARGIN > cellWidth) {
            
            newRect.origin = CGPointMake(10, lastFrame.origin.y + Size_str.height + BOTTOM_MARGIN);
            tempHeight +=Size_str.height + BOTTOM_MARGIN;
        } else {
            newRect.origin = CGPointMake(lastFrame.origin.x + lastFrame.size.width + LABEL_MARGIN, lastFrame.origin.y);
        }
        newRect.size = Size_str;
        lastFrame=newRect;
        resultHeight = tempHeight+Size_str.height+BOTTOM_MARGIN;
    }];
    return resultHeight;
}

@end
