#import "DWTableView.h"

@interface DWTableView ()

@end

@implementation DWTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)resetDelegate
{
    self.delegate = self;
    self.dataSource = self;
}

//- (nullable UITableViewHeaderFooterView *)headerViewForSection:(NSInteger)section
//{
//    [super headerViewForSection:section];
//    if(self.headerViewForSectionBlock) {
//        return self.headerViewForSectionBlock(section);
//    }
//    return nil;
//}
//
//- (nullable UITableViewHeaderFooterView *)footerViewForSection:(NSInteger)section
//{
//    [super footerViewForSection:section];
//    if(self.footerViewForSectionBlock) {
//        return self.footerViewForSectionBlock(section);
//    }
//    return nil;
//}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.tableViewNumberOfRowsInSection) {
        return self.tableViewNumberOfRowsInSection(tableView, section);
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath* )indexPath
{
    if (self.tableViewCellForRowAtIndexPath) {
        return self.tableViewCellForRowAtIndexPath(tableView, indexPath);
    }
    
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.numberOfSectionsInTableView) {
        return self.numberOfSectionsInTableView(tableView);
    }
    return 1;
}

//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (self.tableViewCanEditRowAtIndexPath) {
//        return self.tableViewCanEditRowAtIndexPath(tableView, indexPath);
//    }
//    
//    return NO;
//}
//- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    // fixed font style. use custom view (UILabel) if you want something different
//    if(self.tableViewTitleForHeaderInSection) {
//        return self.tableViewTitleForHeaderInSection(tableView, section);
//    }
//    return @"";
//}
//
//- (nullable NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
//{
//    if(self.tableViewTitlForFooterInSection) {
//        return self.tableViewTitlForFooterInSection(tableView, section);
//    }
//    return @"";
//}
//
//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (self.tableViewEditingStyleForRowAtIndexPath) {
//        return self.tableViewEditingStyleForRowAtIndexPath(tableView, indexPath);
//    }
//    return UITableViewCellEditingStyleNone;
//}
//
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (self.tableViewCommitEditingStyleforRowAtIndexPath) {
//        return self.tableViewCommitEditingStyleforRowAtIndexPath(tableView, editingStyle, indexPath);
//    }
//}

- (void)deleteRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation
{
    if (self.tableViewDeleteRowsAtIndexPaths) {
        return self.tableViewDeleteRowsAtIndexPaths(indexPaths, animation);
    }
}

-(void)tableView:(UITableView*)tableView willDisplayCell:(nonnull UITableViewCell *)cell forRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (self.tableViewWillDisplayCellForRowAtIndexPath) {
        return self.tableViewWillDisplayCellForRowAtIndexPath(tableView, cell, indexPath);
    }
}

-(void)tableView:(UITableView*)tableView didEndDisplayingCell:(nonnull UITableViewCell *)cell forRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if(self.tablViewDidEndDisplayingCellForRowAtIndexPath) {
        return self.tablViewDidEndDisplayingCellForRowAtIndexPath(tableView, cell, indexPath);
    }
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.tableViewDidSelectRowAtIndexPath) {
        return self.tableViewDidSelectRowAtIndexPath(tableView, indexPath);
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.tableViewDidDeselectRowAtIndexPath) {
        return self.tableViewDidDeselectRowAtIndexPath(tableView, indexPath);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.tableViewHeightForRowAtIndexPath) {
        return self.tableViewHeightForRowAtIndexPath(tableView, indexPath);
    }
    else
    {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(self.tableViewHeightForHeaderInSection)
    {
        return self.tableViewHeightForHeaderInSection(tableView, section);
    }
    else
    {
        return 0;
    }
}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    if(self.tableViewHeightForFooterInSection) {
//        return self.tableViewHeightForFooterInSection(tableView, section);
//    }
//    return 0;
//}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    // custom view for header. will be adjusted to default or specified header height
    if(self.tableViewViewForHeaderInSection)
    {
        return self.tableViewViewForHeaderInSection(tableView, section);
    }
    return [[UIView alloc] init];
}

//- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    // custom view for footer. will be adjusted to default or specified footer height
//    if(self.tableViewViewForFooterInSection) {
//        return self.tableViewViewForFooterInSection(tableView, section);
//    }
//    return [[UIView alloc] init];
//}


@end
