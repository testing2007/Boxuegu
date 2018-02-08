//
//  RWResponseView.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/7/3.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "RWResponseView.h"

@interface RWResponseView() <UIGestureRecognizerDelegate>
@end

@implementation RWResponseView

- (instancetype)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    if(self) {
    
//        [self addTarget:self action:@selector(touchupInside:) forControlEvents:UIControlEventTouchUpInside];
//        [self addTarget:self action:@selector(touchupInside:) forControlEvents:UIControlEventTouchUpOutside];
//        [self addTarget:self action:@selector(touchupInside:) forControlEvents:UIControlEventTouchUpOutside];
    }
    return self;
}
- (void)touchupInside:(UIControl *)sender {

    if(self.touchesEndedBlock){
        
        self.touchesEndedBlock();
    }
}


- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    UIView *view = [super hitTest:point withEvent:event];
    if(self.responseBlock) {
        
        self.responseBlock(view);
    }
    if(self != view){
        
    }
    
    return view;
}

//触摸开始
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [super touchesBegan:touches withEvent:event];
    //获取触摸开始的坐标
    UITouch *touch = [touches anyObject];
    CGPoint currentP = [touch locationInView:self];
    if(self.touchBeganBlock){
        
        self.touchBeganBlock(currentP);
    }
}

// 触摸结束
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [super touchesEnded:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    CGPoint currentP = [touch locationInView:self];
    if(self.touchesEndedBlock){
        
        self.touchesEndedBlock(currentP);
    }
}

//移动
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint currentP = [touch locationInView:self];
    if(self.touchesMovedBlock){
        
        self.touchesMovedBlock(currentP);
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [super touchesCancelled:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    CGPoint currentP = [touch locationInView:self];
    if(self.touchesEndedBlock){
        
        self.touchesEndedBlock(currentP);
    }
}

//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer;{}
//
//// called when the recognition of one of gestureRecognizer or otherGestureRecognizer would be blocked by the other
//// return YES to allow both to recognize simultaneously. the default implementation returns NO (by default no two gestures can be recognized simultaneously)
////
//// note: returning YES is guaranteed to allow simultaneous recognition. returning NO is not guaranteed to prevent simultaneous recognition, as the other gesture's delegate may return YES
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer;
//
//// called once per attempt to recognize, so failure requirements can be determined lazily and may be set up between recognizers across view hierarchies
//// return YES to set up a dynamic failure requirement between gestureRecognizer and otherGestureRecognizer
////
//// note: returning YES is guaranteed to set up the failure requirement. returning NO does not guarantee that there will not be a failure requirement as the other gesture's counterpart delegate or subclass methods may return YES
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer NS_AVAILABLE_IOS(7_0);
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer NS_AVAILABLE_IOS(7_0);
//
//// called before touchesBegan:withEvent: is called on the gesture recognizer for a new touch. return NO to prevent the gesture recognizer from seeing this touch
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch; {

    return [gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]];

}

// called before pressesBegan:withEvent: is called on the gesture recognizer for a new press. return NO to prevent the gesture recognizer from seeing this press
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceivePress:(UIPress *)press;
@end
