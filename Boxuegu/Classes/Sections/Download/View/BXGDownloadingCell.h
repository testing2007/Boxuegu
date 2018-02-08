//
//  BXGDownloadingCell.h
//  Demo
//
//  Created by apple on 17/6/10.
//  Copyright © 2017年 com.bokecc.www. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BXGDownloadModel.h"
#import "BXGDownloadManagerDelegate.h"

@interface BXGDownloadingCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *videoIdx;

@property (weak, nonatomic) IBOutlet UIImageView *editSelImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *statusButton;
@property (weak, nonatomic) IBOutlet UILabel *downloadByteProgressLabel;
@property (weak, nonatomic) IBOutlet UILabel *downloadSpeedLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *downloadProgressView;

@property (assign, nonatomic) BOOL bEditMode; //是否为编辑模式
@property (nonatomic, strong) BXGDownloadModel* model;

@property (nonatomic, weak) id<BXGDownloadManagerDelegate> delegate;

@property (nonatomic, assign) BOOL bRegister;

@property (nonatomic, weak) NSIndexPath *indexPath;

-(void)setupCell:(BXGDownloadModel *)model withIndexPath:(NSIndexPath*)indexPath;
-(void)showSelectImage:(UIImage*)newImage;

@end
