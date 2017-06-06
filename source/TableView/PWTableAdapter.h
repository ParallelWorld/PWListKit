//
//  PWTableModel.h
//  Demo
//
//  Created by Huang Wei on 2017/2/27.
//  Copyright © 2017年 Parallel World. All rights reserved.
//

#import "PWListNode.h"
#import <UIKit/UIkit.h>


NS_ASSUME_NONNULL_BEGIN


@class PWTableSection;
@class PWTableRow;
@class PWTableAdapter;


@protocol PWTableAdapterDataSource <NSObject>

@optional
- (nullable UIView *)emptyViewForTableAdapter:(PWTableAdapter *)adapter;

@end

@protocol PWTableAdapterDelegate <NSObject>

@optional
- (void)tableAdapter:(PWTableAdapter *)adapter willConfigureCell:(UITableViewCell *)cell;
- (void)tableAdapter:(PWTableAdapter *)adapter didConfigureCell:(UITableViewCell *)cell;

// TODO header footer view configure

@end




/// Table adapter是table view的适配器，实现`UITableViewDataSource`和`UITableViewDelegate`的部分方法。
///
/// 简化使用table view的成本，去掉大部分的胶水代码。
@interface PWTableAdapter : NSObject

- (instancetype)initWithTableView:(UITableView *)tableView NS_DESIGNATED_INITIALIZER;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@property (nonatomic, weak, readonly) UITableView *tableView;


@property (nonatomic, weak, nullable) id<PWTableAdapterDataSource> dataSource;
@property (nonatomic, weak, nullable) id<PWTableAdapterDelegate> delegate;
@property (nonatomic, weak, nullable) id<UITableViewDataSource> tableDataSource;
@property (nonatomic, weak, nullable) id<UITableViewDelegate> tableDelegate;



- (void)addSection:(void (^)(PWTableSection *section))block;
- (void)insertSection:(void (^)(PWTableSection *section))block atIndex:(NSUInteger)index;

- (void)removeSectionAtIndex:(NSUInteger)index;
- (void)removeSection:(PWTableSection *)section;

- (void)clearAllSections;

- (PWTableRow *)rowAtIndexPath:(NSIndexPath *)indexPath;
- (PWTableSection *)sectionAtIndex:(NSUInteger)index;

/// 根据自定义的tag来索引对应的section
- (PWTableSection *)sectionWithTag:(NSString *)tag;


- (void)reloadTableView;
- (void)reloadTableViewWithCompletion:(nullable void(^)(void))completion;
- (void)reloadRowAtIndexPath:(NSIndexPath *)indexPath withRowAnimation:(UITableViewRowAnimation)animation;
- (void)reloadSectionAtIndex:(NSUInteger)index withRowAnimation:(UITableViewRowAnimation)animation;

@end




@interface UITableView (PWAdapter)

@property (nonatomic) PWTableAdapter *adapter;

@end

NS_ASSUME_NONNULL_END
