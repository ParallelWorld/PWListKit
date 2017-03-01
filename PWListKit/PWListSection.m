//
//  PWListSection.m
//  PWListKitDemo
//
//  Created by Huang Wei on 2017/3/1.
//  Copyright © 2017年 Parallel World. All rights reserved.
//

#import "PWListSection.h"
#import "PWListContext.h"
#import "PWListItem.h"
#import "PWTableHeaderFooter.h"

@implementation PWListSection

- (Class)listItemClass {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (void)addItem:(void (^)(__kindof PWListItem *item))block {
    id item = [self.listItemClass new];
    block(item);
    [self addChild:item];
    [self registerCellClassForItem:item];
}

- (void)insertItem:(void (^)(__kindof PWListItem *item))block atIndex:(NSUInteger)index {
    id item = [self.listItemClass new];
    block(item);
    [self insertChild:item atIndex:index];
    [self registerCellClassForItem:item];
}

- (void)removeItemAtIndex:(NSUInteger)index {
    [self removeChildAtIndex:index];
}

- (__kindof PWListItem*)rowAtIndex:(NSUInteger)index {
    return [self childAtIndex:index];
}

- (void)clearAllRows {
    [self removeAllChildren];
}

- (NSInteger)numberOfItems {
    return self.children.count;
}

- (void)registerCellClassForItem:(__kindof PWListItem *)item {
    [self doesNotRecognizeSelector:_cmd];
}

@end



@implementation PWTableSection

- (Class)listItemClass {
    return [PWTableItem class];
}

- (void)setHeader:(void (^)(PWTableHeaderFooter * _Nonnull))block {
    PWTableHeaderFooter *header = [PWTableHeaderFooter new];
    block(header);
    [self m_registerHeaderFooterClassForHeaderFooter:header];
    _sectionHeader = header;
}

- (void)setFooter:(void (^)(PWTableHeaderFooter * _Nonnull))block {
    PWTableHeaderFooter *footer = [PWTableHeaderFooter new];
    block(footer);
    [self m_registerHeaderFooterClassForHeaderFooter:footer];
    _sectionFooter = footer;
}

- (void)registerCellClassForItem:(PWTableItem *)item {
    Class clazz = item.cellClass;
    NSAssert(clazz, @"注册的cellClass不能为nil");
    NSString *className = NSStringFromClass(clazz);
    
    if ([self.context.registeredCellClasses containsObject:clazz]) {
        return;
    }
    
    NSString *nibPath = [[NSBundle mainBundle] pathForResource:className ofType:@"nib"];
    if (nibPath) {
        [self.context.tableView registerNib:[UINib nibWithNibName:className bundle:nil] forCellReuseIdentifier:item.cellIdentifier];
    } else {
        [self.context.tableView registerClass:clazz forCellReuseIdentifier:item.cellIdentifier];
    }
    
    [self.context.registeredCellClasses addObject:clazz];
}

- (void)m_registerHeaderFooterClassForHeaderFooter:(PWTableHeaderFooter *)headerFooter {
    Class clazz = headerFooter.headerFooterClass;
    NSAssert(clazz, @"注册的headerFooterClass不能为nil");
    NSString *className = NSStringFromClass(clazz);
    
    if ([self.context.registeredHeaderFooterClasses containsObject:clazz]) {
        return;
    }
    
    NSString *nibPath = [[NSBundle mainBundle] pathForResource:className ofType:@"nib"];
    if (nibPath) {
        [self.context.tableView registerNib:[UINib nibWithNibName:className bundle:nil] forHeaderFooterViewReuseIdentifier:headerFooter.headerFooterIdentifier];
    } else {
        [self.context.tableView registerClass:clazz forHeaderFooterViewReuseIdentifier:headerFooter.headerFooterIdentifier];
    }
    
    [self.context.registeredHeaderFooterClasses addObject:clazz];
}

@end



@implementation PWCollectionSection

- (Class)listItemClass {
    return [PWCollectionItem class];
}

- (void)registerCellClassForItem:(__kindof PWCollectionItem *)item {
    Class clazz = item.cellClass;
    NSAssert(clazz, @"注册的cellClass不能为nil");
    NSString *className = NSStringFromClass(clazz);
    
    if ([self.context.registeredCellClasses containsObject:clazz]) {
        return;
    }
    
    NSString *nibPath = [[NSBundle mainBundle] pathForResource:className ofType:@"nib"];
    if (nibPath) {
        [self.context.collectionView registerNib:[UINib nibWithNibName:className bundle:nil] forCellWithReuseIdentifier:item.cellIdentifier];
    } else {
        [self.context.collectionView registerClass:clazz forCellWithReuseIdentifier:item.cellIdentifier];
    }
    
    [self.context.registeredCellClasses addObject:clazz];
}

@end
