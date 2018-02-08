//
//  BXGVODPlayerGestrueView.m
//  Boxuegu
//
//  Created by Renying Wu on 2018/1/17.
//  Copyright © 2018年 itcast. All rights reserved.
//

#import "BXGVODPlayerGestrueView.h"
#import "BXGPlayerGestrueView.h"
#import "BXGPlayerManager.h"

@interface BXGVODPlayerGestrueView()
@property (nonatomic, strong) BXGPlayerGestrueView *gestrueView;
@property (nonatomic, strong) BXGPlayerManager *playerManager;

@property (nonatomic, assign) float startSeekTime;
@end

@implementation BXGVODPlayerGestrueView

- (void)didMoveToSuperview {
    
    if(self.superview) {
//        [self.playerManager addDelegate:self];
    }else {
//        [self.playerManager removeDelegate:self];
    }
}

- (void)dealloc {
    
}


- (BXGPlayerManager *)playerManager {
    
    if(_playerManager == nil) {
        
        _playerManager = [BXGPlayerManager share];
    }
    return _playerManager;
}

- (BXGPlayerGestrueView *)gestrueView {
    
    if(_gestrueView == nil) {
        
        _gestrueView = [BXGPlayerGestrueView new];
    }
    return _gestrueView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if(self) {
//        [self installUI];
        [self installGestrue];
        self.enableHorizontalTouchMoved = true;
    }
    return self;
}

//- (void)installUI {
//
//}

- (void)installGestrue {
    Weak(weakSelf);
//    BXGPlayerGestrueView *gestrueView = self.gestrueView;
//    gestrueView.horizontalTouchMovedBlock = ^(BOOL isTop, float offset, BOOL isFirst, BOOL isLast) {
//
//
//    };
    
    self.horizontalTouchMovedBlock = ^(BOOL isTop, float offset, BOOL isFirst, BOOL isLast) {
        if(weakSelf.enableHorizontalTouchMoved) {
            [weakSelf onGestureViewHorizontalTouchMoved:isTop andOffset:offset andIsFirst:isFirst andIsLast:isLast];
        }
    };
    
//    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureView:)];
//    [gestrueView addGestureRecognizer:tapGesture];
//
//    gestrueView.tapBlock = ^{
//
//        if(weakSelf.tapBlock) {
//            weakSelf.tapBlock();
//        }
//    };
}

//- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [self.gestrueView touchesMoved:touches withEvent:event];
//}
//
//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [self.gestrueView touchesBegan:touches withEvent:event];
//}
//
//- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [self.gestrueView touchesEnded:touches withEvent:event];
//}
//
//- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [self.gestrueView touchesCancelled:touches withEvent:event];
//}

//- (void)touchesEstimatedPropertiesUpdated:(NSSet<UITouch *> *)touches {
//    [self.gestrueView touchesEstimatedPropertiesUpdated:touches];
//}

// * gesture view

#pragma mark - Response

//- (void)tapGestureView:(UITapGestureRecognizer *)tap {
//    Weak(weakSelf);
//    if(weakSelf.tapBlock) {
//        weakSelf.tapBlock();
//    }
//}

- (void)onGestureViewHorizontalTouchMoved:(BOOL)isTop andOffset:(float)offset andIsFirst:(BOOL)isFirst andIsLast:(BOOL)isLast {
    if(isFirst){
        
        self.startSeekTime = self.playerManager.currentTime;
        [self.playerManager startSeekTime:self.startSeekTime];
        
    }else if (isLast) {
        [self.playerManager endSeekTime:self.startSeekTime + offset];
        self.startSeekTime = 0;
    }else {

        [self.playerManager seekingTime:self.startSeekTime + offset];
    }
}

@end
