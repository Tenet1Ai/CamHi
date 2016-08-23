//
//  AudioViewController.m
//  CamHi
//
//  Created by HXjiang on 16/8/5.
//  Copyright © 2016年 Hichip. All rights reserved.
//

#import "AudioViewController.h"

#define TSLIDERINPUT    (100)
#define TSLIDEROUTPUT   (101)

@interface AudioViewController ()

@property (nonatomic, strong) UISegmentedControl *tsegment;
@property (nonatomic, strong) UISlider *tsliderInput;
@property (nonatomic, strong) UISlider *tsliderOutput;
@property (nonatomic, strong) UILabel *labInput;
@property (nonatomic, strong) UILabel *labOutput;
@property (nonatomic, strong) __block AudioAttr *audio;

@end

@implementation AudioViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setup];
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setup {
    
    [self.camera request:HI_P2P_GET_AUDIO_ATTR dson:nil];
    
    __weak typeof(self) weakSelf = self;
    
    self.camera.cmdBlock = ^(BOOL success, NSInteger cmd, NSDictionary *dic) {
        
        if (success) {
            
            if (cmd == HI_P2P_GET_AUDIO_ATTR) {
                
                weakSelf.audio = [weakSelf.camera object:dic];
                [weakSelf.tableView reloadData];
                
                LOG(@"dics:%@", dic);
            }
        }
        else {
            [HXProgress showText:NSLocalizedString(@"Command Error!", nil)];
        }
    };

}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"AudioCellID";
    HXCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[HXCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    
    NSInteger section = indexPath.section;
    
    if (section == 0) {
        cell.textLabel.text = INTERSTR(@"Input Type");
        [cell.contentView addSubview:self.tsegment];
        self.tsegment.selectedSegmentIndex = _audio.u32InMode;
    }
    
    if (section == 1) {
        [cell.contentView addSubview:self.labInput];
        [cell.contentView addSubview:self.tsliderInput];
        self.tsliderInput.value = (CGFloat)_audio.u32InVol;
        self.labInput.text = [NSString stringWithFormat:@"%d", (int)self.tsliderInput.value];
    }
    
    if (section == 2) {
        [cell.contentView addSubview:self.labOutput];
        [cell.contentView addSubview:self.tsliderOutput];
        self.tsliderOutput.value = (CGFloat)_audio.u32OutVol;
        self.labOutput.text = [NSString stringWithFormat:@"%d", (int)self.tsliderOutput.value];
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? 20 : 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return [self headerViewWithTitle:INTERSTR(@"Input Volume")];
    }
    if (section == 2) {
        return [self headerViewWithTitle:INTERSTR(@"Output Volume")];
    }
    return [self headerViewWithTitle:INTERSTR(@"")];
}

- (UIView *)headerViewWithTitle:(NSString *)title {
    
    CGFloat w = self.view.frame.size.width;
    CGFloat h = 50.0f;
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, w, h)];
    headerView.backgroundColor = RGBA_COLOR(220, 220, 220, 0.5);
    
    
    UILabel *labTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, 25, w-30, 25)];
    labTitle.text = title;
    labTitle.textColor = [UIColor grayColor];
    labTitle.font = [UIFont systemFontOfSize:14];
    
    [headerView addSubview:labTitle];
    
    return headerView;
}


- (UILabel *)labInput {
    if (!_labInput) {
        _labInput = [self setupLabel];
    }
    return _labInput;
}

- (UILabel *)labOutput {
    if (!_labOutput) {
        _labOutput = [self setupLabel];
    }
    return _labOutput;
}

- (UILabel *)setupLabel {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 35, 44)];
    return label;
}

- (UISlider *)tsliderInput {
    if (!_tsliderInput) {
        _tsliderInput = [self setupSlider];
        _tsliderInput.tag = TSLIDERINPUT;
    }
    return _tsliderInput;
}

- (UISlider *)tsliderOutput {
    if (!_tsliderOutput) {
        _tsliderOutput = [self setupSlider];
        _tsliderOutput.tag = TSLIDEROUTPUT;
    }
    return _tsliderOutput;
}

- (UISlider *)setupSlider {
    CGFloat w = self.view.frame.size.width-100;
    CGFloat h = 30.0f;
    CGFloat x = self.view.frame.size.width/2;
    CGFloat y = 44/2;
    UISlider *tslider = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, w, h)];
    tslider.center = CGPointMake(x, y);
    tslider.minimumValue = 1.0f;
    tslider.maximumValue = 100.0f;
    [tslider addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
    [tslider addTarget:self action:@selector(sliderEnd:) forControlEvents:UIControlEventTouchUpInside];

    return tslider;
}



-(void)sliderEnd:(id)sender{
    UISlider* slider = (UISlider*)sender;
    
    if (slider.tag == TSLIDERINPUT) {
        _audio.u32InVol = (int)slider.value;
    }
    
    if(slider.tag == TSLIDEROUTPUT){
        _audio.u32OutVol = (int)slider.value;
    }
    
    [self.camera request:HI_P2P_SET_AUDIO_ATTR dson:[self.camera dic:_audio]];
}

-(void)sliderChanged:(id)sender{
    UISlider* slider = (UISlider*)sender;
    
    NSString *newText = [[NSString alloc]initWithFormat:@"%d", (int)(slider.value )];
    
    if (slider.tag == TSLIDERINPUT) {
        _audio.u32InVol = (int)slider.value;
        _labInput.text = newText;
    }
    
    if(slider.tag == TSLIDEROUTPUT){
        _audio.u32OutVol = (int)slider.value;
        _labOutput.text = newText;
    }
}



- (UISegmentedControl *)tsegment {
    if (!_tsegment) {
        
        NSArray *items = @[INTERSTR(@"Line"), INTERSTR(@"Mic")];
        
        CGFloat w = 150.0f;
        CGFloat h = 30.0f;
        CGFloat x = self.view.frame.size.width-w/2-20;
        CGFloat y = 44/2;
        _tsegment = [[UISegmentedControl alloc] initWithItems:items];
        _tsegment.frame = CGRectMake(0, 0, w, h);
        _tsegment.center = CGPointMake(x, y);
        _tsegment.tintColor = [UIColor grayColor];
        [_tsegment addTarget:self action:@selector(tsegmentAction:) forControlEvents:UIControlEventValueChanged];
    }
    return _tsegment;
}

- (void)tsegmentAction:(id)sender {
    
    UISegmentedControl *tseg = (UISegmentedControl *)sender;
    
    NSInteger index = tseg.selectedSegmentIndex;
    
    _audio.u32InMode = (unsigned int)index;
    
    [self.camera request:HI_P2P_SET_AUDIO_ATTR dson:[self.camera dic:_audio]];
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
