//
//  HCY_FamilyListModel.h
//  和畅行
//
//  Created by 出神入化 on 2018/12/29.
//  Copyright © 2018 刘晓明. All rights reserved.
//

#import <Foundation/Foundation.h>


/*
 gender = <null>
 weight = <null>
 idcard = <null>
 birthday = <null>
 mobile =
 name = oD48ct2BfaaDLCIO70OTBtPZhj5M
 isMedicare = no
 createDate = 1545284630000
 modifyDate = 1545284630000
 id = 6098
 */
NS_ASSUME_NONNULL_BEGIN

@interface HCY_FamilyListModel : NSObject
@property( nonatomic , copy) NSString *gender;
@property( nonatomic , copy) NSString *birthday;
@property( nonatomic , copy) NSString *mobile;
@property( nonatomic , copy) NSString *name;
@property( nonatomic , copy) NSString *isMedicare;
@property( nonatomic , copy) NSString *familyID;
@property( nonatomic , copy) NSString *idcard;
@end

NS_ASSUME_NONNULL_END
