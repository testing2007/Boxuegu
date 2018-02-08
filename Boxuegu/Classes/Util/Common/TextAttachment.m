//
//  TextAttachment.m
//  Boxuegu
//
//  Created by apple on 2017/8/22.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "TextAttachment.h"

@implementation TextAttachment

- (CGRect)attachmentBoundsForTextContainer:(NSTextContainer *)textContainer proposedLineFragment:(CGRect)lineFrag glyphPosition:(CGPoint)position characterIndex:(NSUInteger)charIndex {
    CGRect bounds;
    bounds.origin = CGPointMake(0, -3);
    bounds.size = self.image.size;
    return bounds;
}
@end
