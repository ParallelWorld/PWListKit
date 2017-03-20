//
//  UITableView+PWAdapter.h
//  PWListKitDemo
//
//  Created by 黄魏 on 2017/3/20.
//  Copyright © 2017年 Parallel World. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PWTableAdapter;

@interface UITableView (PWAdapter)

@property (nonatomic, readonly) PWTableAdapter *adapter;

@end
