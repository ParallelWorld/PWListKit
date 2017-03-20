//
//  PWTableHeaderFooter.h
//  PWListKitDemo
//
//  Created by Huang Wei on 2017/2/28.
//  Copyright © 2017年 Parallel World. All rights reserved.
//

#import "PWListNode.h"
#import <UIKit/UIKit.h>


/// Table header footer配置协议
@protocol PWTableHeaderFooterConfigureProtocol <NSObject>

@required
- (void)populateData:(id)data;

@optional
+ (CGFloat)headerFooterHeight;

@end


/// Table header footer model.
@interface PWTableHeaderFooter : PWListNode

@property (nonatomic, readonly) NSString *reuseIdentifier;

/// 可以直接设置headerFooterHeight，也可以在headerFooterView中覆写headerFooterHeight类方法
/// 优先级是[headerFooter headerFooterHeight] > [headerFooterClass headerFooterHeight]
/// 默认是0
@property (nonatomic) CGFloat height;

@property (nonatomic) Class<PWTableHeaderFooterConfigureProtocol> clazz;

@end
