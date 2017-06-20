//
//  PWListNodeInternal.h
//  PWListKit
//
//  Created by Huang Wei on 2017/6/20.
//  Copyright © 2017年 Parallel World. All rights reserved.
//

#import "PWListNode.h"

@interface PWListNode ()
@property (nonatomic) NSMutableArray *innerChildren;
@property (nonatomic) NSLock *lock;
@end
