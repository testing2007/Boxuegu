//
//  RWTableView.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/8/14.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "RWTableView.h"

@interface RWTableView() <UITableViewDelegate, UITableViewDataSource>

@end

@implementation RWTableView

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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    __weak typeof (self) weakSelf = self;
    if(weakSelf.viewForHeaderInSectionBlock) {
    
        return weakSelf.viewForHeaderInSectionBlock(tableView,section);
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {

    __weak typeof (self) weakSelf = self;
    if(weakSelf.viewForFooterInSectionBlock) {
        
        return weakSelf.viewForFooterInSectionBlock(tableView,section);
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    __weak typeof (self) weakSelf = self;
    if(weakSelf.heightForHeaderInSectionBlock) {
        
        return weakSelf.heightForHeaderInSectionBlock(tableView,section);
    }
    return 0;
}


//- (UITableViewHeaderFooterView *)headerViewForSection:(NSInteger)section {
//
//}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {

    __weak typeof (self) weakSelf = self;
    if(weakSelf.heightForFooterInSectionBlock) {
        
        return weakSelf.heightForFooterInSectionBlock(tableView,section);
    }
    return 0;
}

#pragma mark - delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof (self) weakSelf = self;
    if(weakSelf.didSelectRowAtIndexPathBlock){
        
        weakSelf.didSelectRowAtIndexPathBlock(weakSelf,indexPath);
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(self.scrollViewDidScrollBlock) {
        self.scrollViewDidScrollBlock(scrollView);
    }
}
@end
