//
//  PWTableAdapterProxy.m
//  PWListKitDemo
//
//  Created by Huang Wei on 2017/3/1.
//  Copyright © 2017年 Parallel World. All rights reserved.
//

#import "PWTableAdapterProxy.h"

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

- (instancetype)initWithTableDataSourceTarget:(id<UITableViewDataSource>)tableDataSourceTarget TableDelegateTarget:(id<UITableViewDelegate>)tableDelegateTarget interceptor:(id)interceptor {
    NSAssert(interceptor, @"interceptor不能为nil");
    
    // -[NSProxy init] is undefined
    _tableDataSourceTarget = tableDataSourceTarget;
    _tableDelegateTarget = tableDelegateTarget;
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
