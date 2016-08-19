//
//  JMBFinderTab.m
//  SGSecurityAlbum
//
//  Created by 张传奇 on 16/8/19.
//  Copyright © 2016年 soulghost. All rights reserved.
//

#import "JMBFinderTab.h"
#import "LKDBTool.h"
@implementation JMBFinderTab
//必须重写此方法
+ (NSDictionary *)describeColumnDict{
    LKDBColumnDes *FinderID = [LKDBColumnDes new];
    //设置主键
    FinderID.primaryKey = YES;
    FinderID.notNull = YES;
    
    return @{@"FinderID":FinderID};
}
@end
