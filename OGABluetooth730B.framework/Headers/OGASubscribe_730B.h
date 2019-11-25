//
//  OGASubscribe_730B.h
//  OGAChair-730B
//
//  Created by ogawa on 2019/10/21.
//  Copyright © 2019 Hlin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OGARespond_730B.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^OGA730RespondBlock)(OGARespond_730B *respond);

typedef void (^OGA730OffRespondBlock)(OGARespond_730B *offRespond);

@interface OGASubscribe_730B : NSObject

@property (nonatomic, copy) OGA730RespondBlock respondBlock;

@property (nonatomic, copy) OGA730OffRespondBlock respondOffBlock;

@end

NS_ASSUME_NONNULL_END
