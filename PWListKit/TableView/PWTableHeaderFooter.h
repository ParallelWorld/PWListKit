//
//  PWTableHeaderFooter.h
//  PWListKitDemo
//
//  Created by Huang Wei on 2017/2/28.
//  Copyright © 2017年 Parallel World. All rights reserved.
//

#import "PWListNode.h"
#import <UIKit/UIKit.h>


@interface PWTableHeaderFooter : PWListNode

@property (nonatomic, readonly) NSString *headerFooterIdentifier;

/// headerFooter对应的headerFooterClass
/// headerFooter必须是`UITableViewHeaderFooterView`子类
/// 必须满足`PWListConfigurationProtocol`协议
@property (nonatomic) Class headerFooterClass;

@property (nonatomic) id data;

@property (nonatomic) CGFloat height;

@end
