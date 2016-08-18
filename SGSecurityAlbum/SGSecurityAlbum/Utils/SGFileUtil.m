//
//  SGFileUtil.m
//  SGSecurityAlbum
//
//  Created by soulghost on 9/7/2016.
//  Copyright © 2016 soulghost. All rights reserved.
//

#import "SGFileUtil.h"
#import "LKDBTool.h"
#import "JMBImageTab.h"
@implementation SGFileUtil

+ (instancetype)sharedUtil {
    static SGFileUtil *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [self new];
    });
    return instance;
}

+ (NSString *)getFileNameFromPath:(NSString *)filePath {
    return [[filePath componentsSeparatedByString:@"/"] lastObject];
}

+ (NSString *)photoPathForRootPath:(NSString *)rootPath {
    return [rootPath stringByAppendingPathComponent:@"Photo"];
}

+ (NSString *)thumbPathForRootPath:(NSString *)rootPath {
    return [rootPath stringByAppendingPathComponent:@"Thumb"];
}



+ (void)saveThumb:(UIImage *)thumbimage toRootPath:(NSString *)rootPath withName:(NSString *)name savePhoto:(UIImage *)orgimage{
    NSData *ThumbimageDate = UIImagePNGRepresentation(thumbimage);
    NSData *OrgimageDate = UIImagePNGRepresentation(orgimage);

    JMBImageTab *ImageTab = [JMBImageTab new];
    ImageTab.imageID =[NSString stringWithFormat:@"%u",arc4random() % 10000];
    ImageTab.ImageName =name;
    ImageTab.OrgImageData =OrgimageDate;
    ImageTab.ThumbImageData = ThumbimageDate;
    ImageTab.SaveFinder = @"1";
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    ImageTab.SaveTime =locationString ;
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [ImageTab save];
//    });
}

- (void)setAccount:(SGAccount *)account {
    _account = account;
    _rootPath = [DocumentPath stringByAppendingPathComponent:account.password];
    NSFileManager *mgr = [NSFileManager defaultManager];
    if (![mgr fileExistsAtPath:_rootPath isDirectory:nil]) {
        [mgr createDirectoryAtPath:_rootPath withIntermediateDirectories:NO attributes:nil error:nil];
    }
}

@end
