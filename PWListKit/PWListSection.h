//
//  PWListSection.h
//  PWListKitDemo
//
//  Created by Huang Wei on 2017/3/1.
//  Copyright © 2017年 Parallel World. All rights reserved.
//

#import "PWListNode.h"

@class PWTableItem, PWTableHeaderFooter;
@class PWListItem;
@class PWTableItem;

@class PWTableContext, PWCollectionContext;
@class PWCollectionItem;


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




@interface PWTableSection : PWListSection

@property (nonatomic) PWTableContext *context;

@property (nonatomic, readonly) PWTableHeaderFooter *sectionHeader;
@property (nonatomic, readonly) PWTableHeaderFooter *sectionFooter;

- (void)setHeader:(void (^)(PWTableHeaderFooter *header))block;
- (void)setFooter:(void (^)(PWTableHeaderFooter *footer))block;

@end



@interface PWCollectionSection : PWListSection

@property (nonatomic) PWCollectionContext *context;

@end
