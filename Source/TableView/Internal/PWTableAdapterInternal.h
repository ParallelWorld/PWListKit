//
//  PWTableAdapterInternal.h
//  PWListKit
//
//  Created by Huang Wei on 2017/6/13.
//  Copyright © 2017年 Parallel World. All rights reserved.
//

#import "PWListNode.h"

@class PWTableAdapterProxy;
@class PWListNode;

@interface PWTableAdapter ()

@property (nonatomic) PWListNode *rootNode;                         ///< 数据源的根结点
@property (nonatomic) PWTableAdapterProxy *delegateProxy;           ///< 包含tableView的dataSource和delegate
@property (nonatomic) NSMutableSet *registeredCellClasses;          ///< 注册过的cell class
@property (nonatomic) NSMutableSet *registeredHeaderFooterClasses;  ///< 注册过的headerfooter class

@property (nonatomic) BOOL isDiffing;

- (instancetype)initWithTableView:(UITableView *)tableView NS_DESIGNATED_INITIALIZER;

@end
