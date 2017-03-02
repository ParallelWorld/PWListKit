//
//  PWListItem.h
//  PWListKitDemo
//
//  Created by Huang Wei on 2017/3/1.
//  Copyright © 2017年 Parallel World. All rights reserved.
//

#import "PWListNode.h"
#import <UIKit/UIKit.h>


@interface PWListItem : PWListNode

@end



@interface PWTableItem : PWListItem

/// row对应的cellClass
/// cell必须满足PWTableCellProtocol协议
@property (nonatomic) Class cellClass;

/// 可以直接设置cellHeight，也可以在cell中覆写cellHeight类方法
/// 如果cellHeight是0，则使用的AutoLayout自动算高
@property (nonatomic) CGFloat cellHeight;

@property (nonatomic) id data;

@property (nonatomic, readonly) NSString *cellIdentifier;

@end




@interface PWCollectionItem : PWListItem

/// cell必须满足PWTableCellProtocol协议
@property (nonatomic, assign) Class cellClass;

@property (nonatomic) CGFloat cellHeight;

@property (nonatomic) id data;

@property (nonatomic, copy, readonly) NSString *cellIdentifier;

@property (nonatomic) CGSize size;

@end

