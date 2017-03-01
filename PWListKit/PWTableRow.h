//
//  PWTableRow.h
//  Demo
//
//  Created by Huang Wei on 2017/2/27.
//  Copyright © 2017年 Parallel World. All rights reserved.
//

#import "PWNode.h"
#import "PWTableCellProtocol.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PWTableRow : PWNode

/// row对应的cellClass
/// cell必须满足PWTableCellProtocol协议
@property (nonatomic) Class cellClass;

/// 可以直接设置cellHeight，也可以在cell中覆写cellHeight类方法
/// 如果cellHeight是0，则使用的AutoLayout自动算高
@property (nonatomic) CGFloat cellHeight;

@property (nonatomic) id data;

@property (nonatomic, readonly) NSString *cellIdentifier;

@end

NS_ASSUME_NONNULL_END
