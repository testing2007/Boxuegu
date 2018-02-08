//
//  ImageTextLayoutView.h
//  ImageTextLayoutButtonPrj
//
//  Created by apple on 2017/10/16.
//  Copyright © 2017年 itheima. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum _ImageTextLayout {
    ImageTextLayout_Right_Left,
    ImageTextLayout_Left_Right,
    ImageTextLayout_Up_Down,
    ImageTextLayout_Down_Up,
} ImageTextLayout;

typedef void (^TapBlock)(void);

@interface ImageTextLayoutView : UIView

-(instancetype)initImage:(UIImage*)image
                andLabel:(UILabel*)label
      andImageTextLayout:(ImageTextLayout)layout
             andTapBlock:(TapBlock)tapBlock;

@property(nonatomic, assign) ImageTextLayout layout;
@property(nonatomic, copy) TapBlock tapBlock;
@property(nonatomic, assign) NSInteger midSpace;

- (void)setImage:(UIImage*)image;
- (void)setText:(NSString*)text;
- (void)setTextColor:(UIColor*)textColor;

@end
