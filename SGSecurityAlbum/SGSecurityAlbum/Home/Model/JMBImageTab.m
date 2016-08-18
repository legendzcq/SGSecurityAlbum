//
//  JMBImageTab.m
//  SGSecurityAlbum
//
//  Created by 张传奇 on 16/8/18.
//  Copyright © 2016年 soulghost. All rights reserved.
//

#import "JMBImageTab.h"
#import "LKDBTool.h"
@implementation JMBImageTab
//必须重写此方法
+ (NSDictionary *)describeColumnDict{
    LKDBColumnDes *imageID = [LKDBColumnDes new];
    //设置主键
    imageID.primaryKey = YES;
    imageID.notNull = YES;
    
    return @{@"imageID":imageID};
}
@end
