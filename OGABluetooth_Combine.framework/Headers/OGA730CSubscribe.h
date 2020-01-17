//
//  OGA730CSubscribe.h
//  OGABluetooth730C
//
//  Created by apple on 2019/10/22.
//  Copyright © 2019 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OGA730CRespond.h"

typedef void (^OGA730CRespondBlock)(OGA730CRespond *respond);

@interface OGA730CSubscribe : NSObject

@property (nonatomic, copy) OGA730CRespondBlock respondBlock;

@end

