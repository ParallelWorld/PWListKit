//
//  PWTableSection.h
//  PWListKitDemo
//
//  Created by Huang Wei on 2017/3/20.
//  Copyright © 2017年 Parallel World. All rights reserved.
//

#import "PWListNode.h"
#import "PWListMacros.h"

NS_ASSUME_NONNULL_BEGIN

@class PWTableRow, PWTableHeaderFooter;

/// Table section model
PWLK_SUBCLASSING_RESTRICTED
@interface PWTableSection : PWListNode

@property (nonatomic, readonly) PWTableHeaderFooter *header;
@property (nonatomic, readonly) PWTableHeaderFooter *footer;

@property (nonatomic, readonly) NSUInteger section;

- (void)addRow:(void (^)(PWTableRow *row))block;
- (void)insertRow:(void (^)(PWTableRow *row))block atIndex:(NSUInteger)index;
- (void)removeRowAtIndex:(NSUInteger)index;
- (PWTableRow *)rowAtIndex:(NSUInteger)index;
- (void)clearAllRows;

- (void)configureHeader:(void (^)(PWTableHeaderFooter *header))block;
- (void)configureFooter:(void (^)(PWTableHeaderFooter *footer))block;

@end

NS_ASSUME_NONNULL_END
