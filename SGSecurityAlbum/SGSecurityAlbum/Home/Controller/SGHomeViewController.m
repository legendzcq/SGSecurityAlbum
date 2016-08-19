//
//  SGHomeViewController.m
//  SGSecurityAlbum
//
//  Created by soulghost on 9/7/2016.
//  Copyright © 2016 soulghost. All rights reserved.
//

#import "SGPhotoBrowserViewController.h"
#import "SGHomeViewController.h"
#import "SGHomeView.h"
#import "AppDelegate.h"
#import "JMBFinderTab.h"
#import "LKDBTool.h"

@interface SGHomeViewController () <UICollectionViewDelegateFlowLayout, UIAlertViewDelegate>
{
    CGSize changeSize;
    BOOL changeFlage;
}

@property (nonatomic, weak) SGHomeView *homeView;

@end

@implementation SGHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    [self loadFiles];
}

- (void)setupView {
    self.title = @"图片浏览器";
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    SGHomeView *view = [[SGHomeView alloc] initWithFrame:(CGRect){0, 0, [UIScreen mainScreen].bounds.size} collectionViewLayout:layout];
    view.alwaysBounceVertical = YES;
    view.delegate = self;
    WS();
    [view setAction:^{
        [weakSelf loadFiles];
    }];
    self.homeView = view;
    [self.view addSubview:view];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(logout)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"change" style:UIBarButtonItemStylePlain target:self action:@selector(change)];
    changeSize = CGSizeMake(100, 100);
}
-(void)change{
    if (!changeFlage) {
        changeSize = CGSizeMake(200, 200);
    }else{
        changeSize = CGSizeMake(100, 100);
    }
    changeFlage = !changeFlage;
    
    
    [self.homeView reloadData];
    
}

- (void)logout {
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    app.window.rootViewController = [[SGAccountManager sharedManager] getRootViewController];
}

#pragma mark - 解析数据  修改成读取数据库
- (void)loadFiles {

    NSMutableArray<SGAlbum *> *albums = @[].mutableCopy;
    //绘制添加文件夹数据
    SGAlbum *addBtnAlbum = [SGAlbum new];
    addBtnAlbum.type = SGAlbumButtonTypeAddButton;
    [albums addObject:addBtnAlbum];
    for (JMBFinderTab *obj in [JMBFinderTab findAllselectcondition:nil]) {
        SGAlbum *album = [SGAlbum new];
        album.name = obj.FinderName;
        [albums addObject:album];
    }
    
    
    
    self.homeView.albums = albums;
    [self.homeView reloadData];
}

#pragma mark UICollectionView Delegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return changeSize;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(5, 10, 5, 10);
}
#pragma mark 选择文件夹
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    SGAlbum *album = self.homeView.albums[indexPath.row];
    if (album.type == SGAlbumButtonTypeAddButton) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"新建文件夹" message:@"请输入文件夹名称" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
        [alertView show];
    } else {
        SGPhotoBrowserViewController *browser = [SGPhotoBrowserViewController new];
        browser.FinderName = album.name;
        [self.navigationController pushViewController:browser animated:YES];
    }
}

#pragma mark UIAlertView Delegate 新建文件夹
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        NSString *folderName = [alertView textFieldAtIndex:0].text;
        if (!folderName.length) {
            [MBProgressHUD showError:@"文件夹不能为空"];
            return;
        }
        LKDBSQLState *sql = [[LKDBSQLState alloc] object:[JMBFinderTab class] type:WHERE key:@"FinderName" opt:@"=" value:folderName];
        NSArray *dataArray = [JMBFinderTab findByCriteria:[sql sqlOptionStr] selectcondition:nil];
        if (dataArray.count >0) {
            [MBProgressHUD showError:@"文件夹不能为重名"];
            return;
        }
        
        JMBFinderTab * tab = [JMBFinderTab new];
        tab.FinderID = [folderName MD5];
        tab.FinderName = folderName;
        if (![tab save]) {
            [MBProgressHUD showError:@"文件夹新建错误"];
            return;
        };

        [self loadFiles];
    }
}

@end
