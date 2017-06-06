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
    PWTableHeaderFooter *header = [PWTableHeaderFooter new];
    block(header);
    header.section = self.section;
    _header = header;
}

- (void)configureFooter:(void (^)(PWTableHeaderFooter * _Nonnull))block {
    PWTableHeaderFooter *footer = [PWTableHeaderFooter new];
    block(footer);
    footer.section = self.section;
    _footer = footer;
}

@end

