//
//  PWCollectionAdapterProxy.m
//  PWListKitDemo
//
//  Created by Huang Wei on 2017/3/1.
//  Copyright © 2017年 Parallel World. All rights reserved.
//

#import "PWCollectionAdapterProxy.h"

/**
 Define messages that you want the PWTableModel object to intercept. Pattern copied from
 https://github.com/facebook/AsyncDisplayKit/blob/7b112a2dcd0391ddf3671f9dcb63521f554b78bd/AsyncDisplayKit/ASCollectionView.mm#L34-L53
 */
static BOOL isInterceptedSelector(SEL sel) {
    return (
            // UICollectionViewDataSource
            sel == @selector(collectionView:cellForItemAtIndexPath:) ||
            sel == @selector(collectionView:numberOfItemsInSection:) ||
            sel == @selector(numberOfSectionsInCollectionView:) ||
            // UICollectionViewDelegate
            // UICollectionViewDelegateFlowLayout
            sel == @selector(collectionView:layout:sizeForItemAtIndexPath:)
            );
}

@implementation PWCollectionAdapterProxy {
    __weak id _collectionDataSourceTarget;
    __weak id _collectionDelegateTarget;
    __weak id _interceptor;
}

- (instancetype)initWithCollectionDataSourceTarget:(id<UICollectionViewDataSource>)dataSource
                          collectionDelegateTarget:(id<UICollectionViewDelegate>)delegate
                                       interceptor:(id)interceptor {
    NSAssert(interceptor, @"interceptor不能为nil");
    
    _collectionDataSourceTarget = dataSource;
    _collectionDelegateTarget = delegate;
    _interceptor = interceptor;
    
    return self;
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    return isInterceptedSelector(aSelector)
    || [_collectionDataSourceTarget respondsToSelector:aSelector]
    || [_collectionDelegateTarget respondsToSelector:aSelector];
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    if (isInterceptedSelector(aSelector)) {
        return _interceptor;
    }
    if ([_collectionDelegateTarget respondsToSelector:aSelector]) {
        return _collectionDelegateTarget;
    }
    return _collectionDataSourceTarget;
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
