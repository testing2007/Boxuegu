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


- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if(self) {
        [self registerClass:[RWMultiEmptyCell class] forCellReuseIdentifier:@"RWMultiEmptyCell"];
        // 1.添加代理和数据源
        self.dataSource = self;
        self.delegate = self;
    }
    return self;
    
}

- (instancetype)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    if(self) {
    
        [self registerClass:[RWMultiEmptyCell class] forCellReuseIdentifier:@"RWMultiEmptyCell"];
        // 1.添加代理和数据源
        self.dataSource = self;
        self.delegate = self;
    }
    return self;
}

- (void)installDataSourse{

    __weak typeof (self) weakSelf = self;

    self.sectionDataSourseArray = nil;
    self.allMultiItem = nil;
    self.allMultiItem  = [NSMutableArray new];
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
    
        cell = self.cellForRowBlock(self, indexPath, item);
    }
    if(cell){
    
        return cell;
    }else {
    
        return [tableView dequeueReusableCellWithIdentifier:@"RWMultiEmptyCell" forIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:true];
    RWMultiDataSourse *dataSourse = self.sectionDataSourseArray[indexPath.section];
    RWMultiItem *item = [dataSourse itemforIndexPath:indexPath.row];
    
    if(self.didSelectRowBlock) {
    
        self.didSelectRowBlock(self, indexPath, item);
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
//
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
    
        return UITableViewAutomaticDimension;
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

- (void)reloadVisibleData {

    NSArray *indexArray = [self indexPathsForVisibleRows];
    if(indexArray && indexArray.count > 0){
    
        [self reloadData];
        // [self reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationNone];
    }else {
    
        [self reloadData];
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

-(void) multiTableViewReloadData
{
    //todo 这个删除函数有问题.
    __weak typeof (self) weakSelf = self;
    
    // 2.获得根模型
    NSArray *rootForSectionmodelArray;
    if(weakSelf.rootModelForTableViewBlock) {
        rootForSectionmodelArray = weakSelf.rootModelForTableViewBlock(weakSelf);
    }
    NSInteger numberSection = rootForSectionmodelArray.count;
    for(NSInteger sectionIndex = 0; sectionIndex < numberSection; sectionIndex++)
    {
        RWMultiDataSourse *dataSourse = self.sectionDataSourseArray[sectionIndex];
            if(weakSelf.subModelsForTableViewBlock) {
                weakSelf.subModelsForTableViewBlock(weakSelf, sectionIndex, dataSourse);
            }
    }
    [super reloadData];
}
                                 
- (void)reloadDataWithFinishedBlock:(EndLayoutSubviewsBlockType)endBlock
{
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

- (RWMultiItem *)searchItemWithItem:(RWMultiItem *)item; {

    if(!item) {
        
        return nil;
    }
    // NSInteger sectionIndex = [self sectionForItem:item];
    for(NSInteger i = 0; i < self.allMultiItem.count; i++){
        
        if([self.allMultiItem[i] isEqualToItem:item]) {
            
            return self.allMultiItem[i];
        }
    }
    return nil;
}

- (NSInteger)sectionForItem:(RWMultiItem *)item; {

    RWMultiItem *tmpItem = item;
    while(tmpItem.superitem){
    
        tmpItem = tmpItem.superitem;
    }
    if(tmpItem.level == -1){
    
        return tmpItem.tag;
    }else {
    
        return NSNotFound;
    }
}

#pragma mark - Done
- (NSIndexPath *)indexPathForItem:(RWMultiItem *)item {
    
    
    for(NSInteger i = 0; i < self.sectionDataSourseArray.count; i++ ){
        
        NSInteger row = [self.sectionDataSourseArray[i] indexPathForItem:item];
        if(row != NSNotFound){
        
            return [NSIndexPath indexPathForRow:row inSection:i];;
        }
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    typedef void(^WillDisplayCellBlockType)(RWMultiTableView *tableView,UITableViewCell *cell,NSInteger section, RWMultiItem *item);
//    typedef void(^DidEndDisplayingCellBlockType)(RWMultiTableView *tableView,UITableViewCell *cell,NSInteger section, RWMultiItem *item);
    
    __weak typeof (self) weakSelf = self;
    if(self.willDisplayCellBlock){
    
        RWMultiDataSourse *dataSource = self.sectionDataSourseArray[indexPath.section];
        RWMultiItem *item = [dataSource itemforIndexPath:indexPath.row];
        
        self.willDisplayCellBlock(weakSelf, cell, indexPath, item);
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    __weak typeof (self) weakSelf = self;
    if(self.didEndDisplayingCellBlock){
        
        RWMultiDataSourse *dataSource = self.sectionDataSourseArray[indexPath.section];
        RWMultiItem *item = [dataSource itemforIndexPath:indexPath.row];
        
        self.didEndDisplayingCellBlock(weakSelf, cell, indexPath, item);
    }
}

- (void)dealloc {

}

- (void)scrollToItem:(RWMultiItem *)item; {

    // RWMultiItem *tmpItem = [self searchItemWithItem:item];
    
    if(item){
        [self openSectionWithItem:item];
        NSIndexPath *indexPath= [self indexPathForItem:item];
        if(indexPath) {
            if([self numberOfRowsInSection:indexPath.section] > indexPath.row && [self numberOfRowsInSection:indexPath.section] > 0) {
                [self scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            }
        }
    }
}

- (void)openSectionWithItem:(RWMultiItem *)item; {
    
    // RWMultiItem *searchItem = [self searchItemWithItem:item];
    
    if(item) {
    
        NSInteger sectionIndex = [self sectionForItem:item];
        if(sectionIndex < self.sectionDataSourseArray.count) {
            
            RWMultiDataSourse *dataSource = self.sectionDataSourseArray[sectionIndex];
            if(!dataSource.isOpen){
            
                [dataSource installAll];
            }
            
        }
    }
}

- (void)enumerateAllItem:(EnumerateAllItemBlockType)enumerateBlock; {

    if(enumerateBlock) {
    
        for(NSInteger i = 0; i < self.allMultiItem.count; i++) {
        
            if(!enumerateBlock(self,self.allMultiItem[i])) {
            
                return;
            }
        }
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(self.scrollViewDidScrollBlock) {
        self.scrollViewDidScrollBlock(scrollView);
    }
}

@end
