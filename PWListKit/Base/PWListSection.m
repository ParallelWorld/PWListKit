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



