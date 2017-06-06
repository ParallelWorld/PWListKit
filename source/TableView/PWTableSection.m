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

@implementation PWTableSection

- (void)addRow:(void (^)(PWTableRow * _Nonnull))block {
    PWTableRow *row = [PWTableRow new];
    [self addChild:row];
    block(row);
}

- (void)insertRow:(void (^)(PWTableRow * _Nonnull))block atIndex:(NSUInteger)index {
    PWTableRow *row = [PWTableRow new];
    [self insertChild:row atIndex:index];
    block(row);
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

- (NSUInteger)section {
    return self.index;
}

- (void)configureHeader:(void (^)(PWTableHeaderFooter * _Nonnull))block {
    if (!_header) {
        _header = [[PWTableHeaderFooter alloc] initWithSection:self];
    }
    block(_header);
}

- (void)configureFooter:(void (^)(PWTableHeaderFooter * _Nonnull))block {
    if (!_footer) {
        _footer = [[PWTableHeaderFooter alloc] initWithSection:self];
    }
    block(_footer);
}

@end

