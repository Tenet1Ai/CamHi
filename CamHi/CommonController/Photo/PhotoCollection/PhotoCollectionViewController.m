//
//  PhotoCollectionViewController.m
//  CamHi
//
//  Created by HXjiang on 16/8/17.
//  Copyright © 2016年 Hichip. All rights reserved.
//

#import "PhotoCollectionViewController.h"
#import "PhotoCollectionViewCell.h"
#import "PhotoModel.h"
#import "PhotoBroswerViewController.h"

#define Offx        (5)
#define Offy        (5)
#define OffTop      (5)
#define OffBottom   (0)
#define OffLeft     (5)
#define OffRight    (5)

@interface PhotoCollectionViewController ()
<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
{
    BOOL isEditing;
}

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *collectionViewFlowLayout;
@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, strong) NSMutableArray *deleteImages;
@property (nonatomic, strong) UIImage *imageMark;
@property (nonatomic, strong) UIToolbar *deleteToolbar;

@end

@implementation PhotoCollectionViewController

static NSString * const reuseIdentifier = @"Cell";
static NSString * const headerIdentifier = @"headerIdentifier";
static NSString * const footerIdentifier = @"footerIdentifier";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    [self setupBarButtonItem];
    
    [self.navigationController.view addSubview:self.deleteToolbar];
    [self dismissDeleteToolbar];
    
    [self.view addSubview:self.collectionView];
    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = NO;

    
    [self.images removeAllObjects];
    
    NSMutableArray *pictures = [GBase picturesForCamera:self.camera];
    
    for (int i = 0; i < pictures.count; i++) {
        
        PhotoModel *photo = [[PhotoModel alloc] initWithImageName:pictures[i]];
        [self.images addObject:photo];
    }

    NSLog(@"self.images.count:%d", (int)self.images.count);
    
    [self.collectionView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    isEditing ? [self dismissDeleteToolbar] : nil;
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


- (void)setupBarButtonItem {
    
    UIButton *btnItem = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    [btnItem setTitle:INTERSTR(@"Edit") forState:UIControlStateNormal];
    [btnItem setTitle:INTERSTR(@"Done") forState:UIControlStateSelected];
    [btnItem setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnItem addTarget:self action:@selector(btnItemAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:btnItem];
    self.navigationItem.rightBarButtonItem = rightItem;
    
}

- (void)btnItemAction:(id)sender {
    
    UIButton *btn = (UIButton *)sender;
    btn.selected = !btn.selected;
    
    isEditing = btn.selected;
    
    if (isEditing) {
        
        [self showDeleteToolbar];
    }
    else {
        
        for (PhotoModel *model in self.images) {
            if (model.ismark) {
                model.ismark = !model.ismark;
            }
        }
        
        [self.collectionView reloadData];
        [self dismissDeleteToolbar];
    }
}

#pragma mark <UICollectionViewDataSource>

- (UIImage *)imageMark {
    if (!_imageMark) {
        _imageMark = [[UIImage imageNamed:@"mark_red"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    return _imageMark;
}

- (NSMutableArray *)images {
    if (!_images) {
        
        _images = [[NSMutableArray alloc] initWithCapacity:0];
        
//        NSMutableArray *pictures = [GBase picturesForCamera:self.camera];
//        
//        for (int i = 0; i < pictures.count; i++) {
//            
//            PhotoModel *photo = [[PhotoModel alloc] initWithImageName:pictures[i]];
//            [_images addObject:photo];
//        }
    }
    return _images;
}

- (UICollectionView *)collectionView {
    
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:self.collectionViewFlowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        //_collectionView.userInteractionEnabled = YES;
        _collectionView.backgroundColor = [UIColor whiteColor];
        
        // Register cell classes
        [_collectionView registerClass:[PhotoCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
        // Register sectionHeader classes
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIdentifier];
        // Register sectionFooter classes
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerIdentifier];

    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)collectionViewFlowLayout {
    
    if (!_collectionViewFlowLayout) {
        _collectionViewFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    }
    return _collectionViewFlowLayout;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.images.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    if (cell == nil) {
        [self.collectionView registerClass:[PhotoCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    }
    
    PhotoModel *photo = self.images[indexPath.item];
    
    cell.bImage.image = [UIImage imageWithContentsOfFile:photo.imgPath];
    cell.fImage.image = photo.ismark ? self.imageMark : nil ;
    
    if (photo.ismark) {
        
    }
    
    return cell;
}

//- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    return YES;
//}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PhotoCollectionViewCell *cell = (PhotoCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    PhotoModel *photo = self.images[indexPath.item];
    
    if (isEditing) {

        photo.ismark = !photo.ismark;
        cell.fImage.image = photo.ismark ? self.imageMark : nil ;

    }
    else {
        
        PhotoBroswerViewController *photoBroswer = [[PhotoBroswerViewController alloc] init];
        photoBroswer.images = self.images;
        photoBroswer.selectPhoto = photo;
        [self.navigationController pushViewController:photoBroswer animated:YES];
    }
}


#pragma mark <UICollectionViewDelegate>

//行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return Offy;
}

//列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return Offx;
}

// return UIedgeInset of section （section 的缩进）
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(OffTop, OffLeft, OffBottom, OffRight);
}

// return size of item
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger row = 3;
    CGFloat w = self.view.frame.size.width;
    //itemw ＝ 总长度－缩进的宽度 － 列间距
    CGFloat itemw = (w - OffLeft - OffRight - Offx*(row-1))/row;
    CGFloat itemh = itemw/1.5;
    return CGSizeMake(itemw, itemh);
}

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

#pragma mark - UIToolbar
- (UIToolbar *)deleteToolbar {
    
    if (!_deleteToolbar) {
        
        CGFloat barw = self.view.frame.size.width;
        CGFloat barh = 44.0f;
        CGFloat bary = self.view.frame.size.height - barh;
        _deleteToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, bary, barw, barh)];
        _deleteToolbar.barStyle = UIBarStyleDefault;
        _deleteToolbar.translucent = NO;
        //self.editModeToolBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth/*|UIViewAutoresizingFlexibleHeight*/;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:[UIImage imageNamed:@"rect_red"] forState:UIControlStateNormal];
        [button setTitle:NSLocalizedString(@"Delete", nil) forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:12.0];
        [button.layer setCornerRadius:5.0f];
        [button.layer setMasksToBounds:YES];
        [button.layer setBorderWidth:1.0f];
        [button.layer setBorderColor: [[UIColor darkGrayColor] CGColor]];
        
        button.frame=CGRectMake(0.0, 100.0, 60.0, 30.0);
        [button addTarget:self action:@selector(deleteButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem* deleteButton = [[UIBarButtonItem alloc] initWithCustomView:button];
        
        UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        
        [_deleteToolbar setItems:[NSArray arrayWithObjects:flexibleSpace,deleteButton,flexibleSpace,nil]];
        
    }
    return _deleteToolbar;
}

- (void)dismissDeleteToolbar {
    
    CGRect frame = self.deleteToolbar.frame;
    frame.origin.y += frame.size.height;
    
    [UIView animateWithDuration:0.5 animations:^{
        self.deleteToolbar.frame = frame;
    }];
}

- (void)showDeleteToolbar {
    
    CGRect frame = self.deleteToolbar.frame;
    frame.origin.y -= frame.size.height;
    
    [UIView animateWithDuration:0.5 animations:^{
        self.deleteToolbar.frame = frame;
    }];
}



- (void)deleteButtonAction:(id)sender {
    
    [self deletePictures];
}


- (void)deletePictures {
    
    NSMutableArray *deletes = [[NSMutableArray alloc] initWithCapacity:0];
    
    [self.deleteImages removeAllObjects];
    
    for (PhotoModel *model in self.images) {
        
        if (model.ismark) {
            [deletes addObject:model];
            [self.deleteImages addObject:model];
        }
    }
    
    if (deletes.count == 0) {
        [HXProgress showText:INTERSTR(@"Please select photos to delete.")];
        return;
    }
    
    if (SystemVersion >= 8.0) {
        
        __weak typeof(self) weakSelf = self;
        
        [self presentAlertTitle:INTERSTR(@"Delete") message:nil alertStyle:UIAlertControllerStyleAlert actionDefaultTitle:INTERSTR(@"Yes") actionDefaultBlock:^{
            
            for (PhotoModel *model in deletes) {
                
                [GBase deletePicture:model.imgName];
                [weakSelf.images removeObject:model];
            }
            
            [weakSelf.collectionView reloadData];

        } actionCancelTitle:INTERSTR(@"No") actionCancelBlock:^{
            
        }];
    }
    else {
        [self presentAlertViewBeforeIOS8];
    }
    
//    [self presentAlertViewBeforeIOS8];

    
}

- (NSMutableArray *)deleteImages {
    if (!_deleteImages) {
        _deleteImages = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _deleteImages;
}


#pragma mark - UIAlertViewDelegate
- (void)presentAlertViewBeforeIOS8 {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:INTERSTR(@"Delete") delegate:self cancelButtonTitle:INTERSTR(@"No") otherButtonTitles:INTERSTR(@"Yes"), nil];
    
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    NSLog(@"buttonIndex:%d", (int)buttonIndex);
    
    if (buttonIndex == 1) {
        
        for (PhotoModel *model in self.deleteImages) {
            
            [GBase deletePicture:model.imgName];
            [self.images removeObject:model];
        }
        
        [self.collectionView reloadData];
    }
    
}




@end
