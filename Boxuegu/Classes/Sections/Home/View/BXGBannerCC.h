//
//  BXGBannerCC.h
//  Boxuegu
//
//  Created by apple on 2017/10/16.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXGBannerModel.h"
@interface BXGBannerCC : UICollectionViewCell

-(void)setModel:(NSArray<BXGBannerModel*>*)arrImagesUrl andTapBlock:(void (^)(NSInteger tag))tapBlock;

@end
