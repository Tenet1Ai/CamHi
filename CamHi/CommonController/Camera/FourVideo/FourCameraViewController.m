//
//  FourCameraViewController.m
//  CamHi
//
//  Created by HXjiang on 16/9/7.
//  Copyright © 2016年 Hichip. All rights reserved.
//

#import "FourCameraViewController.h"
#import "FourCameraCell.h"

@interface FourCameraViewController ()

@property (nonatomic, strong) UIBarButtonItem *barButtonItemRight;
@property (nonatomic, strong) NSMutableArray *selectedCameras;

@end

@implementation FourCameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.tableView];
    
    //self.navigationItem.rightBarButtonItem = self.barButtonItemRight;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (UIBarButtonItem *)barButtonItemRight {
    if (!_barButtonItemRight) {
        
        _barButtonItemRight = [[UIBarButtonItem alloc] initWithTitle:INTERSTR(@"Done") style:UIBarButtonItemStyleDone target:self action:@selector(barButtonItemRightAction:)];
    }
    return _barButtonItemRight;
}

- (void)barButtonItemRightAction:(id)sender {
    
    [self.selectedCameras removeAllObjects];
    for (Camera *mycam in [GBase sharedBase].cameras) {
        
        if (mycam.select) {
            [self.selectedCameras addObject:mycam];
        }
    }
    
    
    if (self.selectedCameras.count <= 0) {
        [HXProgress showText:INTERSTR(@"Select one camera at least")];
        return;
    }
    
    if (self.selectedCameras.count > 4) {
        [HXProgress showText:INTERSTR(@"Select only four cameras")];
        return;
    }
    
    
//    FourCameraLiveViewController *fourCameraLive = [[FourCameraLiveViewController alloc] init];
//    fourCameraLive.selCameras = self.selectedCameras;
//    [self.navigationController pushViewController:fourCameraLive animated:YES];
}


- (NSMutableArray *)selectedCameras {
    if (!_selectedCameras) {
        _selectedCameras = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _selectedCameras;
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [GBase sharedBase].cameras.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return FourCameraCellH;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseIdentifier = @"FourCameraCellID";
    
    FourCameraCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[FourCameraCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    }
    
    Camera *mycam = [[GBase sharedBase].cameras objectAtIndex:indexPath.row];

    cell.imgLive.image = mycam.image;
    cell.labUid.text = mycam.uid;
    cell.labName.text = mycam.name;

    if (mycam.select) {
        cell.labName.text = [NSString stringWithFormat:@"%@ (%@)", mycam.name, INTERSTR(@"Existing")];
    }
    
    if (!mycam.online) {
        cell.labName.text = [NSString stringWithFormat:@"%@ (%@)", mycam.name, INTERSTR(@"Offline")];
    }
    
    if (mycam.select || !mycam.online) {
        cell.labUid.textColor = [UIColor grayColor];
        cell.labName.textColor = [UIColor grayColor];
    }
    
//    cell.btnSelect.tag = indexPath.row;
//    [cell.btnSelect setImage:[UIImage imageNamed:@"select_white"] forState:UIControlStateNormal];
//    [cell.btnSelect setImage:[UIImage imageNamed:@"select_mark"] forState:UIControlStateSelected];
//    [cell.btnSelect addTarget:self action:@selector(btnSelectAction:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    FourCameraCell *cell = [tableView cellForRowAtIndexPath:indexPath];
// 
//    cell.btnSelect.selected = !cell.btnSelect.selected;
//    
//    Camera *mycam = [[GBase sharedBase].cameras objectAtIndex:indexPath.row];
//    
//    mycam.select = cell.btnSelect.selected;
    
    Camera *mycam = [[GBase sharedBase].cameras objectAtIndex:indexPath.row];

    if (mycam.select) {
        [HXProgress showText:INTERSTR(@"This camera already existed")];
        return;
    }
    
    if (!mycam.online) {
        [HXProgress showText:INTERSTR(@"Offline")];
        return;
    }

    
    if (_selectCameraBlock) {
        _selectCameraBlock(mycam, self.viewTag);
    }
    [self.navigationController popViewControllerAnimated:YES];

}

- (void)btnSelectAction:(id)sender {
    
    UIButton *btn = (UIButton *)sender;
    
    btn.selected = !btn.selected;
    
    Camera *mycam = [[GBase sharedBase].cameras objectAtIndex:btn.tag];
    
    mycam.select = btn.selected;

    
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
