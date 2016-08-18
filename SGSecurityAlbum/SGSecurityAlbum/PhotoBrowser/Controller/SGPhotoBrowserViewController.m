//
//  SGPhotoBrowserViewController.m
//  SGSecurityAlbum
//
//  Created by soulghost on 9/7/2016.
//  Copyright © 2016 soulghost. All rights reserved.
//

#import "SGPhotoBrowserViewController.h"
#import "QBImagePickerController.h"
#import "JMBImageTab.h"

@interface SGPhotoBrowserViewController () <QBImagePickerControllerDelegate>

@property (nonatomic, strong) NSArray<SGPhotoModel *> *photoModels;

@end

@implementation SGPhotoBrowserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    [self commonInit];
    [self loadFiles];
}

- (void)commonInit {
    self.numberOfPhotosPerRow = 4;
    self.title = [SGFileUtil getFileNameFromPath:self.rootPath];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addClick)];
    WS();
    [self setNumberOfPhotosHandlerBlock:^NSInteger{
        return weakSelf.photoModels.count;
    }];
    [self setphotoAtIndexHandlerBlock:^SGPhotoModel *(NSInteger index) {
        return weakSelf.photoModels[index];
    }];
    [self setReloadHandlerBlock:^{
        [weakSelf loadFiles];
    }];
}

- (void)loadFiles {
    NSMutableArray *photoModels = @[].mutableCopy;
    
    for (JMBImageTab *obj in [JMBImageTab findAll]) {
                SGPhotoModel *model = [SGPhotoModel new];
                model.ImageID = obj.imageID;
                [photoModels addObject:model];
    }
    self.photoModels = photoModels;
    [self reloadData];
}

#pragma mark - UIBarButtonItem Action
- (void)addClick {
    QBImagePickerController *picker = [QBImagePickerController new];
    picker.delegate = self;
    picker.allowsMultipleSelection = YES;
    picker.showsNumberOfSelectedAssets = YES;
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - QBImagePickerController Delegate       PhotoKit框架处理图片视频
- (void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didFinishPickingAssets:(NSArray *)assets {
   //控制加载图片时的一系列参数
    PHImageRequestOptions *op = [[PHImageRequestOptions alloc] init];
    op.synchronous = YES;
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:imagePickerController.view];
    [imagePickerController.view addSubview:hud];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    [hud showAnimated:YES];
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *dateStr = [formatter stringFromDate:[NSDate date]];
    __block  NSInteger progressCount = 0;
    NSMutableArray *importAssets = @[].mutableCopy;
    NSInteger progressSum = assets.count ;
    void (^hudProgressBlock)(NSInteger currentProgressCount) = ^(NSInteger progressCount) {
        dispatch_async(dispatch_get_main_queue(), ^{
            hud.progress = (double)progressCount / progressSum;
            if (progressCount == progressSum) {
                [imagePickerController dismissViewControllerAnimated:YES completion:nil];
                [hud hideAnimated:YES];
                [self loadFiles];
                [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                    [PHAssetChangeRequest deleteAssets:importAssets];
                } completionHandler:nil];
            }
        });
    };
    for (int i = 0; i < assets.count; i++) {
        //一个照片库中的资源
        PHAsset *asset = assets[i];
        [importAssets addObject:asset];
        //用于处理资源的加载，加载图片的过程带有缓存处理，可以通过传入一个 PHImageRequestOptions 控制资源的输出尺寸等规格
        PHCachingImageManager *imageManager = [[PHCachingImageManager alloc] init];
        NSString *fileName = [[NSString stringWithFormat:@"%@%@",dateStr,@(i)] MD5];
        //获取图片信息存入本地存入本地
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [imageManager requestImageForAsset:asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeAspectFill options:op resultHandler:^(UIImage *result, NSDictionary *info) {
                //原始图片
               __block UIImage * orgresult = result;
                [imageManager requestImageForAsset:asset targetSize:CGSizeMake(120, 120) contentMode:PHImageContentModeAspectFill options:op resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                    [SGFileUtil saveThumb:result toRootPath:self.rootPath withName:fileName savePhoto:orgresult];
                    hudProgressBlock(++progressCount);
                }];
            }];

        });
    }
}

- (void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController {
    [imagePickerController dismissViewControllerAnimated:YES completion:nil];
}

@end
