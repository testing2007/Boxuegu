//
//  BXGDownloadedCourseVideoSelectPageCell.h
//  Boxuegu
//
//  Created by apple on 2017/6/23.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BXGCourseOutlineVideoModel;

@interface BXGDownloadedCourseVideoSelectPageCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *selImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

-(void)setupCell:(BXGCourseOutlineVideoModel*)model;
-(void)showSelectImage:(UIImage*)newImage;

@end
