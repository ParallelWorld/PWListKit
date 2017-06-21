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
#import "UITableView+PWTemplateLayoutCell.h"

#import "PWTableAdapterInternal.h"
#import "PWTableAdapterProxy.h"
#import "PWTableAdapter+UITableView.h"

#import "PWListNodeInternal.h"

@implementation PWTableAdapter

#pragma mark - Life

- (void)dealloc {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 9.0) {
        _tableView.dataSource = nil;
        _tableView.delegate = nil;
    }
}

- (instancetype)initWithTableView:(UITableView *)tableView {
    self = [super init];
    
    NSParameterAssert(tableView);
    
    _rootNode = [PWListNode new];
    
    _tableView = tableView;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    _registeredCellClasses = [NSMutableSet new];
    _registeredHeaderFooterClasses = [NSMutableSet new];
    
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

#pragma mark - 增

- (void)addSection:(void (^)(PWTableSection *section))block {
    PWTableSection *section = [PWTableSection new];
    [self.rootNode addChild:section];
    block(section);
}

- (void)insertSection:(void (^)(PWTableSection * _Nonnull))block atIndex:(NSUInteger)index {
    PWTableSection *section = [PWTableSection new];
    [self.rootNode insertChild:section atIndex:index];
    block(section);
}

#pragma mark - 删
- (void)removeSectionAtIndex:(NSUInteger)index {
    [self.rootNode removeChildAtIndex:index];
}

- (void)removeSection:(PWTableSection *)section {
    [self.rootNode removeChild:section];
}
- (void)clearAllSections {
    [self.rootNode removeAllChildren];
}
#pragma mark - 改

- (void)moveSectionFrom:(NSUInteger)from to:(NSUInteger)to {
    [self.rootNode moveChildFrom:from to:to];
}

- (void)updateSectionAtIndex:(NSUInteger)idx withBlock:(void (^)(PWTableSection * _Nullable))block {
    PWTableSection *s = [self sectionAtIndex:idx];
    block(s);
}

#pragma mark - 查

- (PWTableRow *)rowAtIndexPath:(NSIndexPath *)indexPath {
    return [[self.rootNode childAtIndex:indexPath.section] childAtIndex:indexPath.row];
}

- (PWTableSection *)sectionAtIndex:(NSUInteger)index {
    return [self.rootNode childAtIndex:index];
}

- (PWTableSection *)sectionWithTag:(NSString *)tag {
    return [[self sectionsWithTag:tag] firstObject];
}

- (NSArray<PWTableSection *> *)sectionsWithTag:(NSString *)tag {
    NSMutableArray *sections = [NSMutableArray new];
    NSArray *children = self.rootNode.children;
    for (PWTableSection *s in children) {
        if ([s.tag isEqualToString:tag]) {
            [sections addObject:s];
        }
    }
    return sections.copy;
}

#pragma mark - 更新table view

- (void)updateTableViewWithActions:(void (^)(PWTableAdapter * _Nonnull))actions animation:(UITableViewRowAnimation)animation completion:(void (^)(void))completion {
    // 如果actions为空，则直接调用table view的`reloadData`方法
    if (!actions) {
        [self reloadTableViewWithCompletion:completion];
        return;
    }
    
    // 计算diff
    IGListBatchUpdateData *updateData = [self calculateDiffWithActions:actions];
    
    // 更新table view
    [self applyBatchUpdateData:updateData];
}


- (void)reloadTableView {
    [self reloadTableViewWithCompletion:nil];
}

- (void)reloadTableViewWithCompletion:(void (^)(void))completion {
    pwlk_dispatch_block_into_main_queue(^{
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

- (IGListBatchUpdateData *)calculateDiffWithActions:(void (^)(PWTableAdapter *))actions {
    // 1. 先记录旧数据
    NSMutableArray<PWTableSection *> *fromObjects = [self.rootNode.children mutableCopy];
    for (int i = 0; i < fromObjects.count; i++) {
        fromObjects[i] = [fromObjects[i] copy];
    }
    
    self.isDiffing = YES;
    // 2. 执行block
    actions(self);
    
    self.isDiffing = NO;
    // 3. 记录新数据
    NSMutableArray<PWTableSection *> *toObjects = [self.rootNode.children mutableCopy];
    // 4. 比较数据
    
    // sections
    IGListIndexSetResult *diffResult = IGListDiff(fromObjects, toObjects, IGListDiffEquality);
    
    //    diffResult = [diffResult resultForBatchUpdates];
    
    NSMutableIndexSet *inserts = [diffResult.inserts mutableCopy];
    NSMutableIndexSet *deletes = [diffResult.deletes mutableCopy];
    NSSet *moves = [[NSSet alloc] initWithArray:diffResult.moves];
    NSMutableIndexSet *updates = [diffResult.updates mutableCopy];
    
    NSMutableArray<NSIndexPath *> *itemInserts = [NSMutableArray new];
    NSMutableArray<NSIndexPath *> *itemDeletes = [NSMutableArray new];
    NSMutableArray<NSIndexPath *> *itemUpdates = [NSMutableArray new];
    NSMutableArray<IGListMoveIndexPath *> *itemMoves = [NSMutableArray new];
    
    [updates enumerateIndexesUsingBlock:^(NSUInteger oldIndex, BOOL *stop) {
        
        __block NSUInteger newIndex = NSNotFound;
        [moves enumerateObjectsUsingBlock:^(IGListMoveIndex *moveIndex, BOOL *moveStop) {
            if (moveIndex.from == oldIndex) {
                newIndex = moveIndex.to;
                *moveStop = YES;
            }
        }];
        
        IGListIndexPathResult *paths = IGListDiffPaths(oldIndex,
                                                       newIndex,
                                                       [fromObjects[oldIndex] children],
                                                       [toObjects[newIndex] children],
                                                       IGListDiffEquality);
        [itemInserts addObjectsFromArray:paths.inserts];
        [itemDeletes addObjectsFromArray:paths.deletes];
        [itemUpdates addObjectsFromArray:paths.updates];
        [itemMoves addObjectsFromArray:paths.moves];
    }];
    
    
    // merge
    IGListBatchUpdateData *updateData = [[IGListBatchUpdateData alloc] initWithInsertSections:inserts
                                                                               deleteSections:deletes
                                                                                 moveSections:moves
                                                                             insertIndexPaths:itemInserts
                                                                             deleteIndexPaths:itemDeletes
                                                                               moveIndexPaths:itemMoves];
    return updateData;
}

- (void)reloadRowAtIndexPath:(NSIndexPath *)indexPath withRowAnimation:(UITableViewRowAnimation)animation {
    pwlk_dispatch_block_into_main_queue(^{
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:animation];
        [self updateTableEmptyView];
    });
}

- (void)reloadSectionAtIndex:(NSUInteger)index withRowAnimation:(UITableViewRowAnimation)animation {
    pwlk_dispatch_block_into_main_queue(^{
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:animation];
        [self updateTableEmptyView];
    });
}

- (void)reloadTableWithBlock:(void (^)(void))block {
    // 1. 先记录旧数据
    NSMutableArray<PWTableSection *> *fromObjects = [self.rootNode.children mutableCopy];
    for (int i = 0; i < fromObjects.count; i++) {
        fromObjects[i] = [fromObjects[i] copy];
    }
    
    self.isDiffing = YES;
    // 2. 执行block
    block();
    
    self.isDiffing = NO;
    // 3. 记录新数据
    NSMutableArray<PWTableSection *> *toObjects = [self.rootNode.children mutableCopy];
    // 4. 比较数据
    
    // sections
    IGListIndexSetResult *diffResult = IGListDiff(fromObjects, toObjects, IGListDiffEquality);
    
//    diffResult = [diffResult resultForBatchUpdates];
    
    NSMutableIndexSet *inserts = [diffResult.inserts mutableCopy];
    NSMutableIndexSet *deletes = [diffResult.deletes mutableCopy];
    NSSet *moves = [[NSSet alloc] initWithArray:diffResult.moves];
    NSMutableIndexSet *updates = [diffResult.updates mutableCopy];

    NSMutableArray<NSIndexPath *> *itemInserts = [NSMutableArray new];
    NSMutableArray<NSIndexPath *> *itemDeletes = [NSMutableArray new];
    NSMutableArray<NSIndexPath *> *itemUpdates = [NSMutableArray new];
    NSMutableArray<IGListMoveIndexPath *> *itemMoves = [NSMutableArray new];
    
    [updates enumerateIndexesUsingBlock:^(NSUInteger oldIndex, BOOL *stop) {
        
        __block NSUInteger newIndex = NSNotFound;
        [moves enumerateObjectsUsingBlock:^(IGListMoveIndex *moveIndex, BOOL *moveStop) {
            if (moveIndex.from == oldIndex) {
                newIndex = moveIndex.to;
                *moveStop = YES;
            }
        }];
        
        IGListIndexPathResult *paths = IGListDiffPaths(oldIndex,
                                                       newIndex,
                                                       [fromObjects[oldIndex] children],
                                                       [toObjects[newIndex] children],
                                                       IGListDiffEquality);
        [itemInserts addObjectsFromArray:paths.inserts];
        [itemDeletes addObjectsFromArray:paths.deletes];
        [itemUpdates addObjectsFromArray:paths.updates];
        [itemMoves addObjectsFromArray:paths.moves];
    }];
    
    
    // merge
    IGListBatchUpdateData *updateData = [[IGListBatchUpdateData alloc] initWithInsertSections:inserts
                                                                               deleteSections:deletes
                                                                                 moveSections:moves
                                                                             insertIndexPaths:itemInserts
                                                                             deleteIndexPaths:itemDeletes
                                                                               moveIndexPaths:itemMoves];
    // 5. 刷新
    [self applyBatchUpdateData:updateData];
}

- (void)applyBatchUpdateData:(IGListBatchUpdateData *)updateData {
    [self.tableView beginUpdates];
    
    [self.tableView deleteRowsAtIndexPaths:updateData.deleteIndexPaths withRowAnimation:UITableViewRowAnimationTop];
    [self.tableView insertRowsAtIndexPaths:updateData.insertIndexPaths withRowAnimation:UITableViewRowAnimationTop];
    
    for (IGListMoveIndexPath *move in updateData.moveIndexPaths) {
        [self.tableView moveRowAtIndexPath:move.from toIndexPath:move.to];
    }
    
    for (IGListMoveIndex *move in updateData.moveSections) {
        [self.tableView moveSection:move.from toSection:move.to];
    }
    
    [self.tableView deleteSections:updateData.deleteSections withRowAnimation:UITableViewRowAnimationTop];
    [self.tableView insertSections:updateData.insertSections withRowAnimation:UITableViewRowAnimationTop];
    
    [self.tableView endUpdates];
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
    BOOL shouldHide = NO;
    
    if ([self.dataSource respondsToSelector:@selector(shouldHideEmptyViewForTableAdapter:)]) {
        shouldHide = [self.dataSource shouldHideEmptyViewForTableAdapter:self];
    } else {
        shouldHide = ![self isTableEmpty];
    }
    
    if (shouldHide) {
        [self hideEmptyView];
        return;
    }
    
    if ([self.dataSource respondsToSelector:@selector(emptyViewForTableAdapter:)]) {
        emptyView = [self.dataSource emptyViewForTableAdapter:self];
    }
    
    if (!emptyView) {
        [self hideEmptyView];
        return;
    }
    
    [self showEmptyView:emptyView];
    
    if (emptyView != _tableView.backgroundView) {
        [_tableView.backgroundView removeFromSuperview];
        _tableView.backgroundView = emptyView;
    }
    _tableView.backgroundView.hidden = ![self isTableEmpty];
}

- (void)hideEmptyView {
    _tableView.backgroundView.hidden = YES;
}

- (void)showEmptyView:(UIView *)view {
    if (view != _tableView.backgroundView) {
        [_tableView.backgroundView removeFromSuperview];
        _tableView.backgroundView = view;
    }
    _tableView.backgroundView.hidden = NO;
}

- (BOOL)isTableEmpty {
    if (self.rootNode.children.count == 0) {
        return YES;
    }
    
    NSArray<PWTableSection *> *sections = self.rootNode.children;
    for (PWTableSection *section in sections) {
        if (section.children.count != 0) {
            return NO;
        }
    }

    return YES;
}

@end
