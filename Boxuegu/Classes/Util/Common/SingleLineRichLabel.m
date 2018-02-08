//
//  SingleLineRichLabel.m
//  ImageTextViewPrj
//
//  Created by apple on 2017/8/14.
//  Copyright © 2017年 itheima. All rights reserved.
//

#import "SingleLineRichLabel.h"
#import "TextAttachment.h"

typedef enum _SingleLineRichLabelType
{
    SINGLE_LINE_RICHLABEL_IMAGE_TEXT_INTERACTIVE_TYPE,
    SINGLE_LINE_RICHLABEL_IMAGE_TEXT_NONINTERACTIVE_TYPE,
    SINGLE_LINE_RICHLABEL_IMAGE_INTERACTIVE_TYPE,
}SingleLineRichLabelType;


@interface SingleLineRichLabel()
@property(nonatomic, strong) UIImage *activeImage;
@property(nonatomic, strong) UIImage *inactiveImage;
@property(nonatomic, assign) BOOL bActive;
@property(nonatomic, assign) SingleLineRichLabelType type;
@property(nonatomic, copy) ActiveBlock activeBlock;
@property(nonatomic, copy) InactiveBlock inactiveBlock;
@end

@implementation SingleLineRichLabel

// 实现图文混排的方法
+(instancetype) createRichLabelActiveImage:(UIImage *)activeImage
                  inactiveImage:(UIImage *)inactiveImage
                          value:(NSInteger)value
                        bActive:(BOOL)bActive
                    activeBlock:(ActiveBlock)activeBlock
                  inactiveBlock:(InactiveBlock)inactiveBlock

{
    assert(activeImage!=nil && inactiveImage!=nil && value>=0);
    
    SingleLineRichLabel *lable = [SingleLineRichLabel new];
    if(lable)
    {
        [lable _setRichLabelActiveImage:activeImage
                          inactiveImage:inactiveImage
                                  value:value
                                bActive:bActive
                            activeBlock:activeBlock
                          inactiveBlock:inactiveBlock
                                   type:SINGLE_LINE_RICHLABEL_IMAGE_TEXT_INTERACTIVE_TYPE];
    }
    
    return lable;
}

+(instancetype) createRichLabelImage:(UIImage *)image
                               value:(NSInteger)value
{
    assert(image!=nil && value>=0);
    SingleLineRichLabel *lable = [SingleLineRichLabel new];
    if(lable)
    {
        [lable _setRichLabelActiveImage:image
                          inactiveImage:image
                                  value:value
                                bActive:NO
                            activeBlock:nil
                          inactiveBlock:nil
                                   type:SINGLE_LINE_RICHLABEL_IMAGE_TEXT_NONINTERACTIVE_TYPE];
    }
    
    return lable;
}

+(instancetype) createRichLabelActiveImage:(UIImage *)activeImage
                             inactiveImage:(UIImage *)inactiveImage
                                   bActive:(BOOL)bActive
                               activeBlock:(ActiveBlock)activeBlock
                             inactiveBlock:(InactiveBlock)inactiveBlock
{
    assert(activeImage!=nil && inactiveImage!=nil);
    
    SingleLineRichLabel *lable = [SingleLineRichLabel new];
    if(lable)
    {
        [lable _setRichLabelActiveImage:activeImage
                          inactiveImage:inactiveImage
                                  value:0
                                bActive:bActive
                            activeBlock:activeBlock
                          inactiveBlock:inactiveBlock
                                   type:SINGLE_LINE_RICHLABEL_IMAGE_INTERACTIVE_TYPE];
    }
    
    return lable;
}

-(void) _setRichLabelActiveImage:(UIImage *)activeImage
                  inactiveImage:(UIImage *)inactiveImage
                          value:(NSInteger)value
                        bActive:(BOOL)bActive
                    activeBlock:(ActiveBlock)activeBlock
                  inactiveBlock:(InactiveBlock)inactiveBlock
                        type:(SingleLineRichLabelType)type
{
#ifdef DEBUG
//    self.layer.borderWidth = 1;
//    self.layer.borderColor = [UIColor blackColor].CGColor;
#endif
    self.value = value;
    self.activeImage = activeImage;
    self.inactiveImage = inactiveImage;
    self.bActive = bActive;
    self.type = type;
    self.activeBlock = activeBlock;
    self.inactiveBlock = inactiveBlock;
    
    NSString *valueString = nil;
    if(type==SINGLE_LINE_RICHLABEL_IMAGE_TEXT_NONINTERACTIVE_TYPE)
    {
        self.userInteractionEnabled = NO;
    }
    else
    {
        self.userInteractionEnabled = YES;
    }
    if(type==SINGLE_LINE_RICHLABEL_IMAGE_TEXT_NONINTERACTIVE_TYPE ||
       type ==SINGLE_LINE_RICHLABEL_IMAGE_INTERACTIVE_TYPE)
    {
        valueString = nil;
    }
    else
    {
        valueString = [NSString stringWithFormat:@"%ld", self.value];
    }
    
    NSAttributedString *attributeString = [self _createAttrStringWithText:valueString
                                                                     image:bActive?activeImage:inactiveImage];
    self.attributedText = attributeString;
    self.adjustsFontSizeToFitWidth = YES;
    self.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    self.numberOfLines = 1;
    
}


-(void) setRichLabelActiveImage:(UIImage *)activeImage
                  inactiveImage:(UIImage *)inactiveImage
                          value:(NSInteger)value
                        bActive:(BOOL)bActive
                    activeBlock:(ActiveBlock)activeBlock
                  inactiveBlock:(InactiveBlock)inactiveBlock
{
    return [self _setRichLabelActiveImage:activeImage
                            inactiveImage:inactiveImage
                                    value:value
                                  bActive:bActive
                              activeBlock:activeBlock
                            inactiveBlock:inactiveBlock
                                     type:SINGLE_LINE_RICHLABEL_IMAGE_TEXT_INTERACTIVE_TYPE];
}

-(void) setRichLabelImage:(UIImage *)activeImage
                    value:(NSInteger)value
{
    return [self _setRichLabelActiveImage:activeImage
                            inactiveImage:activeImage
                                   value:0
                                 bActive:NO
                             activeBlock:nil
                           inactiveBlock:nil
                                    type:SINGLE_LINE_RICHLABEL_IMAGE_TEXT_NONINTERACTIVE_TYPE];
}

-(void) setRichLabelActiveImage:(UIImage *)activeImage
                  inactiveImage:(UIImage *)inactiveImage
                        bActive:(BOOL)bActive
                    activeBlock:(ActiveBlock)activeBlock
                  inactiveBlock:(InactiveBlock)inactiveBlock
{
    return [self _setRichLabelActiveImage:activeImage
                            inactiveImage:inactiveImage
                                    value:0
                                  bActive:bActive
                              activeBlock:activeBlock
                            inactiveBlock:inactiveBlock
                                     type:SINGLE_LINE_RICHLABEL_IMAGE_INTERACTIVE_TYPE];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if(_type == SINGLE_LINE_RICHLABEL_IMAGE_TEXT_INTERACTIVE_TYPE)
    {
        if(_bActive)
        {
            self.value = --self.value<0 ? 0 : self.value;
            _bActive = !_bActive;
            self.attributedText =  [self _createAttrStringWithText:[NSString stringWithFormat:@"%ld", self.value]
                                                             image:_bActive?_activeImage:_inactiveImage];
            self.inactiveBlock(self, ^(BOOL bSuccess){
                if(bSuccess)
                {
                }
            });
        }
        else
        {
            self.value++;
            _bActive = !_bActive;
            self.attributedText =  [self _createAttrStringWithText:[NSString stringWithFormat:@"%ld", self.value]
                                                             image:_bActive?_activeImage:_inactiveImage];
            self.activeBlock(self, ^(BOOL bSuccess){
                if(bSuccess)
                {
                }
            });
        }
    }
    else if(_type == SINGLE_LINE_RICHLABEL_IMAGE_INTERACTIVE_TYPE)
    {
        if(_bActive)
        {
            _bActive = !_bActive;
            self.attributedText =  [self _createAttrStringWithText:nil
                                                             image:_bActive?_activeImage:_inactiveImage];
            self.inactiveBlock(self, ^(BOOL bSuccess){
                if(bSuccess)
                {
                }
            });
        }
        else
        {
            _bActive = !_bActive;
            self.attributedText =  [self _createAttrStringWithText:nil
                                                             image:_bActive?_activeImage:_inactiveImage];
            self.activeBlock(self, ^(BOOL bSuccess){
                if(bSuccess)
                {
                }
            });
        }
    }
    else
    {
        //do nothing
    }
    
}

// 实现图文混排的方法
- (NSAttributedString *) _createAttrStringWithText:(NSString *)text image:(UIImage *) image
{
    NSMutableAttributedString *mutableAttr = [[NSMutableAttributedString alloc] init];
    
    // 将图片、文字拼接
    if(image !=nil)
    {
        [mutableAttr appendAttributedString:[self _createAttrStringImage:image]];
    }
    if(text != nil)
    {
        [mutableAttr appendAttributedString:[self _createAttrStringText:
                                             image!=nil ? [NSString stringWithFormat:@" %@", text] : text]];
    }

    return [mutableAttr copy];
}

- (NSAttributedString *) _createAttrStringText:(NSString *)text
{
    // 文字的富文本
    NSMutableAttributedString *textAttr = [[NSMutableAttributedString alloc] initWithString:text];
    NSDictionary *paramas = @{NSFontAttributeName:[UIFont bxg_fontRegularWithSize:13],
                              NSForegroundColorAttributeName:[UIColor colorWithHex:0x666666],
                              NSBaselineOffsetAttributeName:@(0)
                              };
    [textAttr addAttributes:paramas range:NSMakeRange(0, text.length)];
    return textAttr;
}

- (NSAttributedString *) _createAttrStringImage:(UIImage *)image
{
    // NSTextAttachment可以将图片转换为富文本内容
    TextAttachment *attachment = [[TextAttachment alloc] init];
    attachment.image = image;
    NSAttributedString *imageAttr = [NSAttributedString attributedStringWithAttachment:attachment];
    return imageAttr;
}

@end
