//
//  PWTableHeaderFooter.h
//  PWListKitDemo
//
//  Created by Huang Wei on 2017/2/28.
//  Copyright © 2017年 Parallel World. All rights reserved.
//

#import "PWListNode.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class PWTableHeaderFooter, PWTableSection;

/// Table header footer配置协议
@protocol PWTableHeaderFooterConfigureProtocol <NSObject>
@required
- (void)updateWithHeaderFooter:(PWTableHeaderFooter *)headerFooter;
@end


@interface PWTableHeaderFooter : PWListNode

- (instancetype)initWithSection:(PWTableSection *)section NS_DESIGNATED_INITIALIZER;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;


/// 如果height<=0，则使用autolayout计算高度，否则直接使用height。默认是0。
@property (nonatomic) CGFloat height;

/// row对应的header footer class，这个必须要设置，否则会报异常
@property (nonatomic) Class<PWTableHeaderFooterConfigureProtocol> clazz;

@property (nonatomic, readonly) NSString *reuseIdentifier;

/// Header footer 所在的 section
@property (nonatomic, weak, readonly) PWTableSection *section;

@end

NS_ASSUME_NONNULL_END
