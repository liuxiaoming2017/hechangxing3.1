//
//  OGA530Subscribe.h
//  OGAChair-530
//
//  Created by ogawa on 2019/8/7.
//  Copyright © 2019 Hlin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OGA530Respond.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^OGA530RespondBlock)(OGA530Respond *respond);

typedef void (^OGA530OffRespondBlock)(OGA530Respond *offRespond);


@interface OGA530Subscribe : NSObject

@property (nonatomic, copy) OGA530RespondBlock respondBlock;

@property (nonatomic, copy) OGA530OffRespondBlock respondOffBlock;

@end

NS_ASSUME_NONNULL_END
