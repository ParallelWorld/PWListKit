//
//  PWTableRow.h
//  PWListKitDemo
//
//  Created by Huang Wei on 2017/3/20.
//  Copyright © 2017年 Parallel World. All rights reserved.
//

#import "PWListNode.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class PWTableRow;

/// Table cell配置协议
@protocol PWTableCellConfigureProtocol <NSObject>

@required
- (void)updateWithRow:(PWTableRow *)row;

@end

/// cell的位置
typedef NS_ENUM(NSUInteger, PWTableRowPosition) {
    PWTableRowPositionDefault,
    PWTableRowPositionTop,
    PWTableRowPositionMiddle,
    PWTableRowPositionBottom,
    PWTableRowPositionSingle,
};


@interface PWTableRow : PWListNode

/// row对应的cell class，这个必须要设置，否则会报异常
@property (nonatomic) Class<PWTableCellConfigureProtocol> clazz;

/// cell在section中的位置
@property (nonatomic) PWTableRowPosition position;

/// 如果height<=0，则使用autolayout计算高度，否则直接使用height。默认是0。
@property (nonatomic) CGFloat height;

@property (nonatomic, readonly) NSString *reuseIdentifier;

@property (nonatomic, readonly) NSIndexPath *indexPath;

@end

NS_ASSUME_NONNULL_END
