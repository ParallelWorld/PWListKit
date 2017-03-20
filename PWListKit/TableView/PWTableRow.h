//
//  PWTableRow.h
//  PWListKitDemo
//
//  Created by Huang Wei on 2017/3/20.
//  Copyright © 2017年 Parallel World. All rights reserved.
//

#import "PWListItem.h"
#import "PWListProtocol.h"


/// Table row model.
@interface PWTableRow : PWListItem

/// row对应的cellClass
/// cell必须满足`PWTableCellProtocol`协议
@property (nonatomic) Class<PWTableCellConfigurationProtocol> cellClass;

/// 可以直接设置cellHeight，也可以在cell中覆写cellHeight类方法
/// 优先级是[tableItem cellHeight] > [cellClass cellHeight]
/// 默认是`PWTableViewAutomaticDimension`
@property (nonatomic) CGFloat cellHeight;

@property (nonatomic) id data;

@property (nonatomic, readonly) NSString *cellIdentifier;

@end
