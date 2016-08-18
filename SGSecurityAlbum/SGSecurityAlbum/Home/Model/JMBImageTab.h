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
@property (nonatomic, assign)int  imageID;
/** 图片名称 */
@property (nonatomic, copy)NSString * ImageName;
/** 存入时间 */
@property (nonatomic, copy)NSString * SaveTime;
/** 文件夹 */
@property (nonatomic, copy)NSString * SaveFinder;
/** 存入类型 0:缩略图 1:原始图片 */
@property (nonatomic, assign)int  SaveType;
/** 图片资源 */
@property (nonatomic)NSData * imageData;
@end
