//
//  PWTableRow.h
//  PWListKitDemo
//
//  Created by Huang Wei on 2017/3/20.
//  Copyright © 2017年 Parallel World. All rights reserved.
//

#import "PWListNode.h"
#import <UIKit/UIKit.h>

/// Table cell配置协议
@protocol PWTableCellConfigureProtocol <NSObject>

@required
- (void)populateData:(id)data;

@optional
+ (CGFloat)cellHeight;

@end


/// Table row model.
@interface PWTableRow : PWListNode

/// Row 对应的 cell class
@property (nonatomic) Class<PWTableCellConfigureProtocol> clazz;

/// 可以直接设置cellHeight，也可以在cell中覆写cellHeight类方法
/// 优先级是[tableItem cellHeight] > [cellClass cellHeight]
/// 默认是0
@property (nonatomic) CGFloat height;

@property (nonatomic, readonly) NSString *reuseIdentifier;

@end
