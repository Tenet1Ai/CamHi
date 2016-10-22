//
//  PhotoBroswerViewController.m
//  CamHi
//
//  Created by HXjiang on 16/8/17.
//  Copyright © 2016年 Hichip. All rights reserved.
//

#import "PhotoBroswerViewController.h"
#import "PicturesLoop.h"
#import <MessageUI/MessageUI.h>

@interface PhotoBroswerViewController ()
<MFMailComposeViewControllerDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) UIToolbar *naToolbar;
@property (nonatomic, strong) UILabel *indexTitle;
@property (nonatomic, strong) UIView *naView;
@property (nonatomic, strong) PicturesLoop *loop;
@property __block BOOL isShow;
@property (nonatomic, assign) __block NSInteger cIndex;
@property (nonatomic, strong) NSString *directoryPath;

@end

@implementation PhotoBroswerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setup];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)setup {
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSMutableArray *imagePaths = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *imageNames = [[NSMutableArray alloc] initWithCapacity:0];
    for (PhotoModel *model in self.images) {
        [imagePaths addObject:model.imgPath];
        [imageNames addObject:model.imgName];
        
        NSLog(@"indexOfObject:%d", (int)[self.images indexOfObject:model]);
    }
    
    
    
    
    
    //    PicturesLoop *loop = [[PicturesLoop alloc] initWithFrame:self.view.bounds WithImages:imagePaths];
    //PicturesLoop *loop = [[PicturesLoop alloc] initWithFrame:self.view.bounds WithImages:imagePaths WithTitle:imagePaths WithDetail:imageNames];
    
    
    _cIndex = [self.images indexOfObject:self.selectPhoto];
    
    _loop = [[PicturesLoop alloc] initWithFrame:self.view.bounds withImages:imagePaths currentIndex:_cIndex];

    
    
    [self.view addSubview:_loop];
    
    //[self.navigationController.view addSubview:self.naToolbar];

    _isShow = YES;
    //[self dismissDeleteToolbar];

    [self.view addSubview:self.naView];
    [self dismissNaView];
    
    __weak typeof(self) weakSelf = self;
    
    _loop.tapBlock = ^(NSInteger currentIndex, NSInteger type) {
        
        if (type == 0) {
            weakSelf.isShow ? [weakSelf dismissNaView] : [weakSelf shownaView];

        }
        
        if (type == 1) {
            
            weakSelf.cIndex = currentIndex;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //weakSelf.indexTitle.text = [NSString stringWithFormat:@"%d/%d", (int)(currentIndex+1), (int)weakSelf.images.count];
            });

        }

//        isShow ? [weakSelf dismissDeleteToolbar] : [weakSelf showDeleteToolbar];

    };
//
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
//    [loop addGestureRecognizer:tap];
    
}

- (void)tap:(UITapGestureRecognizer *)recognizer {
    
    _isShow ? [self dismissDeleteToolbar] : [self showDeleteToolbar];
    
}


- (UILabel *)indexTitle {
    if (!_indexTitle) {
        _indexTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
        _indexTitle.center = CGPointMake(CGRectGetWidth(self.naToolbar.frame)/2, CGRectGetHeight(self.naToolbar.frame)/2);
        _indexTitle.textAlignment = NSTextAlignmentCenter;
        _indexTitle.adjustsFontSizeToFitWidth = YES;
        _indexTitle.text = INTERSTR(@"Local Picture");
        //_indexTitle.text = [NSString stringWithFormat:@"%d/%d", (int)([self.images indexOfObject:self.selectPhoto]+1), (int)self.images.count];
    }
    return _indexTitle;
}

- (UIToolbar *)naToolbar {
    
    if (!_naToolbar) {
        
        CGFloat barw = self.view.frame.size.width;
        CGFloat barh = 44.0f;
        CGFloat bary = 20;
        _naToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, bary, barw, barh)];
        _naToolbar.barStyle = UIBarStyleDefault;
        _naToolbar.translucent = NO;
        
        //self.editModeToolBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth/*|UIViewAutoresizingFlexibleHeight*/;
        
        //11/21
        UIButton *btnBack = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 11, 21)];
        btnBack.center = CGPointMake(barw/3, barh/2);
        [btnBack setImage:[UIImage imageNamed:@"back_black"] forState:UIControlStateNormal];
        [btnBack addTarget:self action:@selector(btnBackAction:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:btnBack];

        
//        UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithCustomView:self.indexTitle];

        
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(showActionSheet)];

        [_naToolbar setItems:[NSArray arrayWithObjects:leftItem,flexibleSpace,rightItem,nil]];
        
    }
    return _naToolbar;
}


- (void)dismissDeleteToolbar {
    
    _isShow = !_isShow;

    CGRect frame = self.naToolbar.frame;
    frame.origin.y -= (frame.size.height+20);
    
    [UIView animateWithDuration:0.3 animations:^{
        self.naToolbar.frame = frame;
    }];
}

- (void)showDeleteToolbar {
    
    _isShow = !_isShow;

    CGRect frame = self.naToolbar.frame;
    frame.origin.y += (frame.size.height+20);
    
    [UIView animateWithDuration:0.3 animations:^{
        self.naToolbar.frame = frame;
    }];
}

- (void)btnBackAction:(id)sender {
    [self dismissDeleteToolbar];
    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showActionSheet {
    
//    [self presentAlertViewBeforeIOS8];
    
    if (SystemVersion >= 8.0) {
        [self presentAlertControllerAfterIOS8];
    }
    else {
        [self presentAlertViewBeforeIOS8];
    }
    
}

- (void)deletePicture {
    
    [self.loop nextIfDeleted:YES];
    

    
    
    NSInteger deleteIndex = 0;
    BOOL isDelete = NO;
    PhotoModel *deleteModel = nil;
    for (PhotoModel *model in self.images) {
        
        if ([model.imgPath isEqualToString:self.loop.deleteName]) {
            
            NSLog(@"model.imgPath:%@", model.imgPath);
            [GBase deletePicture:model.imgName];

            deleteIndex = [self.images indexOfObject:model];
            isDelete = YES;
            deleteModel = model;
        }
    }

    if (isDelete) {
        
        [self.images removeObject:deleteModel];
//        [self.images removeObjectAtIndex:deleteIndex];
//        PhotoModel *model = [self.images objectAtIndex:deleteIndex];
//        [GBase deletePicture:model.imgName];

    }
    
    if (self.images.count == 0) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }

    
    //NSInteger deleteIndex = (_cIndex - 1 + self.images.count) % self.images.count;
    //[self.images removeObjectAtIndex:deleteIndex];
//    PhotoModel *model = [self.images objectAtIndex:_cIndex];
//    [GBase deletePicture:model.imgName];

}


- (void)emailPhoto {
    
    
    
    if ([MFMailComposeViewController canSendMail]) {
        
        PhotoModel *model = [self.images objectAtIndex:_cIndex];
        
        NSString *extension = [[[self.directoryPath componentsSeparatedByString:@"."] lastObject] lowercaseString];
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        mailer.mailComposeDelegate = self;
        NSData *attachmentData = nil;
        
        [mailer setSubject:[NSString stringWithFormat:@"Photo - %@", model.imgName]];
        if ([extension isEqualToString:@"png"]) {
            attachmentData = UIImagePNGRepresentation([UIImage imageWithContentsOfFile:model.imgPath]);
        }else {
            attachmentData = UIImageJPEGRepresentation([UIImage imageWithContentsOfFile:model.imgPath], 1.0);
        }
        
        [mailer addAttachmentData:attachmentData mimeType:[NSString stringWithFormat:@"image/%@",extension] fileName: model.imgName];
        [mailer setMessageBody:[NSString stringWithString:[NSString stringWithFormat:@"Photo - %@", model.imgName]] isHTML:NO];
        
        
        [self presentViewController:mailer animated:YES completion:^{
            
        }];
        
    }else {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Your email account is disabled or removed, please check your email account.",nil) message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"OK",nil) otherButtonTitles:nil];
//        alert.tag = 1;
//        alert.delegate = self;
//        [alert show];
//        [alert release];
    }
    
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    
    [self dismissViewControllerAnimated:YES completion:^{
    
        if (result == MFMailComposeResultSent) {
            
            // Was there an error?
            if (error != NULL) {
                [HXProgress showText:error.domain];
            }
            else {// No errors
                [HXProgress showText:INTERSTR(@"Send success")];
            }

        }
        
    }];
}


- (void)savePhotoToCameraRoll {
    
    PhotoModel *model = [self.images objectAtIndex:_cIndex];

    UIImage *image = [UIImage imageWithContentsOfFile:model.imgPath];
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
   
    // Was there an error?
    if (error != NULL) {
        [HXProgress showText:error.domain];
    }
    else {// No errors
        [HXProgress showText:INTERSTR(@"Save Success")];
    }
}


- (NSString *)directoryPath {
    
    if (!_directoryPath) {
        
        //directoryPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"Library"];
        NSArray* dirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        _directoryPath = [dirs objectAtIndex:0];
    }
    return _directoryPath;
}



#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        [self deletePicture];
    }
    
    if (buttonIndex == 1) {
        [self emailPhoto];
    }
    
    if (buttonIndex == 2) {
        [self savePhotoToCameraRoll];
    }
}

- (void)presentAlertViewBeforeIOS8 {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil
                                                    otherButtonTitles: NSLocalizedString(@"Delete",nil),
                                  NSLocalizedString(@"Email Photo",nil),
                                  NSLocalizedString(@"Save", nil),
                                  NSLocalizedString(@"Cancel",nil), nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    actionSheet.destructiveButtonIndex = 0;	// make the 1st button red (destructive)
    //[actionSheet showInView:self.view]; // show from our table view (pops up in the middle of the table)
    //[actionSheet showFromToolbar:self.navigationController.toolbar];
    [actionSheet showFromTabBar:self.tabBarController.tabBar];

}


- (void)presentAlertControllerAfterIOS8 {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *actionDelete = [UIAlertAction actionWithTitle:INTERSTR(@"Delete") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self deletePicture];
    }];
    
    UIAlertAction *actionEmail = [UIAlertAction actionWithTitle:INTERSTR(@"Email Photo") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self emailPhoto];
    }];
    
    UIAlertAction *actionSave = [UIAlertAction actionWithTitle:INTERSTR(@"Save") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self savePhotoToCameraRoll];
    }];
    
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:INTERSTR(@"Cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    
    [alert addAction:actionDelete];
    [alert addAction:actionEmail];
    [alert addAction:actionSave];
    [alert addAction:actionCancel];

    

    
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (UIView *)naView {
    if (!_naView) {
        
        CGFloat bary = 20.0;
        
        CGFloat barw = self.view.frame.size.width;
        CGFloat barh = 64.0f;
        
        _naView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, barw, barh)];
        
        
        //11/21
        UIButton *btnBack = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 22, 42)];
        btnBack.center = CGPointMake(30, barh/2+bary);
        [btnBack setImage:[UIImage imageNamed:@"back_black"] forState:UIControlStateNormal];
        [btnBack addTarget:self action:@selector(btnBackAction:) forControlEvents:UIControlEventTouchUpInside];
        [_naView addSubview:btnBack];
        
        
        [_naView addSubview:self.indexTitle];
        self.indexTitle.center = CGPointMake(barw/2, barh/2+bary);
        
        
        //11/21
        UIButton *btnMore = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
        btnMore.center = CGPointMake(barw-30, barh/2+bary);
        [btnMore setImage:[UIImage imageNamed:@"more_blue_73"] forState:UIControlStateNormal];
        [btnMore addTarget:self action:@selector(showActionSheet) forControlEvents:UIControlEventTouchUpInside];
        [_naView addSubview:btnMore];
    }
    return _naView;
}


- (void)dismissNaView {
    
    _isShow = !_isShow;
    
    CGRect frame = self.naView.frame;
    frame.origin.y -= (frame.size.height);
    
    [UIView animateWithDuration:0.3 animations:^{
        self.naView.frame = frame;
    }];
}

- (void)shownaView {
    
    _isShow = !_isShow;
    
    CGRect frame = self.naView.frame;
    frame.origin.y += (frame.size.height);
    
    [UIView animateWithDuration:0.3 animations:^{
        self.naView.frame = frame;
    }];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
