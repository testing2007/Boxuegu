//
//  BXGPlayerGestrueView.m
//  Boxuegu
//
//  Created by Renying Wu on 2017/7/25.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGPlayerGestrueView.h"
#import "RWResponseView.h"
#import "BXGPlayerManager.h"

#import "BXGPlayerVolumeManager.h"
#import "BXGPlayerBrightnessManager.h"


#define K_BXGGESTRUE_MAX_OFFSET 300

typedef NS_ENUM(NSUInteger, BXGGestrueDirectionType) {
    BXGGestrueDirectionTypeLeftOrRight,
    BXGGestrueDirectionTypeUpOrDown,
    BXGGestrueDirectionTypeNone
};

@interface BXGPlayerGestrueView()

@property (nonatomic, assign) BXGGestrueDirectionType direction;
@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, assign) BOOL isLeft;
@property (nonatomic, assign) BOOL isTop;
@property (nonatomic, assign) float lastOffset;


@property (nonatomic, assign) float startVolume;
@property (nonatomic, assign) float startBrightness;
@property (nonatomic, assign) float startSeek;
@end
@implementation BXGPlayerGestrueView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        
        [self installGesture];
        [self defaultFunction];
    }
    return self;
}

- (void)setVerticalTouchMovedBlock:(void (^)(BOOL, float, BOOL, BOOL))verticalTouchMovedBlock {
    _verticalTouchMovedBlock = verticalTouchMovedBlock;
}

- (void)setLastOffset:(float)lastOffset {
    if(fabs(lastOffset > K_BXGGESTRUE_MAX_OFFSET)) {
        if(lastOffset > 0) {
            
            lastOffset = K_BXGGESTRUE_MAX_OFFSET;
        }else {
            
            lastOffset = -K_BXGGESTRUE_MAX_OFFSET;
        }
    }
    _lastOffset = lastOffset;
}

- (void)installGesture {
    
    Weak(weakSelf);
    
    // 确定点击位置
    self.touchBeganBlock = ^(CGPoint point) {
        
        weakSelf.startPoint = point;
        weakSelf.direction = BXGGestrueDirectionTypeNone;
        if (weakSelf.startPoint.x <= weakSelf.frame.size.width / 2.0) {
            
            weakSelf.isLeft = true;
        } else {
            
            weakSelf.isLeft = false;
        }
        if (weakSelf.startPoint.y <= weakSelf.frame.size.height / 2.0) {
            
            weakSelf.isTop = true;
        } else {
            
            weakSelf.isTop = false;
        }
    };
    
    self.touchesMovedBlock = ^(CGPoint point) {
        
        BOOL isFirst = false;
        // 1.初始方向
        CGPoint panPoint = CGPointMake(point.x - weakSelf.startPoint.x, point.y - weakSelf.startPoint.y);
        //分析出用户滑动的方向
        if (weakSelf.direction == BXGGestrueDirectionTypeNone) {
            
            if (panPoint.x >= 30 || panPoint.x <= -30) {
                
                weakSelf.direction = BXGGestrueDirectionTypeLeftOrRight;
            } else if (panPoint.y >= 30 || panPoint.y <= -30) {
                
                weakSelf.direction = BXGGestrueDirectionTypeUpOrDown;
            }
            
            if (weakSelf.direction != BXGGestrueDirectionTypeNone) {
                
                isFirst = true;
            }
        }
        
        // 2.回调
        if (weakSelf.direction == BXGGestrueDirectionTypeNone) {
            
//            [weakSelf setDefaultConfig];
            return;
        } else if (weakSelf.direction == BXGGestrueDirectionTypeUpOrDown) {
            
            weakSelf.lastOffset = panPoint.y;
            if(weakSelf.verticalTouchMovedBlock) {
                weakSelf.verticalTouchMovedBlock(weakSelf.isLeft, weakSelf.lastOffset, isFirst, false);
            }
            
        } else if (weakSelf.direction == BXGGestrueDirectionTypeLeftOrRight ) {
            
            weakSelf.lastOffset = panPoint.x;
        
            if(weakSelf.horizontalTouchMovedBlock) {
                weakSelf.horizontalTouchMovedBlock(weakSelf.isTop, weakSelf.lastOffset, isFirst, false);
            }
        }
    };
    
    self.touchesEndedBlock = ^{
        
        if (weakSelf.direction == BXGGestrueDirectionTypeNone) {
            
            [weakSelf setDefaultConfig];
            return;
        } else if (weakSelf.direction == BXGGestrueDirectionTypeUpOrDown) {
            
            if(weakSelf.verticalTouchMovedBlock) {
                weakSelf.verticalTouchMovedBlock(weakSelf.isLeft, weakSelf.lastOffset, false, true);
            }
            
        } else if (weakSelf.direction == BXGGestrueDirectionTypeLeftOrRight ) {
            
            if(weakSelf.horizontalTouchMovedBlock) {
                weakSelf.horizontalTouchMovedBlock(weakSelf.isTop, weakSelf.lastOffset, false, true);
            }
        }
        
        // 2.初始化
        [weakSelf setDefaultConfig];
    };
}

- (void)defaultFunction {
    
    Weak(weakSelf);
    self.verticalTouchMovedBlock = ^(BOOL isLeft, float offset, BOOL isFirst, BOOL isLast) {
        if(!isLeft) {
            // 声音
            if(isFirst) {
                
                // 设置start
                weakSelf.startVolume = [BXGPlayerVolumeManager share].volume;
            }
            [BXGPlayerVolumeManager share].volume = weakSelf.startVolume + (-(offset / 300));
            if (isLast) {
                
                weakSelf.startVolume = 0;
            }
        }else {
            // 亮度
            if(isFirst) {
                weakSelf.startBrightness = [UIScreen mainScreen].brightness;
            }
            [UIScreen mainScreen].brightness = weakSelf.startBrightness + (-(offset / 300));
            
            if (isLast) {
                weakSelf.startBrightness = 0;
            }
        }
    };
}

- (void)setDefaultConfig {
    self.isTop = false;
    self.isLeft = false;
    self.lastOffset = 0;
    self.direction = BXGGestrueDirectionTypeNone;
    self.startPoint = CGPointZero;
}

- (void)tapGestureView:(UITapGestureRecognizer *)tap {
    
}
@end
