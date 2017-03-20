//
//  PWCollectionItem.h
//  PWListKitDemo
//
//  Created by Huang Wei on 2017/3/20.
//  Copyright © 2017年 Parallel World. All rights reserved.
//

#import "PWListItem.h"

@interface PWCollectionItem : PWListItem

/// cell必须满足PWTableCellProtocol协议
@property (nonatomic) Class cellClass;

@property (nonatomic) id data;

@property (nonatomic, copy, readonly) NSString *cellIdentifier;

@property (nonatomic) CGSize size;

@end
