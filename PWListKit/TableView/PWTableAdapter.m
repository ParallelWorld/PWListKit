//
//  PWTableModel.m
//  Demo
//
//  Created by Huang Wei on 2017/2/27.
//  Copyright © 2017年 Parallel World. All rights reserved.
//

#import "PWTableAdapter.h"
#import "PWTableRow.h"
#import "PWTableSection.h"
#import "PWTableHeaderFooter.h"
#import "PWTableContext.h"
#import "UITableView+PWTemplateLayoutCell.h"
#import "PWTableAdapterProxy.h"



static inline void pw_dispatch_block_into_main_queue(void (^block)()) {
    if ([NSThread mainThread]) {
        block();
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            block();
        });
    }
}



@interface PWTableAdapter () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) PWTableContext *context;
@property (nonatomic) PWTableAdapterProxy *delegateProxy; ///< 包含tableView的dataSource和delegate

@end



@implementation PWTableAdapter

- (void)dealloc {
    // on iOS 9 setting the dataSource has side effects that can invalidate the layout and seg fault
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 9.0) {
        // properties are assign for <iOS 9
        _tableView.dataSource = nil;
        _tableView.delegate = nil;
    }
}

- (instancetype)initWithTableView:(UITableView *)tableView {
    
    self = [super init];
    
    NSAssert(tableView, @"tableView不能为nil");
    
    _tableView = tableView;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    _context = [PWTableContext new];
    _context.tableView = tableView;
    _context.registeredCellClasses = [NSMutableSet new];
    _context.registeredHeaderFooterClasses = [NSMutableSet new];
    
    return self;
}

- (void)setTableDataSource:(id<UITableViewDataSource>)tableDataSource {
    if (_tableDataSource != tableDataSource) {
        _tableDataSource = tableDataSource;
        [self updateTableProxy];
    }
}

- (void)setTableDelegate:(id<UITableViewDelegate>)tableDelegate {
    if (_tableDelegate != tableDelegate) {
        _tableDelegate = tableDelegate;
        [self updateTableProxy];
    }
}

- (void)addSection:(void (^)(PWTableSection *section))block {
    PWTableSection *section = [PWTableSection new];
    section.context = self.context;
    block(section);
    [self addChild:section];
}

- (void)insertSection:(void (^)(PWTableSection * _Nonnull))block atIndex:(NSUInteger)index {
    PWTableSection *section = [PWTableSection new];
    section.context = self.context;
    block(section);
    [self insertChild:section atIndex:index];
}

- (void)removeSectionAtIndex:(NSUInteger)index {
    [self removeChildAtIndex:index];
}

- (void)removeSectionsAtIndexSet:(NSIndexSet *)indexSet {
    [self removeChildrenAtIndexSet:indexSet];
}

- (void)removeSection:(PWTableSection *)section {
    [self removeChild:section];
}

- (PWTableRow *)rowAtIndexPath:(NSIndexPath *)indexPath {
    return [[self childAtIndex:indexPath.section] childAtIndex:indexPath.row];
}

- (PWTableSection *)sectionAtIndex:(NSUInteger)index {
    return [self childAtIndex:index];
}

- (PWTableSection *)sectionWithTag:(NSString *)tag {
    NSArray *sections = self.children;
    for (PWTableSection *section in sections) {
        if ([section.tag isEqualToString:tag]) {
            return section;
        }
    }
    return nil;
}

- (void)clearAllSections {
    [self removeAllChildren];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    id<UITableViewDataSource> dataSource = self.tableDataSource;
    if ([dataSource respondsToSelector:@selector(tableView:cellForRowAtIndexPath:)]) {
        return [dataSource tableView:tableView cellForRowAtIndexPath:indexPath];
    }
    
    PWTableRow *item = [self rowAtIndexPath:indexPath];
    UITableViewCell<PWTableCellConfigureProtocol> *cell = [tableView dequeueReusableCellWithIdentifier:item.reuseIdentifier forIndexPath:indexPath];
    [cell populateData:item.data];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    id<UITableViewDataSource> dataSource = self.tableDataSource;
    if ([dataSource respondsToSelector:@selector(tableView:numberOfRowsInSection:)]) {
        return [dataSource tableView:tableView numberOfRowsInSection:section];
    }
    
    return [self numberOfRowsInSection:section];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    id<UITableViewDataSource> dataSource = self.tableDataSource;
    if ([dataSource respondsToSelector:@selector(numberOfSectionsInTableView:)]) {
        return [dataSource numberOfSectionsInTableView:tableView];
    }
    
    return [self numberOfSections];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    id<UITableViewDelegate> delegate = self.tableDelegate;
    if ([delegate respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)]) {
        return [delegate tableView:tableView heightForRowAtIndexPath:indexPath];
    }
    
    return [self heightForRowAtIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    id<UITableViewDelegate> delegate = self.tableDelegate;
    if ([delegate respondsToSelector:@selector(tableView:heightForHeaderInSection:)]) {
        return [delegate tableView:tableView heightForHeaderInSection:section];
    }
    
    return [self heightForHeaderInSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    id<UITableViewDelegate> delegate = self.tableDelegate;
    if ([delegate respondsToSelector:@selector(tableView:heightForFooterInSection:)]) {
        return [delegate tableView:tableView heightForFooterInSection:section];
    }
    
    return [self heightForFooterInSection:section];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    id<UITableViewDelegate> delegate = self.tableDelegate;
    if ([delegate respondsToSelector:@selector(tableView:viewForHeaderInSection:)]) {
        return [delegate tableView:tableView viewForHeaderInSection:section];
    }
    
    PWTableSection *tableSection = [self sectionAtIndex:section];
    
    PWTableHeaderFooter *header = tableSection.sectionHeader;
    if (!header) {
        return nil;
    }
    Class clazz = header.clazz;

    UITableViewHeaderFooterView<PWTableHeaderFooterConfigureProtocol> *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:header.reuseIdentifier];
    if (!headerView) {
        headerView = [[clazz alloc] initWithReuseIdentifier:header.reuseIdentifier];
    }
    [headerView populateData:header.data];
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    id<UITableViewDelegate> delegate = self.tableDelegate;
    if ([delegate respondsToSelector:@selector(tableView:viewForFooterInSection:)]) {
        return [delegate tableView:tableView viewForFooterInSection:section];
    }
    
    PWTableSection *tableSection = [self sectionAtIndex:section];
    
    PWTableHeaderFooter *footer = tableSection.sectionFooter;
    if (!footer) {
        return nil;
    }
    Class clazz = footer.clazz;
    UITableViewHeaderFooterView<PWTableHeaderFooterConfigureProtocol> *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:footer.reuseIdentifier];
    if (!footerView) {
        footerView = [[clazz alloc] initWithReuseIdentifier:footer.reuseIdentifier];
    }
    [footerView populateData:footer.data];
    return footerView;
}

#pragma mark - PWTableModel+UITableView

- (NSInteger)numberOfSections {
    return self.children.count;
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section {
    return [self childAtIndex:section].children.count;
}

- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PWTableRow *row = [self rowAtIndexPath:indexPath];
    if (!row) {
        return 0;
    }
    
    if (row.height > 0) return row.height;

    return [self.tableView pw_heightForCellWithIdentifier:row.reuseIdentifier cacheByIndexPath:indexPath configuration:^(UITableViewCell<PWTableCellConfigureProtocol> *cell) {
        [cell populateData:row.data];
    }];
}

- (CGFloat)heightForHeaderInSection:(NSInteger)section {
    
    PWTableSection *tableSection = [self sectionAtIndex:section];
    PWTableHeaderFooter *header = tableSection.sectionHeader;
    
    if (!header) {
        return 0;
    }
    
    if (header.height > 0) {
        return header.height;
    }
    
    return [self.tableView pw_heightForHeaderWithIdentifier:header.reuseIdentifier cacheBySection:section configuration:^(UITableViewHeaderFooterView<PWTableHeaderFooterConfigureProtocol> *headerView) {
        [headerView populateData:header.data];
    }];
}

- (CGFloat)heightForFooterInSection:(NSInteger)section {
    PWTableSection *tableSection = [self sectionAtIndex:section];
    PWTableHeaderFooter *footer = tableSection.sectionFooter;
    
    if (!footer) {
        return 0;
    }
    
    if (footer.height > 0) {
        return footer.height;
    }
    
    return [self.tableView pw_heightForFooterWithIdentifier:footer.reuseIdentifier cacheBySection:section configuration:^(UITableViewHeaderFooterView<PWTableHeaderFooterConfigureProtocol> *footerView) {
        [footerView populateData:footer.data];
    }];
}

- (void)reloadTableView {
    [self reloadTableViewWithCompletion:nil];
}

- (void)reloadTableViewWithCompletion:(void (^)(void))completion {
    pw_dispatch_block_into_main_queue(^{
        // 此处是为了解决`FDTemplateLayoutCell`的tableView宽度为0导致cell高度计算不准确的bug
        if (self.tableView.frame.size.width == 0) {
            [self.tableView layoutIfNeeded];
        }
        [self.tableView reloadData];
        [self updateTableEmptyView];

        /// 此处是为了解决 table view 刷新时间可能较长，无法获取正确的结束时刻的bug
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) {
                completion();
            }
        });
    });
}

- (void)reloadRowAtIndexPath:(NSIndexPath *)indexPath withRowAnimation:(UITableViewRowAnimation)animation {
    pw_dispatch_block_into_main_queue(^{
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:animation];
        
        [self updateTableEmptyView];
    });
}

- (void)reloadSectionAtIndex:(NSUInteger)index withRowAnimation:(UITableViewRowAnimation)animation {
    pw_dispatch_block_into_main_queue(^{
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:animation];
        
        [self updateTableEmptyView];
    });
}

#pragma mark - Private method

- (void)updateTableProxy {
    // there is a known bug with accessibility and using an NSProxy as the delegate that will cause EXC_BAD_ACCESS
    // when voiceover is enabled. it will hold an unsafe ref to the delegate
    _tableView.delegate = nil;
    _tableView.dataSource = nil;
    
    self.delegateProxy = [[PWTableAdapterProxy alloc] initWithTableDataSourceTarget:_tableDataSource tableDelegateTarget:_tableDelegate interceptor:self];
    
    // set up the delegate to the proxy so the adapter can intercept events
    // default to the adapter simply being the delegate
    _tableView.delegate = (id<UITableViewDelegate>)self.delegateProxy ?: self;
    _tableView.dataSource = (id<UITableViewDataSource>)self.delegateProxy ?: self;
}

- (void)updateTableEmptyView {
    
    UIView *emptyView = nil;
    if ([self.dataSource respondsToSelector:@selector(emptyViewForTableAdapter:)]) {
        emptyView = [self.dataSource emptyViewForTableAdapter:self];
    }
    if (!emptyView) {
        return;
    }
    
    if (emptyView != _tableView.backgroundView) {
        [_tableView.backgroundView removeFromSuperview];
        _tableView.backgroundView = emptyView;
    }
    _tableView.backgroundView.hidden = ![self isTableEmpty];
}

- (BOOL)isTableEmpty {
    if (self.numberOfSections == 0) {
        return YES;
    }
    
    NSArray<PWTableSection *> *sections = self.children;
    for (PWTableSection *section in sections) {
        if ([section numberOfRows] != 0) {
            return NO;
        }
    }

    return YES;
}

@end
