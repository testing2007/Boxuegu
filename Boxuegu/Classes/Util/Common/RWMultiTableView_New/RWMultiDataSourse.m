//
//  RWMTVDataSource.m
//  ;
//
//  Created by HM on 2017/4/21.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "RWMultiDataSourse.h"

@implementation RWMultiDataSourse

- (instancetype)init{

    self = [super init];
    if (self){
    
        self.currentItems = [NSMutableArray new];
    }
    return self;
}
- (NSInteger)tagForIndexPath:(NSUInteger)indexPath {
    
    return [self itemforIndexPath:indexPath].tag;

}
- (RWMultiItem *)itemforIndexPath:(NSUInteger)indexPath {
    if(self.currentItems.count <= indexPath) {
    
        return nil;
    }
    return self.currentItems[indexPath];
}

- (NSUInteger)indexPathForItem:(RWMultiItem *)item {

    return [self.currentItems indexOfObject:item];
}
- (void)close:(NSUInteger)indexPath {

    [self closeItem:[self itemforIndexPath:indexPath]];
}

- (void)closeItem:(RWMultiItem *)item {

    for(NSInteger i = 0; i < item.subitems.count; i++) {
    
        item.isOpen = false;
        [self closeRemove:item.subitems[i]];
    }
    
    //[self.currentItems removeObject:item];
}

-(void)closeRemove:(RWMultiItem *)item {

    for(NSInteger i = 0; i < item.subitems.count; i++) {
        
        item.isOpen = false;
        [self closeRemove:item.subitems[i]];
    }
    
    [self.currentItems removeObject:item];
}

-(void)openRecursiveForIndexPath:(NSUInteger)indexPath
{
    RWMultiItem *item = [self itemforIndexPath:indexPath];
    [self openRecursiveForItem:item];
    
}

-(void)openForIndexPath:(NSUInteger)indexPath
{
    RWMultiItem *item = [self itemforIndexPath:indexPath];
    [self openForItem:item];
}

- (void)openRecursiveForItem:(RWMultiItem *)item {

    NSUInteger indexPath = [self indexPathForItem:item];
    item.isOpen = true;
    
    for(NSInteger i = 0; i < item.subitems.count; i++)
    {
        [self.currentItems insertObject:item.subitems[i] atIndex:indexPath + i + 1];
    }
    
    for(NSInteger i = 0; i < item.subitems.count; i++)
    {
        [self openRecursiveForItem:item.subitems[i]];
    }
    
}

- (void)openForItem:(RWMultiItem *)item {
    
    NSUInteger indexPath = [self indexPathForItem:item];
     item.isOpen = true;
    
    for(NSInteger i = 0; i < item.subitems.count; i++)
    {
        [self.currentItems insertObject:item.subitems[i] atIndex:indexPath + i + 1];
    }
    
}
// 控制根
- (void)removeAll {

    self.isOpen = false;
    [self.currentItems removeAllObjects];
}
- (void)installRoot {
    
    self.isOpen = true;
    [self.currentItems addObjectsFromArray:self.subitems];
}
- (void)installAll; {

    self.isOpen = true;
    [self.currentItems addObjectsFromArray:self.subitems];
    for (NSInteger i = 0; i < self.subitems.count; i++) {
   
        [self openRecursiveForItem:self.subitems[i]];
        
    }
}
- (void)installSubItemChild; {
    
    self.isOpen = true;
    [self.currentItems addObjectsFromArray:self.subitems];
    for (NSInteger i = 0; i < self.subitems.count; i++) {
        
        [self openRecursiveForItem:self.subitems[i]];
        
    }
    [self.currentItems  removeObjectsInArray:self.subitems];
    
}

- (NSInteger)levelForIndexPath:(NSUInteger)indexPath {
    return [self itemforIndexPath:indexPath].level;
}

- (void)removeItem:(RWMultiItem *)item; {

    if(item.isOpen) {
    
        [self.currentItems removeObject:item];
    }
    
    if(item.superitem) {
    
        NSMutableArray *subitems = item.superitem.subitems;
        if(subitems) {
            
            [subitems removeObject:item];
        }
    }
}


@end
