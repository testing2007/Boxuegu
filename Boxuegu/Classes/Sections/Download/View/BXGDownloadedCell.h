//
//  BXGDownloadedCell.h
//  Demo
//
//  Created by apple on 17/6/10.
//  Copyright © 2017年 com.bokecc.www. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BXGDownloadedModel;
@class BXGDownloadedRenderModel;

@interface BXGDownloadedCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *selImageView;
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImageView;
@property (weak, nonatomic) IBOutlet UILabel *courseNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *downloadedTotalVideoNumsLabel;
@property (weak, nonatomic) IBOutlet UILabel *downloadedTotalSizeLabel;

-(void)setupCell:(BXGDownloadedRenderModel*)model;
-(void)showSelectImage:(UIImage*)newImage;

@end
