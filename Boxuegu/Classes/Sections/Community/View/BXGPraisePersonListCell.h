//
//  BXGPraisePersonListCell.h
//  Boxuegu
//
//  Created by apple on 2017/9/6.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BXGCommunityUserModel;

@protocol BXGPraisePersonListCellDelegate<NSObject>

-(void)confirmAttention:(NSString*)followUUID;
-(void)cancelAttention:(NSString*)followUUID;;

@end

@interface BXGPraisePersonListCell : UITableViewCell

-(void)setModel:(BXGCommunityUserModel*)model
    andDelegate:(id<BXGPraisePersonListCellDelegate>)delegate;

@property(nonatomic, weak) id<BXGPraisePersonListCellDelegate> delegate;

@end
