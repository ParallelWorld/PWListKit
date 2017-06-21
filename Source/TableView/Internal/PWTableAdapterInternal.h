//
//  PWTableAdapterInternal.h
//  PWListKit
//
//  Created by Huang Wei on 2017/6/13.
//  Copyright © 2017年 Parallel World. All rights reserved.
//

#import "PWListNode.h"

@class PWTableAdapterProxy, PWListNode;

@interface PWTableAdapter ()

@property (nonatomic) PWListNode *rootNode; ///< 数据源的根结点
@property (nonatomic) PWTableAdapterProxy *delegateProxy; ///< 包含tableView的dataSource和delegate
@property (nonatomic) NSMutableSet *registeredCellClasses;
@property (nonatomic) NSMutableSet *registeredHeaderFooterClasses;

@property (nonatomic) NSArray *objects; // shuzu

@property (nonatomic) BOOL isDiffing;

@property (nonatomic) NSMutableArray *actions;

- (instancetype)initWithTableView:(UITableView *)tableView NS_DESIGNATED_INITIALIZER;

@end
