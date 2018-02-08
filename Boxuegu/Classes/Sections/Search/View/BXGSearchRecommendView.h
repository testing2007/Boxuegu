//
//  BXGSearchRecommendView.h
//  Boxuegu
//
//  Created by apple on 2017/12/15.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^TapKeywordBlock)(NSString *keyword);
typedef void (^CloseKeyboardBlock)(void);

@interface BXGSearchRecommendView : UIView

@property (nonatomic, copy) TapKeywordBlock tapKeyword;
@property (nonatomic, copy) CloseKeyboardBlock closeKeyboard;

@end
