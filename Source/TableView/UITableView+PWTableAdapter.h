//
//  UITableView+PWTableAdapter.h
//  PWListKit
//
//  Created by Huang Wei on 2017/6/21.
//  Copyright © 2017年 Parallel World. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PWTableAdapter;

@interface UITableView (PWTableAdapter)

/// 一个table view对应一个adapter，使用懒加载。
@property (nonatomic, readonly) PWTableAdapter *adapter;

@end
