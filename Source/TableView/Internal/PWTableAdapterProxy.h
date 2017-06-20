//
//  PWTableAdapterProxy.h
//  PWListKit
//
//  Created by Huang Wei on 2017/6/13.
//  Copyright © 2017年 Parallel World. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PWTableAdapterProxy : NSProxy

- (instancetype)initWithTableDataSourceTarget:(nullable id<UITableViewDataSource>)dataSource
                          tableDelegateTarget:(nullable id<UITableViewDelegate>)delegate
                                  interceptor:(id)interceptor;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
