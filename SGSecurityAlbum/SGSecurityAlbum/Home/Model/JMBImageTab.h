//
//  JMBImageTab.h
//  SGSecurityAlbum
//
//  Created by 张传奇 on 16/8/18.
//  Copyright © 2016年 soulghost. All rights reserved.
//

#import "LKDBModel.h"

@interface JMBImageTab : LKDBModel
/** ID */
@property (nonatomic, copy)NSString * imageID;
/** 图片名称 */
@property (nonatomic, copy)NSString * ImageName;
/** 存入时间 */
@property (nonatomic, copy)NSString * SaveTime;
/** 文件夹 */
@property (nonatomic, copy)NSString * SaveFinder;

/** 原始图片资源 */
@property (nonatomic)NSData * OrgImageData;
/** 原始图片资源 */
@property (nonatomic)NSData * ThumbImageData;
@end
