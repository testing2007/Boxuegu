//
//  BXGStudyPlayerListTableViewController.m
//  Boxuegu
//
//  Created by RW on 2017/4/20.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "RWMultiTableView.h"
#import "RWMultiDataSourse.h"
#import "RWMultiEmptyCell.h"

@interface RWMultiTableView () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray<RWMultiItem *> *allMultiItem;
@end

@implementation RWMultiTableView

// 1.创建数据源

- (instancetype)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    if(self) {
    
        [self registerClass:[RWMultiEmptyCell class] forCellReuseIdentifier:@"RWMultiEmptyCell"];
    }
    return self;
}

- (void)installDataSourse{

    __weak typeof (self) weakSelf = self;
    
    // 1.添加代理和数据源
    self.dataSource = self;
    self.delegate = self;
    self.sectionDataSourseArray = nil;
    self.allMultiItem = nil;
    // 2.获得根模型
    NSArray *rootForSectionmodelArray;
    if(weakSelf.rootModelForTableViewBlock) {
    
        
        rootForSectionmodelArray = weakSelf.rootModelForTableViewBlock(weakSelf);
    }
    NSInteger numberSection = rootForSectionmodelArray.count;
    
    // 3.根据根模型数量创建dataSourseForSection
    self.sectionDataSourseArray = [[NSMutableArray alloc]initWithCapacity:numberSection];
    for(NSInteger sectionIndex = 0; sectionIndex < numberSection; sectionIndex++){
    
        RWMultiDataSourse *sectionDataSourse = [RWMultiDataSourse new];
        sectionDataSourse.level = -1;
        sectionDataSourse.tag = sectionIndex;
        sectionDataSourse.isOpen = false;
        sectionDataSourse.model = rootForSectionmodelArray[sectionIndex];
        
        [self addsubItem:sectionDataSourse andSection:sectionIndex];
        [self.sectionDataSourseArray addObject:sectionDataSourse];
        
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView  {

    __weak typeof (self) weakSelf = self;
    
    if(weakSelf.rootModelForTableViewBlock) {
        
        NSArray *rootForSectionmodelArray = weakSelf.rootModelForTableViewBlock(weakSelf);
        return rootForSectionmodelArray.count;
    }else {
    
        // default value
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    RWMultiDataSourse *dataSourse = self.sectionDataSourseArray[indexPath.section];
    RWMultiItem *item = [dataSourse itemforIndexPath:indexPath.row];

    UITableViewCell *cell;
    if(self.cellForRowBlock){
        return self.cellForRowBlock(self, indexPath.section, item);
    }
    if(cell){
        return cell;
    }else {
        return [tableView dequeueReusableCellWithIdentifier:@"RWMultiEmptyCell" forIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    RWMultiDataSourse *dataSourse = self.sectionDataSourseArray[indexPath.section];
    RWMultiItem *item = [dataSourse itemforIndexPath:indexPath.row];
    
    if(self.didSelectRowBlock) {
    
        self.didSelectRowBlock(self, indexPath.section, item);
    }
}

//- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
//    RWMultiDataSourse *dataSourse = self.sectionDataSourseArray[indexPath.section];
//    RWMultiItem *item = [dataSourse itemforIndexPath:indexPath.row];
//    
//    if(self.didDeselectRowBlock) {
//        
//        self.didDeselectRowBlock(self, indexPath, item);
//    }
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RWMultiDataSourse *dataSourse = self.sectionDataSourseArray[indexPath.section];
    RWMultiItem *item = [dataSourse itemforIndexPath:indexPath.row];

    //UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
//    if(cell && [cell isKindOfClass:[RWMultiEmptyCell class]]) {
//    
//        return 0;
//    }
    
    if(self.heightForRowBlock){
    
        return self.heightForRowBlock(self, indexPath.section, item);
    }else{
    
        return self.rowHeight;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if(self.sectionDataSourseArray.count <= 0){
    
        return 0;
    }
    
    RWMultiDataSourse *dataSourse = self.sectionDataSourseArray[section];
    return dataSourse.currentItems.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    if(self.sectionDataSourseArray.count <= 0) {
    
        return nil;
    }
    
    if(self.viewForHeaderInSectionBlock){
        RWMultiDataSourse *dataSourse = self.sectionDataSourseArray[section];
        UIView *headerView = self.viewForHeaderInSectionBlock(self, section, dataSourse);
        headerView.tag = section;
        
        [headerView addGestureRecognizer: [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didSelectHeaderViewAtSection:)]];
        return headerView;
        
    }else{
        
        return nil;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if(self.heightForHeaderInSectionBlock){
    
        return self.heightForHeaderInSectionBlock(self, section);
    }else {
    
        return 0;
    }
}

- (void)didSelectHeaderViewAtSection:(UITapGestureRecognizer *)tap {

    __weak typeof (self) weakSelf = self;
    
    NSInteger section = tap.view.tag;
    RWMultiDataSourse *dataSourse = self.sectionDataSourseArray[section];
    if(weakSelf.didSelectHeaderViewAtSectionBlock){
    
        weakSelf.didSelectHeaderViewAtSectionBlock(weakSelf, section, dataSourse);
    }
}
#pragma mark - operation
- (void)openSection:(NSInteger)section {

    RWMultiDataSourse *dataSourse = self.sectionDataSourseArray[section];
    if(dataSourse.isOpen) {
        
        // [dataSourse removeAll];
        
    }else {
        
        [dataSourse installAll];
        
    }
    

    
}
- (void)openAllSection {

    NSArray<RWMultiDataSourse *> *dataSourseArray = self.sectionDataSourseArray;
    for (NSInteger i = 0; i < dataSourseArray.count; i ++) {
    
        [self openSection:i];
    }
    
}

- (void)closeSection:(NSInteger)section{

    RWMultiDataSourse *dataSourse = self.sectionDataSourseArray[section];
    if(dataSourse.isOpen) {
        
        [dataSourse removeAll];
        
        
    }else {
        
        //[dataSourse installSubItemChild];
    }
    
}


#pragma mark - Need test
/**
 添加子Item
 
 @param item 父Item
 @param section 当前所在的Section
 */
-(void)addsubItem:(RWMultiItem *)item andSection:(NSInteger)section {
    
    __weak typeof (self) weakSelf = self;
    
    NSInteger subLevel = item.level + 1;
    
    NSArray<id> *subModelArray;
    
    // 获得子模型
    if(weakSelf.subModelsForTableViewBlock) {
        
        subModelArray = weakSelf.subModelsForTableViewBlock(weakSelf, section, item);
    }
    
    NSInteger subModelArrayCount = subModelArray.count;
    
    NSMutableArray *subItems = [[NSMutableArray alloc]initWithCapacity:subModelArrayCount];
    for(NSInteger i = 0; i < subModelArrayCount; i++){
        
        RWMultiItem *subitem = [RWMultiItem new];
        subitem.tag = i;
        subitem.level = subLevel;
        subitem.isOpen = false;
        subitem.superitem = item;
        subitem.model = subModelArray[i];
        
        [subItems addObject:subitem];
        [self addsubItem:subitem andSection:section];
        
    }
    [self.allMultiItem addObject:item];
    item.subitems = subItems;
    
}

- (void)reloadDataWithFinishedBlock:(EndLayoutSubviewsBlockType)endBlock; {

    __weak typeof (self) weakSelf = self;
    weakSelf.endLayoutSubviewsBlock = endBlock;
    [weakSelf reloadData];
}

- (void)layoutSubviews {
    
    __weak typeof (self) weakSelf = self;
    [super layoutSubviews];
    if(weakSelf.endLayoutSubviewsBlock){
    
        weakSelf.endLayoutSubviewsBlock(weakSelf);
        weakSelf.endLayoutSubviewsBlock = nil;
    }
}

- (RWMultiItem *)searchItemWithModel:(id)model {

    if(!model) {
    
        return nil;
    }
    
    for(NSInteger i = 0; i < self.sectionDataSourseArray.count; i++ ){
    
        if(self.sectionDataSourseArray[i].model == model) {
        
            return self.sectionDataSourseArray[i];
        }
    }
    
    for(NSInteger i = 0; i < self.allMultiItem.count; i++){
    
        if(self.allMultiItem[i].model == model) {
            
            return self.allMultiItem[i];
        }
    }
    
    return nil;
}

#pragma mark - Done

@end
