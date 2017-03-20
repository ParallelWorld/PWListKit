//
//  PWTableContext.h
//  PWListKitDemo
//
//  Created by Huang Wei on 2017/3/20.
//  Copyright © 2017年 Parallel World. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PWTableContext : NSObject

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic) NSMutableSet *registeredCellClasses;
@property (nonatomic) NSMutableSet *registeredHeaderFooterClasses;

@end
