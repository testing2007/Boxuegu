//
//  BXGStudyChapterHeaderView.h
//  RWMuiltyTableView-Demo
//
//  Created by HM on 2017/4/21.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BXGStudyChapterHeaderView : UITableViewHeaderFooterView

@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) BOOL isOpen;
@property (nonatomic, strong) UIColor *backgroundColor;
@end
