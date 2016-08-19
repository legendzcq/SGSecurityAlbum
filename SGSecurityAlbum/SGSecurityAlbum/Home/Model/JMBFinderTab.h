//
//  JMBFinderTab.h
//  SGSecurityAlbum
//
//  Created by 张传奇 on 16/8/19.
//  Copyright © 2016年 soulghost. All rights reserved.
//

#import "LKDBModel.h"

@interface JMBFinderTab : LKDBModel
/** ID */
@property (nonatomic, copy)NSString * FinderID;
/** 文件夹 */
@property (nonatomic, copy)NSString * FinderName;
@end
