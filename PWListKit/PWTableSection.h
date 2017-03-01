//
//  PWTableSection.h
//  Demo
//
//  Created by Huang Wei on 2017/2/27.
//  Copyright © 2017年 Parallel World. All rights reserved.
//

#import "PWNode.h"
#import <UIKit/UIKit.h>

@class PWTableRow, PWTableHeaderFooter;

NS_ASSUME_NONNULL_BEGIN

@interface PWTableSection : PWNode

@property (nonatomic) id data;

/// 标识tableSection
@property (nonatomic, copy) NSString *identifier;

- (void)addRow:(void (^)(PWTableRow *row))block;
- (void)insertRow:(void (^)(PWTableRow *row))block atIndex:(NSUInteger)index;

- (void)removeRowAtIndex:(NSUInteger)index;

- (void)clearAllRows;


@property (nonatomic, readonly) PWTableHeaderFooter *sectionHeader;
@property (nonatomic, readonly) PWTableHeaderFooter *sectionFooter;

- (void)setHeader:(void (^)(PWTableHeaderFooter *header))block;
- (void)setFooter:(void (^)(PWTableHeaderFooter *footer))block;

@end

NS_ASSUME_NONNULL_END
