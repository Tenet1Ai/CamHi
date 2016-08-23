//
//  CameraListViewController.m
//  CamHi
//
//  Created by HXjiang on 16/7/18.
//  Copyright © 2016年 JiangLin. All rights reserved.
//

#import "CameraListViewController.h"
#import "HiSearchSDK.h"

@interface CameraListViewController ()<OnSearchResult>

@property (nonatomic, strong) HiSearchSDK *ssdk;

@end

@implementation CameraListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = NSLocalizedString(@"Camera List", nil);
    [self.view addSubview:self.tableView];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.ssdk.delegate = self;
    [self.ssdk search];
    
    [HXProgress showProgress];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    self.ssdk.delegate = nil;

    //误操作时移除动画提示
    UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    for (UIView *v in window.subviews) {
        //        NSLog(@"*************** v :%@", [NSString stringWithUTF8String:object_getClassName(v)]);
        //移除提示
        if ([v isKindOfClass:[HXProgress class]]) {
            [HXProgress dismiss];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - OnSearchResult

- (HiSearchSDK *)ssdk {
    if (!_ssdk) {
        _ssdk = [[HiSearchSDK alloc] init];
    }
    return _ssdk;
}

- (void)searchResult:(NSMutableArray *)array {
    self.dataArray = array;
    [self.tableView reloadData];
    [HXProgress dismiss];
    
    for (HiSearchResult *s in self.dataArray) {
        LOG(@"HiSearchResult:%@", s.uid);
    }
}

#pragma mark -- UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.dataArray.count == 0) {
        return 0;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellID = @"CameraListCellID";
    HXCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[HXCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    
    HiSearchResult *result = [self.dataArray objectAtIndex:indexPath.row];
    
    cell.detailTextLabel.text = result.ip;
    cell.detailTextLabel.textColor = [UIColor grayColor];
    cell.textLabel.text = result.uid;
    cell.textLabel.textColor = [UIColor blackColor];
    
    for (Camera *mycam in [GBase sharedBase].cameras) {
        if ([mycam.uid isEqualToString:result.uid]) {
            cell.textLabel.textColor = [UIColor grayColor];
            break;
        }
    }//@for
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [self setupHeaderView];
}

- (UIView *)setupHeaderView {
    if (!self.headerView) {
        self.headerView = [[UIView alloc] init];
        self.headerView.backgroundColor = RGBA_COLOR(240, 240, 240, 1);
        
        UILabel *labHead = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, self.view.frame.size.width-40, 30)];
        labHead.text = NSLocalizedString(@"Device on LAN:", nil);
        labHead.textColor = [UIColor grayColor];
        labHead.font = [UIFont systemFontOfSize:12];
        [self.headerView addSubview:labHead];
    }
    return self.headerView;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.delegate) {
        
        HiSearchResult *result = [self.dataArray objectAtIndex:indexPath.row];
        
        for (Camera *mycam in [GBase sharedBase].cameras) {
            if ([mycam.uid isEqualToString:result.uid]) {
                [HXProgress showText:NSLocalizedString(@"This device is already exists", nil)];
                return;
            }
        }//@for

        [self.delegate didSelectCamera:result.uid];
        [self.navigationController popViewControllerAnimated:YES];
    }
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
