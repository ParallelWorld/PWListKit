//
//  PWListSection.h
//  PWListKitDemo
//
//  Created by Huang Wei on 2017/3/1.
//  Copyright © 2017年 Parallel World. All rights reserved.
//

#import "PWListNode.h"

@class PWTableRow, PWTableHeaderFooter;
@class PWListItem;
@class PWTableRow;

@class PWTableContext, PWCollectionContext;
@class PWCollectionItem;


/// Base list section.
@interface PWListSection : PWListNode

@property (nonatomic) id data;

/// 标记section
@property (nonatomic, copy) NSString *tag;

- (void)addItem:(void (^)(__kindof PWListItem *item))block;
- (void)insertItem:(void (^)(__kindof PWListItem *item))block atIndex:(NSUInteger)index;
- (void)removeItemAtIndex:(NSUInteger)index;
- (__kindof PWListItem*)rowAtIndex:(NSUInteger)index;
- (void)clearAllRows;

- (NSInteger)numberOfItems;

- (Class)listItemClass;
- (void)registerCellClassForItem:(__kindof PWListItem *)item;

@end





