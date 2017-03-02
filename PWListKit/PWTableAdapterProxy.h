//
//  PWTableAdapterProxy.h
//  PWListKitDemo
//
//  Created by Huang Wei on 2017/3/1.
//  Copyright © 2017年 Parallel World. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface PWTableAdapterProxy : NSProxy

- (instancetype)initWithTableDataSourceTarget:(id<UITableViewDataSource>)dataSource
                          tableDelegateTarget:(id<UITableViewDelegate>)delegate
                                  interceptor:(id)interceptor;

@end

NS_ASSUME_NONNULL_END
