//
//  BXGAcceptProtocolView.h
//  Boxuegu
//
//  Created by RenyingWu on 2017/12/19.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^BXGReadProtocolBlockType)(void);
typedef void (^BXGSelectedBlockType)(BOOL isSelected);

@interface BXGAcceptProtocolView : UIView
@property(nonatomic, weak) UIImageView *imageView;
@property(nonatomic, weak) UILabel *readedLabel;
@property(nonatomic, weak) UILabel *linkProtocolLabel;
@property(nonatomic, copy) BXGReadProtocolBlockType readProtocolBlock;
@property(nonatomic, copy) BXGSelectedBlockType selectedBlock;
@property(nonatomic, assign) BOOL selected;
@property(nonatomic, strong) NSString *protocolName;
@end
