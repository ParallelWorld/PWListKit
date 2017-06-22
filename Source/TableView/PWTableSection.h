//
//  PWTableSection.h
//  PWListKitDemo
//
//  Created by Huang Wei on 2017/3/20.
//  Copyright © 2017年 Parallel World. All rights reserved.
//

#import "PWListNode.h"
#import "PWListMacros.h"
#import "IGListDiffKit.h"


NS_ASSUME_NONNULL_BEGIN

@class PWTableRow, PWTableHeaderFooter;

/// Table section model
PWLK_SUBCLASSING_RESTRICTED
@interface PWTableSection : PWListNode <IGListDiffable>

@property (nonatomic, readonly) PWTableHeaderFooter *header;
@property (nonatomic, readonly) PWTableHeaderFooter *footer;

/// section index
@property (nonatomic, readonly) NSUInteger sectionIndex;

////////////////////////////////////////////////////////////////////////////////
#pragma mark - 数据操作

// 增
- (void)addRow:(PWTableRow *)row;
- (void)insertRow:(PWTableRow *)row atIndex:(NSUInteger)idx;

// 删
- (void)removeRowAtIndex:(NSUInteger)idx;
- (void)removeRow:(PWTableRow *)row;
- (void)clearAllRows;///只是清空rows，但不删除对应的section对象
- (void)clearAllRowsWithRemoveSection:(BOOL)shouldRemove; ///清空rows，并删除对应的section对象

// 改
- (void)moveRowFrom:(NSUInteger)from to:(NSUInteger)to;
- (void)updateRowAtIndex:(NSUInteger)idx withBlock:(void (^)(PWTableRow *__nullable row))block;

// 查
- (nullable PWTableRow *)rowAtIndex:(NSUInteger)idx;

////////////////////////////////////////////////////////////////////////////////


- (void)configureHeader:(void (^)(PWTableHeaderFooter *header))block;
- (void)configureFooter:(void (^)(PWTableHeaderFooter *footer))block;

@end

NS_ASSUME_NONNULL_END
