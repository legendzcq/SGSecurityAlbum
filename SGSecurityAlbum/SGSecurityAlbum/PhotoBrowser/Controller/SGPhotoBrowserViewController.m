//
//  SGPhotoBrowserViewController.m
//  SGSecurityAlbum
//
//  Created by soulghost on 9/7/2016.
//  Copyright © 2016 soulghost. All rights reserved.
//

#import "SGPhotoBrowserViewController.h"
#import "QBImagePickerController.h"

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
    NSFileManager *mgr = [NSFileManager defaultManager];
    NSString *photoPath = [SGFileUtil photoPathForRootPath:self.rootPath];
    NSString *thumbPath = [SGFileUtil thumbPathForRootPath:self.rootPath];
    NSMutableArray *photoModels = @[].mutableCopy;
    //获取目录下所有的文件及其文件目录
    NSArray *fileNames = [mgr contentsOfDirectoryAtPath:photoPath error:nil];
    for (NSUInteger i = 0; i < fileNames.count; i++) {
        NSString *fileName = fileNames[i];
//        拼装本地URL
        NSURL *photoURL = [NSURL fileURLWithPath:[photoPath stringByAppendingPathComponent:fileName]];
        NSURL *thumbURL = [NSURL fileURLWithPath:[thumbPath stringByAppendingPathComponent:fileName]];
        //缩略图，高清图模型
        SGPhotoModel *model = [SGPhotoModel new];
        model.photoURL = photoURL;
        model.thumbURL = thumbURL;
        [photoModels addObject:model];
    }
    
    NSArray *photoURLs = @[@"http://www.qqpk.cn/Article/UploadFiles/201401/20140112213059211.jpg",
                           @"http://img5q.duitang.com/uploads/item/201506/02/20150602185303_UCukR.jpeg",
                           @"http://www.bz55.com/uploads/allimg/121201/1-121201111T3-50.jpg",
                           @"http://www.qqpk.cn/Article/UploadFiles/201401/20140112213059211.jpg",
                           @"http://pic.yesky.com/uploadImages/2015/141/01/3FQS5IET54PE.jpg",
                           @"http://img5.duitang.com/uploads/blog/201412/12/20141212190917_eLSWV.jpeg"];
    
    NSArray *thumbURLs = @[@"http://www.qqpk.cn/Article/UploadFiles/201401/20140112213059211.jpg",
                           @"http://img5q.duitang.com/uploads/item/201506/02/20150602185303_UCukR.jpeg",
                           @"http://www.bz55.com/uploads/allimg/121201/1-121201111T3-50.jpg",
                           @"http://www.qqpk.cn/Article/UploadFiles/201401/20140112213059211.jpg",
                           @"http://pic.yesky.com/uploadImages/2015/141/01/3FQS5IET54PE.jpg",
                           @"http://img5.duitang.com/uploads/blog/201412/12/20141212190917_eLSWV.jpeg"];
    for (NSUInteger i = 0; i < photoURLs.count; i++) {
        NSURL *photoURL = [NSURL URLWithString:photoURLs[i]];
        NSURL *thumbURL = [NSURL URLWithString:thumbURLs[i]];
        SGPhotoModel *model = [SGPhotoModel new];
        model.photoURL = photoURL;
        model.thumbURL = thumbURL;
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
    NSInteger progressSum = assets.count * 2;
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
                [SGFileUtil savePhoto:result toRootPath:self.rootPath withName:fileName];
                hudProgressBlock(++progressCount);
            }];
            [imageManager requestImageForAsset:asset targetSize:CGSizeMake(120, 120) contentMode:PHImageContentModeAspectFill options:op resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                [SGFileUtil saveThumb:result toRootPath:self.rootPath withName:fileName];
                hudProgressBlock(++progressCount);
            }];
        });
    }
}

- (void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController {
    [imagePickerController dismissViewControllerAnimated:YES completion:nil];
}

@end
