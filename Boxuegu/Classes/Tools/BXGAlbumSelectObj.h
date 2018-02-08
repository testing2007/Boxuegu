//
//  BXGAlbumSelectObj.h
//  Boxuegu
//
//  Created by apple on 2018/1/19.
//  Copyright © 2018年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ConfirmActionBlockType)(NSData* photoData);
typedef void (^CancelActionBlockType)(void);

@interface BXGAlbumSelectObj : NSObject

- (instancetype)initWithVCDelegate:(UIViewController* _Nonnull)vcDelegate
                       andTitleTip:(NSString*)titleTip
                     andMessageTip:(NSString*)messageTip
              andCameraActionTitle:(NSString* _Nonnull)cameraActionTitle
               andAlbumActionTitle:(NSString* _Nonnull)albumActionTitle
             andConfirmActionBlock:(ConfirmActionBlockType)confirmActionBlock
              andCancelActionBlock:(CancelActionBlockType)cancelActionBlock;

- (void)launchUI;

@property (nonatomic, weak) UIViewController *vcDelegate;
@property (nonatomic, copy) ConfirmActionBlockType confirmActionBlock;
@property (nonatomic, copy) CancelActionBlockType cancelActionBlock;

@end
