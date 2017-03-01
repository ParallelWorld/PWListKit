//
//  PWTableModelProxy.h
//  PWListKitDemo
//
//  Created by Huang Wei on 2017/3/1.
//  Copyright © 2017年 Parallel World. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface PWTableModelProxy : NSProxy

- (instancetype)initWithTableDataSourceTarget:(id<UITableViewDataSource>)tableDataSourceTarget
                          TableDelegateTarget:(id<UITableViewDelegate>)tableDelegateTarget
                                  interceptor:(id)interceptor;

@end

NS_ASSUME_NONNULL_END
