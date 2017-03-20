//
//  TableHeaderView.h
//  PWListKitDemo
//
//  Created by Huang Wei on 2017/2/28.
//  Copyright © 2017年 Parallel World. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PWListKit.h"

@interface TableHeaderView : UITableViewHeaderFooterView <PWTableHeaderFooterConfigureProtocol>

@property (nonatomic) UILabel *middleTitleLabel;

@end
