//
//  OptionImageView.h
//  Boxuegu
//
//  Created by apple on 2017/10/24.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void (^SelBlockType)(void);
typedef void (^UnselBlockType)(void);

@interface OptionImageView : UIImageView

-(instancetype)initIsSel:(BOOL)bSel andSelBlock:(SelBlockType)selBlock andUnselBlock:(UnselBlockType)unselBlock;

@property(nonatomic, copy) SelBlockType selBlock;
@property(nonatomic, copy) UnselBlockType unselBlock;

@property(nonatomic, assign) BOOL isSel;

@end
