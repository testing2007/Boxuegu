//
//  BXGMeMenuView.m
//  Boxuegu
//
//  Created by Renying Wu on 2018/2/2.
//  Copyright © 2018年 itcast. All rights reserved.
//

#import "BXGMeMenuView.h"

@interface BXGMeMenuViewItem()

@property (nonatomic, copy) void(^settingCellBlock)(UITableViewCell *deqCell);
@property (nonatomic, copy) void(^didSelectedBlock)(NSIndexPath *indexPath);

@property (nonatomic, readonly) NSString *reusableCellName;
@end

@implementation BXGMeMenuViewItem

- (NSString *)reusableCellName {
    
    if(self.cellClass) {
        return NSStringFromClass(self.cellClass);
    }else if (self.nibName) {
        return self.nibName;
    }
    return nil;
}

+ (instancetype)itemWithCellClass:(Class)cellClass andSettingCell:(void(^)(UITableViewCell *deqCell))settingCellBlock andDidSelected:(void(^)())didSelectedBlock {
    
    BXGMeMenuViewItem *item = [[BXGMeMenuViewItem alloc]init];
    item.cellClass = cellClass;
    item.settingCellBlock = settingCellBlock;
    item.didSelectedBlock = didSelectedBlock;
    return item;
}

+ (instancetype)itemWithNibName:(NSString *)nibName andSettingCell:(void(^)(UITableViewCell *deqCell))settingCellBlock andDidSelected:(void(^)())didSelectedBlock {
    
    BXGMeMenuViewItem *item = [[BXGMeMenuViewItem alloc]init];
    item.nibName = nibName;
    item.settingCellBlock = settingCellBlock;
    item.didSelectedBlock = didSelectedBlock;
    return item;
}

@end

@interface BXGMeMenuView() <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableDictionary *registerCacheDict;

@end

@implementation BXGMeMenuView

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self installUI];
    }
    return self;
}

#pragma mark - getter setter

- (NSMutableDictionary *)registerCacheDict {
    
    if(_registerCacheDict == nil) {
        
        _registerCacheDict = [NSMutableDictionary new];
    }
    return _registerCacheDict;
}

#pragma makr - ui

- (void)installUI {
    UITableView *rableView = self.tableView;
    [self addSubview:rableView];
    [rableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.offset(0);
    }];
}

- (UITableView *)tableView {
    
    if(_tableView == nil) {
        
        _tableView = [[BXGTableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 46;
        _tableView.bounces = true;
        
        _tableView.separatorColor = [UIColor colorWithHex:0xF5F5F5];
        _tableView.backgroundColor = [UIColor colorWithHex:0xF5F5F5];
    }
    return _tableView;
}

#pragma method

- (void)install {
    
    [self registCell];
}

- (void)registCell {

    [self enumerateItems:^(NSIndexPath *indexPath, BXGMeMenuViewItem *item) {
        
        if(item.reusableCellName != nil && self.registerCacheDict[item.reusableCellName] == nil) {
            self.registerCacheDict[item.reusableCellName] = item.reusableCellName;
            if(item.cellClass) {
                [self.tableView registerClass:item.cellClass forCellReuseIdentifier:item.reusableCellName];
            }else if(item.nibName) {
                [self.tableView registerNib:[UINib nibWithNibName:item.nibName bundle:nil] forCellReuseIdentifier:item.reusableCellName];
            }
        }
    }];
}

- (void)settingCell {
    
    [self enumerateItems:^(NSIndexPath *indexPath, BXGMeMenuViewItem *item) {
        if(item.cellClass) {
            NSString *cellTitle = NSStringFromClass(item.cellClass);
            [self.tableView registerClass:item.cellClass forCellReuseIdentifier:cellTitle];
        }else if(item.nibName) {
            [self.tableView registerNib:[UINib nibWithNibName:item.nibName bundle:nil] forCellReuseIdentifier:item.nibName];
        }
    }];
}

- (void)enumerateItems:(void(^)(NSIndexPath * indexPath, BXGMeMenuViewItem *item))enumerateBlock{
    
    NSArray<NSArray<BXGMeMenuViewItem *>*> *items = self.items;
    for (NSInteger i = 0; i < items.count; i++) {
        for (NSInteger j = 0; j < items[i].count; j++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:j inSection:i];
            BXGMeMenuViewItem *item = items[i][j];
            if(enumerateBlock) {
                enumerateBlock(indexPath, item);
            }
        }
    }
}

- (void)reload {
    [self registCell];
    [self.tableView reloadData];
}

- (BXGMeMenuViewItem *)itemWithIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    if(self.items.count > section && self.items[section].count > row) {
        return self.items[section][row];
    }else {
        return nil;
    }
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BXGMeMenuViewItem *item = [self itemWithIndexPath:indexPath];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:item.reusableCellName];
    if(item.settingCellBlock) {
        item.settingCellBlock(cell);
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BXGMeMenuViewItem *item = [self itemWithIndexPath:indexPath];
    if(item.didSelectedBlock) {
        item.didSelectedBlock(indexPath);
    }
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.items.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(self.items.count > section) {
        return self.items[section].count;
    }else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 9;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return nil;
}

@end
