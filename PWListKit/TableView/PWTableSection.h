//
//  PWTableSection.h
//  PWListKitDemo
//
//  Created by Huang Wei on 2017/3/20.
//  Copyright © 2017年 Parallel World. All rights reserved.
//

#import "PWListNode.h"

NS_ASSUME_NONNULL_BEGIN

@class PWTableRow, PWTableHeaderFooter, PWTableContext;

/// Table section model.
@interface PWTableSection : PWListNode

/// Table context
@property (nonatomic, weak) PWTableContext *context;

@property (nonatomic, readonly) PWTableHeaderFooter *sectionHeader;
@property (nonatomic, readonly) PWTableHeaderFooter *sectionFooter;

@property (nonatomic, readonly) NSUInteger section;

- (void)addRow:(void (^)(PWTableRow *row))block;
- (void)insertRow:(void (^)(PWTableRow *row))block atIndex:(NSUInteger)index;
- (void)removeRowAtIndex:(NSUInteger)index;
- (PWTableRow *)rowAtIndex:(NSUInteger)index;
- (void)clearAllRows;


- (void)setHeader:(void (^)(PWTableHeaderFooter *header))block;
- (void)setFooter:(void (^)(PWTableHeaderFooter *footer))block;

@end

NS_ASSUME_NONNULL_END
