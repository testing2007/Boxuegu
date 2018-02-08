//
//  BXGOrderBuyCourseCell.h
//  Boxuegu
//
//  Created by apple on 2017/10/24.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *BXGOrderBuyCourseCellId = @"BXGOrderBuyCourseCell";
static NSString *BXGOrderBuyCourseCellId_PriceImportantShow = @"BXGOrderBuyCourseCellId_PriceImportantShow";

@interface BXGOrderBuyCourseCell : UITableViewCell

@property(nonatomic, weak) UIImageView *courseThumbImageView;
@property(nonatomic, weak) UILabel *titleLabel;
@property(nonatomic, weak) UILabel *priceLabel;
@property(nonatomic, weak) UILabel *expireLabel;

//- (void)priceIsImportShow:(BOOL)bImportShow;

@end
