//
//  PWListMacros.h
//  PWListKit
//
//  Created by Huang Wei on 2017/6/6.
//  Copyright © 2017年 Parallel World. All rights reserved.
//

#ifndef PWLK_SUBCLASSING_RESTRICTED
    #if defined(__has_attribute) && __has_attribute(objc_subclassing_restricted)
        #define PWLK_SUBCLASSING_RESTRICTED __attribute__((objc_subclassing_restricted))
    #else
        #define PWLK_SUBCLASSING_RESTRICTED
    #endif
#endif

static inline void pwlk_dispatch_block_into_main_queue(void (^block)()) {
    if ([NSThread mainThread]) {
        block();
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            block();
        });
    }
}
