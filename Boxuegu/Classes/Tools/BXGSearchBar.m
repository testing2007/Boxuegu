//
//  BXGSearchBar.m
//  Boxuegu
//
//  Created by apple on 2017/12/27.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGSearchBar.h"

@implementation BXGSearchBar

- (instancetype)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
        self.hasCentredPlaceholder = NO;
    }
    
    return self;
}

// ------------------------------------------------------------------------------------------
#pragma mark - Methods
// ------------------------------------------------------------------------------------------
- (void)setHasCentredPlaceholder:(BOOL)hasCentredPlaceholder
{
    _hasCentredPlaceholder = hasCentredPlaceholder;
    
    SEL centerSelector = NSSelectorFromString([NSString stringWithFormat:@"%@%@", @"setCenter", @"Placeholder:"]);
    if ([self respondsToSelector:centerSelector])
    {
        NSMethodSignature *signature = [[UISearchBar class] instanceMethodSignatureForSelector:centerSelector];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        [invocation setTarget:self];
        [invocation setSelector:centerSelector];
        [invocation setArgument:&_hasCentredPlaceholder atIndex:2];
        [invocation invoke];
    }
    
}

-(CGSize)intrinsicContentSize
{
    return UILayoutFittingExpandedSize;
}

- (void)setContentInset:(UIEdgeInsets)contentInset {
    [self layoutSubviews];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    for (UIView *subView in self.subviews[0].subviews) {
        if ([subView isKindOfClass:[UIImageView class]]) {
            //移除UISearchBarBackground
            [subView removeFromSuperview];
        }
        
        if ([subView isKindOfClass:[UITextField class]]) {
            
            UITextField *textField = (UITextField*)subView;
            NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"请输入要搜索的内容" attributes:
                                              @{NSForegroundColorAttributeName:
                                                    [UIColor colorWithHex:0xFFFFFF],
                                                NSFontAttributeName:[UIFont bxg_fontRegularWithSize:13]
                                                }];
            textField.attributedPlaceholder = attrString;
            [textField setBackgroundColor:[UIColor colorWithHex:0xffffff alpha:0.2]];
            textField.textColor = [UIColor whiteColor];
            
            subView.frame = CGRectMake(8, 9, self.bounds.size.width-16, 28);
            subView.layer.cornerRadius = 14;
            subView.layer.masksToBounds = YES;
        }
        
    }
}

@end
