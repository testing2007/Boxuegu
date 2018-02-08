//
//  PreviewImageVC.h
//  Boxuegu
//
//  Created by apple on 2017/8/29.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PreviewImageVC : UIViewController
-(instancetype) initWithImageStrURLs:(NSArray*)arrImagesStrURL
                        atStartIndex:(NSInteger)startIndex
                    placeholderImage:(UIImage*)placeholderImage;
@end
