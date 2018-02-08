//
//  BXGCareerCourseCC.h
//  CollectionViewPrj
//
//  Created by apple on 2017/10/10.
//  Copyright © 2017年 itheima. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BXGHomeCourseModel;

@interface BXGCareerCourseCC : UICollectionViewCell

@property(nonatomic, weak) UIImageView *courseImageView;
@property(nonatomic, weak) UILabel *courseNameLabel;
@property(nonatomic, weak) UILabel *descLabel;
@property(nonatomic, weak) UILabel *learndCountLabel;
@property(nonatomic, weak) UILabel *currentPriceLabel;

-(void)setModel:(BXGHomeCourseModel*)model;

@end
