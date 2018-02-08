//
//  RWPhotoSelectedView.m
//  demo-RWPhotosFramework
//
//  Created by RenyingWu on 2017/8/15.
//  Copyright © 2017年 Renying Wu. All rights reserved.
//

#import "RWPhotoSelectedView.h"
#import "UIColor+Extension.h"

@implementation RWPhotoSelectedView

- (void)awakeFromNib {
    [super awakeFromNib];

    [self installUI];
}

- (instancetype)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    if(self){
    
        [self installUI];
    }
    return self;
}

- (void)installUI {

    
}

- (void)setSelectedNumber:(NSInteger)selectedNumber {

    _selectedNumber = selectedNumber;
    if(selectedNumber == 0){
    
        [self setImage:[UIColor greenColor].convertImage forState:UIControlStateNormal];
        
    }else {
    
        [self setImage:[UIImage imageNamed:@"图片-选中"] forState:UIControlStateNormal];
        
    }
    [self setNeedsDisplay];
}


@end
