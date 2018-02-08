//
//  UIExtTableView.m
//  RW - Util Project
//
//  Created by RW on 2017/6/7.
//  Copyright © 2017年 Renying Wu. All rights reserved.
//

#import "UIExtTableView.h"


@interface UIExtTableView() <UITableViewDelegate, UITableViewDataSource>

@end

@implementation UIExtTableView


- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {

    
    self = [super initWithFrame:frame style:style];
    if(self) {
        
        
        self.dataSource = self;
        self.delegate = self;
    }
    return self;
}

#pragma mark data source

- (void)dealloc {

    NSLog(@"dealloc extableView");
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    __weak typeof (self) weakSelf = self;
    if(weakSelf.numberOfRowsInSectionBlock){
    
        return weakSelf.numberOfRowsInSectionBlock(weakSelf, section);
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView; {
    
    __weak typeof (self) weakSelf = self;
    if(weakSelf.numberOfSectionsInTableViewBlock){
        
        return weakSelf.numberOfSectionsInTableViewBlock(weakSelf);
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath; {

    __weak typeof (self) weakSelf = self;
    
    if(weakSelf.cellForRowAtIndexPathBlock){
        
        return weakSelf.cellForRowAtIndexPathBlock(weakSelf,indexPath);
    }
    return nil;
    
}

#pragma mark - delegate 
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof (self) weakSelf = self;
    if(weakSelf.didSelectRowAtIndexPathBlock){
        
        weakSelf.didSelectRowAtIndexPathBlock(weakSelf,indexPath);
    }
}

@end
