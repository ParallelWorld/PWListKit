//
//  PWCollectionAdapterProxy.h
//  PWListKitDemo
//
//  Created by Huang Wei on 2017/3/1.
//  Copyright © 2017年 Parallel World. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PWCollectionAdapterProxy : NSProxy

- (instancetype)initWithCollectionDataSourceTarget:(id<UICollectionViewDataSource>)dataSource
                          collectionDelegateTarget:(id<UICollectionViewDelegate>)delegate
                                       interceptor:(id)interceptor;

@end
