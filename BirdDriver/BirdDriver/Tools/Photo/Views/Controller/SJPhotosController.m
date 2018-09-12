//
//  SJPhotosController.m
//  BirdDriver
//
//  Created by 肖乐 on 2018/5/22.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJPhotosController.h"
#import "SJBrowserController.h"
#import "SJAllPhotoPresenter.h"
#import "SJCameraCell.h"
#import "SJPhotoCell.h"
#import "SJPhotoModel.h"
#import "SJPhotoComponents.h"
#import "UIImage+Orientation.h"
#import "VPImageCropperViewController.h"

@interface SJPhotosController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, SJPhotoViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate,VPImageCropperDelegate>
{
    // 防止点击完成时重复操作
    BOOL _refuseRepeatOK;
}

@property (nonatomic, strong) NSMutableArray <SJPhotoModel *>*photos;
@property (nonatomic, strong) SJAllPhotoPresenter *photoPresenter;
@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, weak) UILabel *titleLabel;

@end

@implementation SJPhotosController
static NSString *const collID = @"SJPhotoCell";
static NSString *const cameraID = @"SJCameraCell";

#pragma mark - lazy loading
- (NSMutableArray<SJPhotoModel *> *)selectedAssets
{
    if (_selectedAssets == nil)
    {
        _selectedAssets = [NSMutableArray array];
    }
    return _selectedAssets;
}

- (instancetype)init
{
    if (self = [super init])
    {
        self.maximumLimit = 250;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //安装子控件
    [self setupBase];
    //获取所有图片
    [self getAllPhotos];
}

- (void)getAllPhotos
{
    self.photoPresenter = [[SJAllPhotoPresenter alloc] init];
    self.photoPresenter.delegate = self;
    [self.photoPresenter getAllPhotosWithSelectedAssets:self.selectedAssets];
}

- (void)setupBase
{
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect sureBtnFrame = sureBtn.frame;
    sureBtnFrame.size = CGSizeMake(45, 30);
    sureBtn.frame = sureBtnFrame;
    [sureBtn setTitle:@"确认" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor colorWithHexString:@"FFBB04" alpha:1.0] forState:UIControlStateNormal];
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:sureBtn];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.size = CGSizeMake(120, 30);
    titleLabel.font = SPBFont(16.0);
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = [NSString stringWithFormat:@"%zd/%zd", self.selectedAssets.count, self.maximumLimit];
    self.navigationItem.titleView = titleLabel;
    self.titleLabel = titleLabel;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    collectionView.showsVerticalScrollIndicator = YES;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.pagingEnabled = NO;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [collectionView registerClass:NSClassFromString(collID) forCellWithReuseIdentifier:collID];
    [collectionView registerNib:[UINib nibWithNibName:cameraID bundle:nil] forCellWithReuseIdentifier:cameraID];
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
}

- (void)updateTitle
{
    self.titleLabel.text = [NSString stringWithFormat:@"%zd/%zd", self.selectedAssets.count, self.maximumLimit];
}

#pragma mark - event
- (void)sureBtnClick
{
    if ([self.selectedAssets count] == 0) {
        [SVProgressHUD showWithStatus:@"请选择图片"];
        [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
        return;
    }
    if (_refuseRepeatOK) return;
    _refuseRepeatOK = YES;
    dispatch_group_t group = dispatch_group_create();
    for (SJPhotoModel *photoModel in self.selectedAssets) {
        
        dispatch_group_enter(group);
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
        options.networkAccessAllowed = YES;
        
        void (^exceptionBlock)(void) = ^() {
            
            [[PHImageManager defaultManager] requestImageForAsset:photoModel.mAsset targetSize:CGSizeMake(photoModel.mAsset.pixelWidth, photoModel.mAsset.pixelHeight) contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                
                photoModel.resultImage = [UIImage fixOrientation:result];
                dispatch_group_leave(group);
            }];
        };
        [[PHImageManager defaultManager] requestImageDataForAsset:photoModel.mAsset options:options resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
            
            if (imageData)
            {
                //压缩
                UIImage *sourceImage = [UIImage imageWithData:imageData];
                imageData = [SJPhotoComponents imageCompressForSize:sourceImage targetPx:1.5*1024];
                UIImage *compressImage = [UIImage imageWithData:imageData];
                photoModel.resultImage = [UIImage fixOrientation:compressImage];
                
                dispatch_group_leave(group);
            } else {
                exceptionBlock();
            }
        }];
    }
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        self->_refuseRepeatOK = NO;
        if (self.isHead) {
            SJPhotoModel *photoModel = [self.selectedAssets firstObject];
            UIImage *portraitImg = photoModel.resultImage;
            // 裁剪
            VPImageCropperViewController *imgEditorVC = [[VPImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 100.0f, self.view.frame.size.width, self.view.frame.size.width) limitScaleRatio:3.0];
            imgEditorVC.delegate = self;
            [self presentViewController:imgEditorVC animated:YES completion:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
            if (self.delegate && [self.delegate respondsToSelector:@selector(photoController:didSelectedPhotos:)])
            {
                [self.delegate photoController:self didSelectedPhotos:(NSArray *)self.selectedAssets];
            }
        }
    });
}

#pragma mark VPImageCropperDelegate
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    SJPhotoModel *photoModel = [self.selectedAssets firstObject];
    photoModel.resultImage = editedImage;
    [self.selectedAssets replaceObjectAtIndex:0 withObject:photoModel];
    if (self.delegate && [self.delegate respondsToSelector:@selector(photoController:didSelectedPhotos:)])
    {
        [self.delegate photoController:self didSelectedPhotos:(NSArray *)self.selectedAssets];
    }
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        // TO DO
    }];

}

- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        
    }];
}


#pragma mark - SJPhotoViewDelegate
- (void)setAllPhotos:(NSMutableArray<SJPhotoModel *> *)allPhotos
{
    self.photos = allPhotos;
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.photos.count + 1;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(SJPhotoMargin, SJPhotoMargin, SJPhotoMargin, SJPhotoMargin);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return SJPhotoCellSpacing;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return SJPhotoCellSpacing;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [SJPhotoComponents assetGridCellSize];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item == 0)
    {
        SJCameraCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cameraID forIndexPath:indexPath];
        return cell;
    }
    SJPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collID forIndexPath:indexPath];
    cell.photoModel = self.photos[indexPath.item-1];
    cell.photoCallBack = ^(id model) {
        
        if ([model isKindOfClass:[SJPhotoModel class]]) {
            
            SJPhotoModel *photoModel = (SJPhotoModel *)model;
            if (!photoModel.selected) {
                
                if (self.selectedAssets.count >= self.maximumLimit) {
                    
                    [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"只可选择%zd张图片", self.maximumLimit]];
                    [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
                    return;
                }
            }
            photoModel.isSelected = !photoModel.selected;
            if (photoModel.selected)
            {
                [self.selectedAssets addObject:photoModel];
            } else {
                [self.selectedAssets removeObject:photoModel];
            }
            [self updateTitle];
            [collectionView reloadItemsAtIndexPaths:@[indexPath]];
        }
    };
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item == 0)
    {
        //拍照
        [self takePhoto];
        return;
    }
    SJBrowserController *browserVC = [[SJBrowserController alloc] init];
    browserVC.fetchPhotoResults = [self.photos mutableCopy];
    browserVC.currentIndex = indexPath.item - 1;
    [self.navigationController pushViewController:browserVC animated:YES];
}

#pragma mark - 拍照
- (void)takePhoto
{
    // 进入相机
    void (^openBlock)(void) = ^{
        
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.sourceType = sourceType;
            [self presentViewController:picker animated:YES completion:nil];
        } else {
            LogD(@"出现异常")
        }
    };
    // 权限判断
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    switch (status) {
        case AVAuthorizationStatusNotDetermined:
        {
            //第一次需要弹窗
            [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if (granted) {
                        
                        openBlock();
                    } else {
                        LogD(@"不允许访问相机")
                    }
                });
            }];
        }
            break;
        case AVAuthorizationStatusAuthorized:
        {
            openBlock();
        }
            break;
        case AVAuthorizationStatusDenied:
        case AVAuthorizationStatusRestricted:
            break;
            
        default:
            break;
    }
}
    
#pragma MARK - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        [self saveImageToAlbum:image
                        picker:picker
                  completation:^(SJPhotoModel *photoModel) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (self.selectedAssets.count >= self.maximumLimit) {
                    photoModel.isSelected = NO;
                    return ;
                }
                [self.selectedAssets addObject:photoModel];
                [self.photos insertObject:photoModel atIndex:0];
                [self.collectionView reloadData];
                [self updateTitle];
            });
        }];
        
    } else {
        // 取消
        [self imagePickerControllerDidCancel:picker];
    }
}
    
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)saveImageToAlbum:(UIImage *)image picker:(UIImagePickerController *)picker completation:(void(^)(SJPhotoModel *photoModel))completation;
{
    NSMutableArray *imageIds = [NSMutableArray array];
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        
        //写入图片到相册
        PHAssetChangeRequest *assetRequest = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
        //记录本地标识，等待完成后取到相册中的图片对象
        [imageIds addObject:assetRequest.placeholderForCreatedAsset.localIdentifier];
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (success)
            {
                //获取 imageIds(唯一标识) 中的资源
                PHFetchResult *result = [PHAsset fetchAssetsWithLocalIdentifiers:imageIds options:nil];
                [result enumerateObjectsUsingBlock:^(PHAsset * _Nonnull mAsset, NSUInteger idx, BOOL * _Nonnull stop) {
                    *stop = YES;
                    
                    [[PHImageManager defaultManager] requestImageDataForAsset:mAsset
                                                                      options:nil
                                                                resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
                        
                        SJPhotoModel *photoModel = [[SJPhotoModel alloc] initWithAsset:mAsset];
                        photoModel.isSelected = YES;
                        UIImage *image = [UIImage imageWithData:imageData];
                        image = [UIImage fixOrientation:image];
                        photoModel.resultImage = image;
                        if (completation) completation(photoModel);
                        // 取消
                        [self imagePickerControllerDidCancel:picker];
                    }];
                }];
            } else {
                // 取消
                [self imagePickerControllerDidCancel:picker];
            }
        });
    }];
}


- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.collectionView.frame = self.view.bounds;
}

- (void)dealloc
{
    LogD(@"我走啦")
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)setPhotos:(NSMutableArray<SJPhotoModel *> *)photos{
    _photos = photos;
}

#warning Soul - 留了个坑，想只能选一张时直接返回，不知为何不能触发
- (void)addPhotos:(NSSet *)objects{
    if(self.maximumLimit == 1 && self.selectedAssets.count ==1){
        [self sureBtnClick];
    }
}

@end
