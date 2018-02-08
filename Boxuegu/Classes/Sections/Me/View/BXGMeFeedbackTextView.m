//
//  BXGMeFeedbackTextView.m
//  Boxuegu
//
//  Created by HM on 2017/5/15.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGMeFeedbackTextView.h"

@implementation BXGMeFeedbackTextView

- (CGRect)caretRectForPosition:(UITextPosition *)position
{
    CGRect originalRect = [super caretRectForPosition:position];
    
    originalRect.size.height = 20;
    
    return originalRect;
}

@end
