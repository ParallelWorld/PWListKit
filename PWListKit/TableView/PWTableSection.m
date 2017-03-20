//
//  PWTableSection.m
//  PWListKitDemo
//
//  Created by Huang Wei on 2017/3/20.
//  Copyright © 2017年 Parallel World. All rights reserved.
//

#import "PWTableSection.h"
#import "PWTableRow.h"
#import "PWTableHeaderFooter.h" 
#import "PWTableContext.h"


@implementation PWTableSection

- (void)addRow:(void (^)(PWTableRow * _Nonnull))block {
    PWTableRow *row = [PWTableRow new];
    block(row);
    [self addChild:row];
    [self registerCellClassForRow:row];
}

- (void)insertRow:(void (^)(PWTableRow * _Nonnull))block atIndex:(NSUInteger)index {
    PWTableRow *row = [PWTableRow new];
    block(row);
    [self insertChild:row atIndex:index];
    [self registerCellClassForRow:row];
}

- (void)removeRowAtIndex:(NSUInteger)index {
    [self removeChildAtIndex:index];
}

- (PWTableRow *)rowAtIndex:(NSUInteger)index {
    return [self childAtIndex:index];
}

- (void)clearAllRows {
    [self removeAllChildren];
}

- (NSInteger)numberOfRows {
    return self.children.count;
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

- (void)registerCellClassForRow:(PWTableRow *)row {
    Class clazz = row.cellClass;
    NSAssert(clazz, @"注册的cellClass不能为空");
    NSString *className = NSStringFromClass(clazz);
    
    if ([self.context.registeredCellClasses containsObject:clazz]) {
        return;
    }
    
    NSString *nibPath = [[NSBundle mainBundle] pathForResource:className ofType:@"nib"];
    if (nibPath) {
        [self.context.tableView registerNib:[UINib nibWithNibName:className bundle:nil] forCellReuseIdentifier:row.cellIdentifier];
    } else {
        [self.context.tableView registerClass:clazz forCellReuseIdentifier:row.cellIdentifier];
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

