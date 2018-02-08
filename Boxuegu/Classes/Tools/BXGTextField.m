//
//  BXGTextField.m
//  Boxuegu
//
//  Created by apple on 2017/12/26.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGTextField.h"

@implementation BXGTextField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        self.backgroundColor = [UIColor colorWithHex:0xFFFFFF];
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"请输入要搜索的内容" attributes:
                                          @{NSForegroundColorAttributeName:
                                                [UIColor colorWithHex:0x999999],
                                            NSFontAttributeName:[UIFont bxg_fontRegularWithSize:13]
                                            }];
        self.attributedPlaceholder = attrString;
        [self setFont:[UIFont bxg_fontRegularWithSize:13]];
        self.textColor = [UIColor colorWithHex:0x333333];
        self.returnKeyType = UIReturnKeySearch;
        self.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.textAlignment = NSTextAlignmentLeft;
        self.layer.cornerRadius = 2;
        self.layer.masksToBounds = YES;        
    }
    return self;
}

- (CGRect)placeholderRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 5, 0);
}

@end
