//
//  UIImageView+SGExtension.m
//  SGSecurityAlbum
//
//  Created by soulghost on 14/7/2016.
//  Copyright © 2016 soulghost. All rights reserved.
//

#import "UIImageView+SGExtension.h"
#import "UIImageView+WebCache.h"
#import <objc/runtime.h>
#import "SDImageCache.h"
#import "SGPhotoModel.h"
#import "LKDBTool.h"
#import "JMBImageTab.h"
@implementation UIImageView (SGExtension)

static char hudKey;
static char modelKey;

@dynamic hud;
@dynamic model;

- (void)sg_setImageWithURL:(NSString *)imageID isThumb:(BOOL)isThumb {
//    if (![url isFileURL]) {
//        SDImageCache *cache = [SDImageCache sharedImageCache];
//        SDWebImageManager *mgr = [SDWebImageManager sharedManager];
//        NSString *key = [mgr cacheKeyForURL:url];
//        if ([cache diskImageExistsWithKey:key] || ([cache imageFromMemoryCacheForKey:key] != nil)) {
//            [self sd_setImageWithURL:url];
//            return;
//        }
//        if (self.hud != nil) {
//            return;
//        }
//        MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self];
//        self.hud = hud;
//        hud.mode = MBProgressHUDModeAnnularDeterminate;
//        [self addSubview:hud];
//        [hud showAnimated:YES];
//        UIImage *placeHolderImage = [UIImage imageNamed:@"imagePlaceholder"];
//        if (self.model.thumbURL) {
//            NSString *key = [mgr cacheKeyForURL:self.model.thumbURL];
//            UIImage *tempImage = [cache imageFromMemoryCacheForKey:key];
//            if (tempImage == nil) {
//                tempImage = [cache imageFromDiskCacheForKey:key];
//            }
//            if (tempImage) {
//                placeHolderImage = tempImage;
//            }
//        }
//        [self sd_setImageWithURL:url placeholderImage:placeHolderImage options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
//            hud.progress = (float)receivedSize / expectedSize;
//        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//            [hud removeFromSuperview];
//            self.hud = nil;
//        }];
//    } else {
    
    
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        LKDBSQLState *sql = [[LKDBSQLState alloc] object:[JMBImageTab class] type:WHERE key:@"imageID" opt:@"=" value:imageID];
        NSArray *dataArray = [JMBImageTab findByCriteria:[sql sqlOptionStr] selectcondition:nil];
        
        for (JMBImageTab *obj in dataArray) {
            if (isThumb) {
//                self.image = [UIImage imageWithContentsOfFile:url.path];
                 self.image =[UIImage imageWithData:obj.ThumbImageData];
            }else
            {
                self.image =[UIImage imageWithData:obj.OrgImageData];
            }
        }
        
//    });
    
    

    
//    }
}

- (void)sg_setImageWithURL:(NSString *)imageID model:(SGPhotoModel *)model isThumb:(BOOL)isThumb {
    self.model = model;
    [self sg_setImageWithURL:imageID isThumb:isThumb];
}

- (void)setHud:(MBProgressHUD *)hud {
    objc_setAssociatedObject(self, &hudKey, hud, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setModel:(SGPhotoModel *)model {
    objc_setAssociatedObject(self, &modelKey, model, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (MBProgressHUD *)hud {
    return objc_getAssociatedObject(self, &hudKey);
}

- (SGPhotoModel *)model {
    return objc_getAssociatedObject(self, &modelKey);
}

@end
