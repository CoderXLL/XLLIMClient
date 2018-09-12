//
//  XLLAttributesView.h
//  XLLWriterTest
//
//  Created by liuzhangyong on 2018/7/10.
//  Copyright © 2018年 liuzhangyong. All rights reserved.
//

#import "SJAttributedView.h"
#import "SJNoteInputView.h"
#import "SJAttachment.h"

@interface SJAttributedView () <UITextViewDelegate>
{
    //键盘高度
    CGFloat _keyBoardHeight;
    //临时底部间距
    CGFloat _tempBottomInset;
    //上一个光标范围
    NSRange _lastSelectedRange;
}

@end

@implementation SJAttributedView

#pragma mark - life cycle
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setupBase];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        [self setupBase];
    }
    return self;
}

- (void)setupBase
{
    self.autocorrectionType = UITextAutocorrectionTypeNo;
    self.spellCheckingType = UITextSpellCheckingTypeNo;
    self.alwaysBounceVertical = YES;
    self.scrollEnabled = NO;
    self.textContainerInset = UIEdgeInsetsMake(kSJMargin, 0, kSJMargin, 0);
    self.delegate = self;
    self.contentMode = UIViewContentModeScaleAspectFill;
    self.clipsToBounds = YES;
    UIButton *inputView = [UIButton buttonWithType:UIButtonTypeCustom];
    inputView.frame = CGRectMake(0, 0, kScreenWidth, 44.0);
    [inputView setTitle:@"收起键盘" forState:UIControlStateNormal];
    [inputView setTitleColor:[UIColor colorWithHexString:@"2B3248" alpha:1] forState:UIControlStateNormal];
    inputView.backgroundColor = [UIColor whiteColor];
    [inputView addTarget:self action:@selector(inputViewClick) forControlEvents:UIControlEventTouchUpInside];
    inputView.titleLabel.font = SPFont(15.0);
    inputView.layer.shadowColor = SJ_TITLE_COLOR.CGColor;
    inputView.layer.shadowOffset = CGSizeMake(0, 1);
    inputView.layer.shadowOpacity = 0.1;
    inputView.layer.shadowRadius = 8;
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0, 0, kScreenWidth, 44.0));
    inputView.layer.shadowPath = path;
    CGPathCloseSubpath(path);
    CGPathRelease(path);
    self.inputAccessoryView = inputView;
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)inputViewClick
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

#pragma mark - notification
- (void)keyBoardWillShow:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    CGSize keyBoardSize = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    _keyBoardHeight = keyBoardSize.height;
    CGFloat insetBottom = self.frame.size.height-([UIScreen mainScreen].bounds.size.height-keyBoardSize.height-64);
    if (insetBottom<0)return;
    _tempBottomInset = insetBottom;
    BOOL isScrollEnabled = self.scrollEnabled;
    self.scrollEnabled = YES;
    [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        
        //设置内间距
        UIEdgeInsets insets = self.contentInset;
        insets.bottom = insetBottom;
        self.contentInset = insets;
    } completion:^(BOOL finished) {
        self.scrollEnabled = isScrollEnabled;
    }];
}

- (void)keyBoardWillHide:(NSNotification *)notification
{
    if (_tempBottomInset < 0) return;
    _keyBoardHeight = 0;
    _tempBottomInset = 0;
    [UIView animateWithDuration:.3f delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        
        //设置内间距
        UIEdgeInsets insets = self.contentInset;
        insets.bottom = self->_tempBottomInset;
        self.contentInset = insets;
    } completion:^(BOOL finished) {
        self.scrollEnabled = YES;
    }];
}

#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    return YES;
}

- (void)textViewDidChangeSelection:(UITextView *)textView
{
    if (_lastSelectedRange.location != textView.selectedRange.location)
    {
        _lastSelectedRange = textView.selectedRange;
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    _lastSelectedRange = NSMakeRange(range.location + text.length - range.length, 0);
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    CGFloat maxHeight = MAXFLOAT;
    CGRect frame = textView.frame;
    CGSize constraintSize = CGSizeMake(frame.size.width, MAXFLOAT);
    CGSize size = [textView sizeThatFits:constraintSize];
    if (size.height>frame.size.height) {
        
        if (size.height >= maxHeight)
        {
            size.height = maxHeight;
//            textView.scrollEnabled = YES;  // 允许滚动
        } else {
//            textView.scrollEnabled = NO;    // 不允许滚动
        }
    }
    if (size.height != self.frame.size.height) {
        
        if (self.heightBlock) {
            self.heightBlock(size.height);
        }
        textView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, size.height);
//        //重新设置一波内间距
//        CGFloat insetBottom = self.frame.size.height-([UIScreen mainScreen].bounds.size.height-_keyBoardHeight-64);
//        if (insetBottom<0)return;
//        _tempBottomInset = insetBottom;
//        BOOL isScrollEnabled = self.scrollEnabled;
//        self.scrollEnabled = YES;
//        [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
//
//            //设置内间距
//            UIEdgeInsets insets = self.contentInset;
//            insets.bottom = insetBottom;
//            self.contentInset = insets;
//        } completion:^(BOOL finished) {
//            self.scrollEnabled = isScrollEnabled;
//        }];
    }
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange
{
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (self.attributeDelegate && [self.attributeDelegate respondsToSelector:@selector(didEndEdit:)])
    {
        [self.attributeDelegate didEndEdit:self];
    }
}


#pragma mark - public
- (void)reloadHeight
{
    [self textViewDidChange:self];
}

- (void)addAttributesImage:(UIImage *)image
{
    //随便压缩一波图片
    CGFloat actualWidth = image.size.width*image.scale;
    CGFloat showWidth = CGRectGetWidth(self.bounds)-self.textContainerInset.left-self.textContainerInset.right;
    CGFloat compressionQuality = showWidth / actualWidth;
    if (compressionQuality > 1) {
        compressionQuality = 1;
    }
    NSData *imageData = UIImageJPEGRepresentation(image, compressionQuality);
    UIImage *resultImage = [UIImage imageWithData:imageData];
    SJAttachment *attachment = [self createImageAttachment:resultImage];
    //先本地保存图片
    //进行本地化存储,提交上传时将其清空
    NSString *pathDocuments = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *photoDirectory = [NSString stringWithFormat:@"%@/XLLPhotos", pathDocuments];
    if (![[NSFileManager defaultManager] fileExistsAtPath:photoDirectory])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:photoDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSData *tempImageData = UIImageJPEGRepresentation(image, 1.0);
    NSString *tempPath = [photoDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%zd", random()%10000]];
    while ([[NSFileManager defaultManager] fileExistsAtPath:tempPath]) {
        tempPath = [photoDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%zd", random()%10000]];
    }
    [tempImageData writeToFile:tempPath atomically:YES];
    attachment.localPath = tempPath;
}

- (SJAttachment *)createImageAttachment:(UIImage *)image
{
    //上传图片..
    CGFloat expendWidth = self.frame.size.width-self.textContainerInset.left-self.textContainerInset.right-12.f;
    CGSize expendSize = CGSizeMake(expendWidth, expendWidth*0.5);
    SJAttachment *attachment = [SJAttachment attachmentWithImage:image imageSize:expendSize isNeedCut:YES];
    //1.获取当前插入图片富文本
    NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:attachment];
    //2.初始化一个回车富文本，并将图片富文本放在前面
    NSMutableAttributedString *newAttributedString = [[NSMutableAttributedString alloc] initWithString:@"\n"];
    [newAttributedString insertAttributedString:attachmentString atIndex:0];
    //3.如果当前光标不在第一个地方，并且上个字符不是回车。则在第一个位置添加回车
    if (_lastSelectedRange.location != 0 && ![[self.text substringWithRange:NSMakeRange(_lastSelectedRange.location-1, 1)] isEqualToString:@"\n"])
    {
        [newAttributedString insertAttributedString:[[NSAttributedString alloc] initWithString:@"\n"] atIndex:0];
    }
    //4.给新进富文本添加样式
    [newAttributedString addAttributes:[self getAttributedStyle] range:NSMakeRange(0, newAttributedString.length)];
    //5.放入原有富文本中
    //5.1获取原来的富文本
    NSMutableAttributedString *currentAttributedText = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    //5.2将新进富文本按照光标位置插入进去
    if (!currentAttributedText && _lastSelectedRange.location != 0 && _lastSelectedRange.length != 0) {
        //crash处理
        _lastSelectedRange = NSMakeRange(0, 0);
    }
    [currentAttributedText replaceCharactersInRange:_lastSelectedRange withAttributedString:newAttributedString];
    //6.将新的富文本赋予textView(注意姿势)
    self.allowsEditingTextAttributes = YES;
    self.attributedText = currentAttributedText;
    self.allowsEditingTextAttributes = NO;
    //7.优化点，textView滚至光标位置
    [self scrollRangeToVisible:_lastSelectedRange];
    //8.激活第一相应
    [self becomeFirstResponder];
    //9.自适应高度处理
    [self textViewDidChange:self];
    return attachment;
}

#pragma mark - private
//富文本样式
- (NSDictionary *)getAttributedStyle
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentLeft;
    paragraphStyle.lineSpacing = 0.0f;
    paragraphStyle.paragraphSpacing = 10.f;
    
    return  @{
              NSParagraphStyleAttributeName:paragraphStyle,
              NSFontAttributeName:[UIFont systemFontOfSize:16.0]
              };
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end


