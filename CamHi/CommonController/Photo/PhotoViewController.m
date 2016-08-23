//
//  PhotoViewController.m
//  CamHi
//
//  Created by HXjiang on 16/7/11.
//  Copyright © 2016年 JiangLin. All rights reserved.
//

#import "PhotoViewController.h"
#import "PhotoCollectionViewController.h"

@interface PhotoViewController ()


@end

@implementation PhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;

    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [GBase sharedBase].cameras.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellID = @"PictureCellID";
    HXCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[HXCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    
    Camera *mycam = [[GBase sharedBase].cameras objectAtIndex:indexPath.row];
    
    NSInteger picCount = [GBase picturesForCamera:mycam].count;
    
    cell.textLabel.text = mycam.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ (%ld)", mycam.uid, picCount];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Camera *mycam = [[GBase sharedBase].cameras objectAtIndex:indexPath.row];
    
    NSInteger picCount = [GBase picturesForCamera:mycam].count;

    if (picCount == 0) {
        [HXProgress showText:INTERSTR(@"No Picture")];
        return;
    }
    
    
    PhotoCollectionViewController *photoCollection = [[PhotoCollectionViewController alloc] init];
    photoCollection.camera = mycam;
    photoCollection.title = INTERSTR(@"Picture");
    [self.navigationController pushViewController:photoCollection animated:YES];
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
