//
//  BXGMeMenuView.h
//  Boxuegu
//
//  Created by Renying Wu on 2018/2/2.
//  Copyright © 2018年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BXGMeMenuViewItem: NSObject

+ (instancetype)itemWithCellClass:(Class)cellClass andSettingCell:(void(^)(UITableViewCell *deqCell))settingCellBlock andDidSelected:(void(^)())didSelectedBlock;
+ (instancetype)itemWithNibName:(NSString *)nibName andSettingCell:(void(^)(UITableViewCell *deqCell))settingCellBlock andDidSelected:(void(^)())didSelectedBlock;

@property (nonatomic) Class cellClass;
@property (nonatomic) NSString *nibName;
@end

@interface BXGMeMenuView : UIView
@property (nonatomic, strong) NSArray<NSArray<BXGMeMenuViewItem *>*> *items;
- (void)install;
- (void)reload;
@end
