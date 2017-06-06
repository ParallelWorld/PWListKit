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
#import <objc/runtime.h>


static inline void pw_dispatch_block_into_main_queue(void (^block)()) {
    if ([NSThread mainThread]) {
        block();
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            block();
        });
    }
}


@interface PWTableAdapterProxy : NSProxy

- (instancetype)initWithTableDataSourceTarget:(id<UITableViewDataSource>)dataSource
                          tableDelegateTarget:(id<UITableViewDelegate>)delegate
                                  interceptor:(id)interceptor;

@end



/**
 Define messages that you want the PWTableModel object to intercept. Pattern copied from
 https://github.com/facebook/AsyncDisplayKit/blob/7b112a2dcd0391ddf3671f9dcb63521f554b78bd/AsyncDisplayKit/ASCollectionView.mm#L34-L53
 */
static BOOL isInterceptedSelector(SEL sel) {
    return (
            // UITableViewDataSource
            sel == @selector(tableView:cellForRowAtIndexPath:) ||
            sel == @selector(tableView:numberOfRowsInSection:) ||
            sel == @selector(numberOfSectionsInTableView:) ||
            // UITableViewDelegate
            sel == @selector(tableView:heightForRowAtIndexPath:) ||
            sel == @selector(tableView:heightForHeaderInSection:) ||
            sel == @selector(tableView:heightForFooterInSection:) ||
            sel == @selector(tableView:viewForHeaderInSection:) ||
            sel == @selector(tableView:viewForFooterInSection:)
            );
}

@implementation PWTableAdapterProxy {
    __weak id _tableDataSourceTarget;
    __weak id _tableDelegateTarget;
    __weak id _interceptor;
}

- (instancetype)initWithTableDataSourceTarget:(id<UITableViewDataSource>)dataSource
                          tableDelegateTarget:(id<UITableViewDelegate>)delegate
                                  interceptor:(id)interceptor {
    NSParameterAssert(interceptor);
    
    // -[NSProxy init] is undefined
    _tableDataSourceTarget = dataSource;
    _tableDelegateTarget = delegate;
    _interceptor = interceptor;
    
    return self;
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    return isInterceptedSelector(aSelector)
    || [_tableDataSourceTarget respondsToSelector:aSelector]
    || [_tableDelegateTarget respondsToSelector:aSelector];
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    if (isInterceptedSelector(aSelector)) {
        return _interceptor;
    }
    if ([_tableDelegateTarget respondsToSelector:aSelector]) {
        return _tableDelegateTarget;
    }
    return _tableDataSourceTarget;
}

// handling unimplemented methods and nil target/interceptor
// https://github.com/Flipboard/FLAnimatedImage/blob/76a31aefc645cc09463a62d42c02954a30434d7d/FLAnimatedImage/FLAnimatedImage.m#L786-L807
- (void)forwardInvocation:(NSInvocation *)invocation {
    void *nullPointer = NULL;
    [invocation setReturnValue:&nullPointer];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector {
    return [NSObject instanceMethodSignatureForSelector:@selector(init)];
}

@end









@interface PWTableAdapter () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) PWListNode *rootNode;
@property (nonatomic) PWTableAdapterProxy *delegateProxy; ///< 包含tableView的dataSource和delegate
@property (nonatomic) NSMutableSet *registeredCellClasses;
@property (nonatomic) NSMutableSet *registeredHeaderFooterClasses;

@end



@implementation PWTableAdapter

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
    _tableView.adapter = self;
    
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

- (void)removeSectionAtIndex:(NSUInteger)index {
    [self.rootNode removeChildAtIndex:index];
}

- (void)removeSection:(PWTableSection *)section {
    [self.rootNode removeChild:section];
}

- (PWTableRow *)rowAtIndexPath:(NSIndexPath *)indexPath {
    return [[self.rootNode childAtIndex:indexPath.section] childAtIndex:indexPath.row];
}

- (PWTableSection *)sectionAtIndex:(NSUInteger)index {
    return [self.rootNode childAtIndex:index];
}

- (PWTableSection *)sectionWithTag:(NSString *)tag {
    NSArray *sections = self.rootNode.children;
    for (PWTableSection *section in sections) {
        if ([section.tag isEqualToString:tag]) {
            return section;
        }
    }
    return nil;
}

- (void)clearAllSections {
    [self.rootNode removeAllChildren];
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


#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PWTableRow *row = [self rowAtIndexPath:indexPath];
    
    [self registerCellClassForRowIfNeeded:row];
    
    UITableViewCell<PWTableCellConfigureProtocol> *cell = [tableView dequeueReusableCellWithIdentifier:row.reuseIdentifier forIndexPath:indexPath];
    
    if ([self.delegate respondsToSelector:@selector(tableAdapter:willConfigureCell:)]) {
        [self.delegate tableAdapter:self willConfigureCell:cell];
    }
    
    cell.row = row;
    [cell populateData:row.data];
    
    if ([self.delegate respondsToSelector:@selector(tableAdapter:didConfigureCell:)]) {
        [self.delegate tableAdapter:self didConfigureCell:cell];
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.rootNode childAtIndex:section].children.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.rootNode.children.count;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PWTableRow *row = [self rowAtIndexPath:indexPath];
    if (!row) return 0;

    if (row.height > 0) return row.height;
    
    [self registerCellClassForRowIfNeeded:row];

    return [self.tableView pw_heightForCellWithIdentifier:row.reuseIdentifier cacheByIndexPath:indexPath configuration:^(UITableViewCell<PWTableCellConfigureProtocol> *cell) {
        [cell populateData:row.data];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [self heightForHeaderFooter:[self sectionAtIndex:section].header];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return [self heightForHeaderFooter:[self sectionAtIndex:section].footer];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [self viewForHeaderFooter:[self sectionAtIndex:section].header];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [self viewForHeaderFooter:[self sectionAtIndex:section].footer];
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
    
    if (!emptyView) return;
    
    if (emptyView != _tableView.backgroundView) {
        [_tableView.backgroundView removeFromSuperview];
        _tableView.backgroundView = emptyView;
    }
    _tableView.backgroundView.hidden = ![self isTableEmpty];
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

- (void)registerCellClassForRowIfNeeded:(PWTableRow *)row {
    Class clazz = row.clazz;
    NSString *className = NSStringFromClass(clazz);
    
    if ([self.registeredCellClasses containsObject:clazz]) {
        return;
    }
    
    NSString *nibPath = [[NSBundle mainBundle] pathForResource:className ofType:@"nib"];
    if (nibPath) {
        [self.tableView registerNib:[UINib nibWithNibName:className bundle:nil] forCellReuseIdentifier:row.reuseIdentifier];
    } else {
        [self.tableView registerClass:clazz forCellReuseIdentifier:row.reuseIdentifier];
    }
    
    [self.registeredCellClasses addObject:clazz];
}

- (void)registerHeaderFooterClassForHeaderFooterIfNeeded:(PWTableHeaderFooter *)headerFooter {
    Class clazz = headerFooter.clazz;
    NSString *className = NSStringFromClass(clazz);
    
    if ([self.registeredHeaderFooterClasses containsObject:clazz]) {
        return;
    }
    
    NSString *nibPath = [[NSBundle mainBundle] pathForResource:className ofType:@"nib"];
    if (nibPath) {
        [self.tableView registerNib:[UINib nibWithNibName:className bundle:nil] forHeaderFooterViewReuseIdentifier:headerFooter.reuseIdentifier];
    } else {
        [self.tableView registerClass:clazz forHeaderFooterViewReuseIdentifier:headerFooter.reuseIdentifier];
    }
    
    [self.registeredHeaderFooterClasses addObject:clazz];
}

- (UIView *)viewForHeaderFooter:(PWTableHeaderFooter *)headerFooter {

    if (!headerFooter) return nil;
        
    [self registerHeaderFooterClassForHeaderFooterIfNeeded:headerFooter];
    
    UITableViewHeaderFooterView<PWTableHeaderFooterConfigureProtocol> *headerFooterView = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:headerFooter.reuseIdentifier];

    [headerFooterView populateData:headerFooter.data];
    
    return headerFooterView;
}

- (CGFloat)heightForHeaderFooter:(PWTableHeaderFooter *)headerFooter {
    
    if (!headerFooter) return 0;
    
    if (headerFooter.height > 0) return headerFooter.height;
    
    [self registerHeaderFooterClassForHeaderFooterIfNeeded:headerFooter];
    
    return [self.tableView pw_heightForHeaderWithIdentifier:headerFooter.reuseIdentifier cacheBySection:headerFooter.section configuration:^(UITableViewHeaderFooterView<PWTableHeaderFooterConfigureProtocol> *view) {
        [view populateData:headerFooter.data];
    }];
}

@end



@implementation UITableView (PWAdapter)

- (PWTableAdapter *)adapter {
    PWTableAdapter *adapter = objc_getAssociatedObject(self, _cmd);
    if (!adapter) {
        adapter = [[PWTableAdapter alloc] initWithTableView:self];
        objc_setAssociatedObject(self, _cmd, adapter, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return adapter;
}

- (void)setAdapter:(PWTableAdapter *)adapter {
    if (adapter.tableView != self) return;
    objc_setAssociatedObject(self, @selector(adapter), adapter, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end