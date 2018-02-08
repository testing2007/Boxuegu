//
//  BXGPlayerLeftPopVC.m
//  demo-CCMedia
//
//  Created by HM on 2017/6/7.
//  Copyright © 2017年 Renying Wu. All rights reserved.
//

#import "BXGPlayerLeftPopVC.h"
#import "UIColor+Extension.h"
#import "Masonry.h"

@interface  BXGPlayerLeftPopCell: UITableViewCell


@end

@implementation BXGPlayerLeftPopCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
    
        [self installUI];
    }
    return self;
}
- (void)installUI {
    
    
    
}

@end

@interface BXGPlayerLeftPopVC ()

@property (nonatomic, weak) UITableView *tableView;
@end

@implementation BXGPlayerLeftPopVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self installUI];
    
}

- (void)installUI {

    // install View
    self.view.backgroundColor = [UIColor colorWithHex:0x11161F];
    self.view.alpha = 0.9;
    
    
    // install TitleLabel
    
    UILabel *titleLabel = [UILabel new];
    [self.view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
    }];
}

@end
