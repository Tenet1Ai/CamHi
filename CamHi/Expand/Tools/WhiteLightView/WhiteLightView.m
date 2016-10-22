//
//  WhiteLightView.m
//  CamHi
//
//  Created by HXjiang on 16/9/23.
//  Copyright © 2016年 Hichip. All rights reserved.
//

#import "WhiteLightView.h"

@interface WhiteLightView ()
//{
//    CGFloat w
//}
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic, assign) NSInteger currentIndex;

@end

@implementation WhiteLightView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.titles = @[INTERSTR(@"Ordinary"), INTERSTR(@"Color"), INTERSTR(@"Intelligent")];
        
        _isShow = NO;
        [self addSubview:self.tableView];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    self.tableView.frame = CGRectMake(0, 0, rect.size.width, rect.size.height);
    
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titles.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellID = @"WhiteLightViewCellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    
    cell.textLabel.text = self.titles[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryNone;
    if (indexPath.row == self.selectIndex) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.currentIndex == indexPath.row) {
        return;
    }
    
    LOG(@"didSelectRowAtIndexPath : %d", (int)indexPath.row)

    self.currentIndex = indexPath.row;
    
    for (UITableViewCell *cell in self.tableView.visibleCells) {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    [self.camera changeWhiteLightModel:indexPath.row];
    
}


- (void)reloadWithIndex:(NSInteger)index {
    self.selectIndex = index;
    self.currentIndex = index;
    [self.tableView reloadData];
}


- (void)show {
    
    if (_isShow) {
        return;
    }
    
    _isShow = !_isShow;
    
    CGFloat px = self.superview.bounds.size.width/2;
    CGFloat py = self.superview.bounds.size.height/2;
    
    [UIView animateWithDuration:0.5 animations:^{
        self.center = CGPointMake(px, py);
    }];
}

- (void)dismiss {
    
    if (!_isShow) {
        return;
    }
    
    _isShow = !_isShow;
    
    CGFloat px = self.superview.bounds.size.width/2;
    CGFloat py = -CGRectGetHeight(self.frame);
    
    [UIView animateWithDuration:0.5 animations:^{
        self.center = CGPointMake(px, py);
    }];

}


@end
