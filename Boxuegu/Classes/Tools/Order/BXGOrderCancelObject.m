//
//  BXGOrderCancelObject.m
//  Boxuegu
//
//  Created by apple on 2017/10/30.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGOrderCancelObject.h"
#import "UIView+Pop.h"
#import "BXGOrderHelper.h"
#import "UIView+Extension.h"

@interface BXGOrderCancelObject()
@property(nonatomic, weak) UIView *menuView;
@property(nonatomic, weak) UIViewController *ownerVC;
@property(nonatomic, weak) NSString *orderNo;
@property(nonatomic, copy) ContinuePayBlockType continuePayBlock;
@property(nonatomic, copy) CancelPayBlockType cancelPayBlock;
@end

@implementation BXGOrderCancelObject

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)loadCancelMenuViewContraint:(void (^)(MASConstraintMaker *make))constrintBlock
                         andOwnerVC:(UIViewController*)ownerVC
                         andOrderNo:(NSString*)orderNo
                andContinuePayBlock:(ContinuePayBlockType)continePayBlock
                  andCancelPayBlock:(CancelPayBlockType)cancelPayBlock {
    if(_menuView) {
        [_menuView hideView];
        _menuView = nil;
    } else {
        _ownerVC = ownerVC;
        _orderNo = orderNo;
        
        _continuePayBlock = continePayBlock;
        _cancelPayBlock = cancelPayBlock;

        UIView *maskView = [UIView new];
        maskView.backgroundColor = [UIColor whiteColor];
        [maskView showInWindowAndBgAlpha:-1 andCancelBlock:nil andMaskViewConstraint:nil];
        [maskView mas_makeConstraints:^(MASConstraintMaker *make) {
            if(constrintBlock) {
                constrintBlock(make);
            }
        }];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitleColor:[UIColor colorWithHex:0x333333] forState:UIControlStateNormal];
        [btn setTitle:@"取消订单" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(cancelOrder:) forControlEvents:UIControlEventTouchUpInside];
        [maskView addSubview:btn];
        [btn setBackgroundColor:[UIColor whiteColor]];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(8);
            make.left.bottom.right.offset(0);
        }];
        
        [maskView layoutIfNeeded];
        
        CAShapeLayer *maskLayer = [self createMaskLayerWithView:maskView];
        maskView.layer.mask = maskLayer;
        
        _menuView = maskView;
    }
}

-(CAShapeLayer*)createMaskLayerWithView : (UIView *)view{
    
    CGFloat viewWidth = CGRectGetWidth(view.frame);
    CGFloat viewHeight = CGRectGetHeight(view.frame);
    
    CGFloat rightMargin = 12;
    
    //勾3股4弦5(2倍就是6, 8, 10)
    CGPoint point1 = CGPointMake(viewWidth-rightMargin-6, 0);
    CGPoint point2 = CGPointMake(viewWidth-rightMargin-2*6, 8);
    CGPoint point3 = CGPointMake(3, 8);
    CGPoint point30 = CGPointMake(0, 8+3);
    CGPoint point4 = CGPointMake(0, viewHeight-3);
    CGPoint point40 = CGPointMake(3, viewHeight);
    CGPoint point5 = CGPointMake(viewWidth-3, viewHeight);
    CGPoint point50 = CGPointMake(viewWidth, viewHeight-3);
    CGPoint point6 = CGPointMake(viewWidth, 8+3);
    CGPoint point60 = CGPointMake(viewWidth-3, 8);
    CGPoint point7 = CGPointMake(viewWidth-rightMargin, 8);
    

    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:point1];
    [path addLineToPoint:point2];
    [path addLineToPoint:point3];
    [path addArcWithCenter:CGPointMake(point3.x, point30.y)
                    radius:3
                startAngle:M_PI*0.5
                  endAngle:M_PI
                 clockwise:NO];
//    [path addLineToPoint:point30];
    [path addLineToPoint:point4];
    [path addArcWithCenter:CGPointMake(point40.x, point4.y)
                    radius:3
                startAngle:M_PI
                  endAngle:M_PI*0.5
                 clockwise:NO];
//    [path addLineToPoint:point40];
    [path addLineToPoint:point5];
//    [path addLineToPoint:point50];
    [path addArcWithCenter:CGPointMake(point5.x, point50.y)
                    radius:3
                startAngle:M_PI*1.5
                  endAngle:0
                 clockwise:NO];
    [path addLineToPoint:point6];
//    [path addLineToPoint:point60];
    [path addArcWithCenter:CGPointMake(point60.x, point6.y)
                    radius:3
                startAngle:0
                  endAngle:-M_PI*0.5
                 clockwise:NO];

    [path addLineToPoint:point7];
    [path closePath];
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = path.CGPath;
//    layer.cornerRadius = 5;
    
    return layer;
}

- (void)cancelOrder:(UIButton*)sender {
    [_menuView hideView];
    _menuView = nil;

    BXGAlertController *vc = [BXGAlertController confirmWithTitle:nil
                                                          message:@"确认取消订单"
                                                  andConfirmTitle:@"继续支付"
                                                   confirmHandler:^{
                                                       if(_continuePayBlock) {
                                                           _continuePayBlock();
                                                       }
                                                   } cancleHandler:^{
                                                       BXGOrderHelper *_orderHelper = [BXGOrderHelper new];
                                                       [[BXGHUDTool share] showLoadingHUDWithString:nil];
                                                       [_orderHelper loadCancelOrderWithOrderNo:_orderNo
                                                                                        andType:[NSString stringWithFormat:@"1"] andFinishBlock:^(BOOL bSuccess, NSError *error) {
                                                                                            if(bSuccess) {
                                                                                                if(_cancelPayBlock) {
                                                                                                    _cancelPayBlock(YES, nil);
                                                                                                }
                                                                                            } else {
                                                                                                if(_cancelPayBlock) {
                                                                                                    _cancelPayBlock(NO, error);
                                                                                                }
                                                                                            }
                                                                                            
                                                                                            //延迟关闭HUD
                                                                                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kOrderDelayCloseHUDSecond * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                                                                [[BXGHUDTool share] closeHUD];
                                                                                            });
                                                                                        }];
                                                   }];
    if(_ownerVC) {
        [_ownerVC presentViewController:vc animated:true completion:nil];
    }
    
    NSLog(@"cancelOrder");
}

@end
