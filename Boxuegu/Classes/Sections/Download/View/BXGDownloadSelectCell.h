//
//  BXGDownloadSelectCell.h
//  Boxuegu
//
//  Created by apple on 2017/6/19.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BXGDownloadSelectCell : UITableViewCell

@property (nonatomic, strong) UIImageView * _Nullable selectImageView;
@property (nonatomic, strong) UILabel *txtLabel;

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(nullable NSString *)reuseIdentifier
                    bEditMode:(BOOL)bEditMode;

-(void)showSelectImage:(UIImage*_Nullable)newImage;

@end
