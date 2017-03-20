//
//  PWTableSection.h
//  PWListKitDemo
//
//  Created by Huang Wei on 2017/3/20.
//  Copyright © 2017年 Parallel World. All rights reserved.
//

#import "PWListSection.h"

NS_ASSUME_NONNULL_BEGIN

@class PWTableRow, PWTableHeaderFooter;

/// Table section model.
@interface PWTableSection : PWListSection

/// Table context
@property (nonatomic, weak) PWTableContext *context;


- (void)addRow:(void (^)(PWTableRow *row))block;
- (void)insertRow:(void (^)(PWTableRow *row))block atIndex:(NSUInteger)index;
- (void)removeRowAtIndex:(NSUInteger)index;
- (PWTableRow *)rowAtIndex:(NSUInteger)index;
- (void)clearAllRows;


- (NSInteger)numberOfRows;


@property (nonatomic, readonly) PWTableHeaderFooter *sectionHeader;
@property (nonatomic, readonly) PWTableHeaderFooter *sectionFooter;

- (void)setHeader:(void (^)(PWTableHeaderFooter *header))block;
- (void)setFooter:(void (^)(PWTableHeaderFooter *footer))block;

@end

NS_ASSUME_NONNULL_END
