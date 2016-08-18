//
//  UIImageView+SGExtension.h
//  SGSecurityAlbum
//
//  Created by soulghost on 14/7/2016.
//  Copyright © 2016 soulghost. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SGPhotoModel;

@interface UIImageView (SGExtension)

@property (nonatomic, weak) MBProgressHUD *hud;
@property (nonatomic, strong) SGPhotoModel *model;


- (void)sg_setImageWithURL:(NSString *)imageID isThumb:(BOOL)isThumb;
- (void)sg_setImageWithURL:(NSString *)imageID model:(SGPhotoModel *)model isThumb:(BOOL)isThumb;

@end
