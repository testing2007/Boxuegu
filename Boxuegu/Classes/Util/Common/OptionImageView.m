//
//  OptionImageView.m
//  Boxuegu
//
//  Created by apple on 2017/10/24.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "OptionImageView.h"

@interface OptionImageView()

@end

@implementation OptionImageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initIsSel:(BOOL)isSel andSelBlock:(SelBlockType)selBlock andUnselBlock:(UnselBlockType)unselBlock {
//    self = [super initWithImage:[UIImage imageNamed:@"多选-未选中"] highlightedImage:[UIImage imageNamed:@"多选-选中"]];
    self = [super init];
    if(self) {
        _isSel = isSel;
        self.selBlock = selBlock;
        self.unselBlock = unselBlock;
        
//        UITapGestureRecognizer *tapGesture = [UITapGestureRecognizer new];
//        tapGesture.numberOfTapsRequired = 1;
//        [tapGesture addTarget:self action:@selector(tapImage:)];
//        [self addGestureRecognizer:tapGesture];
    }
    return self;
}

- (void)tapImage:(UITapGestureRecognizer*)recognizer {
    [self setIsSel:!_isSel];
}

- (void)setIsSel:(BOOL)isSel {
    _isSel = isSel;
    if(_isSel) {
        self.image = [UIImage imageNamed:@"多选-选中"];
        if(_selBlock) {
            _selBlock();
        }
    } else {
        self.image = [UIImage imageNamed:@"多选-未选中"];
        if(_unselBlock) {
            _unselBlock();
        }
    }
}

@end
