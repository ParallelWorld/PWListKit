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
#import "PWListNodeInternal.h"

@implementation PWTableSection

- (void)addRow:(PWTableRow *)row {
    [self addChild:row];
}

- (void)insertRow:(PWTableRow *)row atIndex:(NSUInteger)idx {
    [self insertChild:row atIndex:idx];
}

- (void)removeRow:(PWTableRow *)row {
    [self removeChild:row];
}

- (void)removeRowAtIndex:(NSUInteger)idx {
    [self removeChildAtIndex:idx];
}

- (void)clearAllRows {
    [self clearAllRowsWithRemoveSection:NO];
}

- (void)clearAllRowsWithRemoveSection:(BOOL)shouldRemove {
    if (shouldRemove) {
        [self.parent removeFromParent];
    }
    [self removeAllChildren];
}

- (void)moveRowFrom:(NSUInteger)from to:(NSUInteger)to {
    [self moveChildFrom:from to:to];
}

- (void)updateRowAtIndex:(NSUInteger)idx withBlock:(void (^)(PWTableRow * _Nullable))block {
    
}

- (PWTableRow *)rowAtIndex:(NSUInteger)idx {
    return [self childAtIndex:idx];
}

- (NSUInteger)sectionIndex {
    return self.parent.index;
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



#pragma mark - IGListDiffable

- (id<NSObject>)diffIdentifier {
    if (!self.tag || [self.tag isEqualToString:@""]) {
        return self;
    }
    return self.tag;
}

- (BOOL)isEqualToDiffableObject:(PWTableSection *)object {
    IGListIndexPathResult *result = IGListDiffPaths(self.sectionIndex, object.sectionIndex, self.children, object.children, IGListDiffEquality);
    return !result.hasChanges;
}

#pragma mark - Life

- (id)copyWithZone:(NSZone *)zone {
    PWTableSection *copy = [[PWTableSection allocWithZone:zone] init];
    if (copy != nil) {
        copy.tag = [self.tag copy];
        copy.innerChildren = [self.innerChildren mutableCopy];
    }
    return copy;
}


@end

