//
//  OCScanLifeViewController.m
//  OcTrain
//
//  Created by HXjiang on 16/3/25.
//  Copyright © 2016年 蒋林. All rights reserved.
//

#import "OCScanLifeViewController.h"

#import <AVFoundation/AVFoundation.h>


@interface OCScanLifeViewController ()<AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, assign) BOOL isReading;
@property (nonatomic, strong) CALayer *scanLayer;
@property (nonatomic, strong) UIView *boxView;
@property (nonatomic, strong) UIView *viewPreview;
@property (nonatomic, strong) UILabel *messageLable;

@property (nonatomic, strong) AVCaptureDevice *device;
@property (nonatomic, strong) AVCaptureDeviceInput *input;
@property (nonatomic, strong) AVCaptureMetadataOutput *output;
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *preview;


@end

@implementation OCScanLifeViewController

#pragma mark - viewDidLoad
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setUp];
//    [self setUpUIBarButtonItem];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.session startRunning];
}

- (void)didReceiveMemoryWarning
{
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

- (void)setUpUIBarButtonItem
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply
                                                                                          target:self
                                                                                          action:@selector(didClickLeftBarbutton)];
}

- (void)didClickLeftBarbutton
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setUp
{
    CGFloat screenW = self.view.frame.size.width;
    CGFloat screenH = self.view.frame.size.height;
    
    //遮盖的阴影
    self.viewPreview = [[UIView alloc] initWithFrame:self.view.bounds];
    self.viewPreview.backgroundColor = [UIColor blackColor];
    self.viewPreview.alpha = 0.7;
    [self.view addSubview:self.viewPreview];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRect:self.view.bounds];
    [maskPath appendPath:[UIBezierPath bezierPathWithRect:CGRectMake(0.1*screenW, 0.2*screenH, 0.8*screenW, 0.4*screenH)]];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.fillRule = kCAFillRuleEvenOdd;
    maskLayer.path = maskPath.CGPath;
    self.viewPreview.layer.mask = maskLayer;

    
    //获取AVCaptureDevice的实例
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    //初始化输入流
    self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    //初始化输出流
    self.output = [[AVCaptureMetadataOutput alloc] init];
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    //创建会话
    self.session = [[AVCaptureSession alloc] init];
    [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([self.session canAddInput:self.input])
    {
        //添加输入流
        [self.session addInput:self.input];
    }
    if ([self.session canAddOutput:self.output])
    {
        //添加输出流
        [self.session addOutput:self.output];
    }
    
    // 条码类型 metadataObjectTypes 必须为 availableMetadataObjectTypes 里面支持的类型
    NSArray *metadataObjectTypes = nil;
    if ([self.output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeQRCode]) {
        metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
    }
    
    NSLog(@"self.output.availableMetadataObjectTypes :%@", self.output.availableMetadataObjectTypes);

    
    self.output.metadataObjectTypes = metadataObjectTypes;

    NSLog(@"self.output.metadataObjectTypes :%@", self.output.metadataObjectTypes);
    
    //创建输出对象
    self.preview = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    self.preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.preview.frame = self.view.layer.bounds;
    [self.view.layer insertSublayer:self.preview atIndex:0];
    
    //设置扫描范围
    self.output.rectOfInterest = CGRectMake(0.2, 0.2, 0.8, 0.8);

    //扫描框
    self.boxView = [[UIView alloc] initWithFrame:CGRectMake(0.1*screenW, 0.2*screenH, 0.8*screenW, 0.4*screenH)];
//    self.boxView.layer.borderColor = [UIColor greenColor].CGColor;
//    self.boxView.layer.borderWidth = 1.0f;
//    self.boxView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:self.boxView];
    
    //四个角
    CGFloat boxW = self.boxView.frame.size.width;
    CGFloat boxH = self.boxView.frame.size.height;
    CGFloat labx = -1;
    CGFloat labY = -1;
    CGFloat labW = 20;
    CGFloat labH = 2;
    [self.boxView addSubview:[self setUpLabelFrame:CGRectMake(labx, labY, labW, labH)]];
    [self.boxView addSubview:[self setUpLabelFrame:CGRectMake(labx, labY, labH, labW)]];
    [self.boxView addSubview:[self setUpLabelFrame:CGRectMake(labx, boxH+1-labH, labW, labH)]];
    [self.boxView addSubview:[self setUpLabelFrame:CGRectMake(labx, boxH+1-labW, labH, labW)]];
    [self.boxView addSubview:[self setUpLabelFrame:CGRectMake(boxW+1-labW, labY, labW, labH)]];
    [self.boxView addSubview:[self setUpLabelFrame:CGRectMake(boxW+1-labH, labY, labH, labW)]];
    [self.boxView addSubview:[self setUpLabelFrame:CGRectMake(boxW+1-labW, boxH+1-labH, labW, labH)]];
    [self.boxView addSubview:[self setUpLabelFrame:CGRectMake(boxW+1-labH, boxH+1-labW, labH, labW)]];
    
    
    _messageLable = [[UILabel alloc] init];
    _messageLable.frame = CGRectMake(20, self.boxView.frame.origin.y+50+boxH, screenW-40, 150);
    //_messageLable.text = @"Please put the QR Code within the frame.";
    _messageLable.numberOfLines = 0;
    _messageLable.textColor = [UIColor whiteColor];
    _messageLable.textAlignment = NSTextAlignmentCenter;
    [_messageLable sizeToFit];
    [self.viewPreview addSubview:_messageLable];
    
    //扫描线
    [self showScanLine];
     NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(moveLayer) userInfo:nil repeats:YES];
    [timer fire];
    
    //start session
    [self.session startRunning];

}

- (void)showScanLine
{
    self.scanLayer = [[CALayer alloc] init];
    self.scanLayer.frame = CGRectMake(0, 0, self.boxView.frame.size.width, 1);
    self.scanLayer.backgroundColor = [UIColor greenColor].CGColor;
    [self.boxView.layer addSublayer:self.scanLayer];
}

- (void)dismissScanLine
{
    [self.scanLayer removeFromSuperlayer];
}

- (void)moveLayer
{
    CGRect frame = self.scanLayer.frame;
    if (_boxView.frame.size.height < _scanLayer.frame.origin.y)
    {
//        frame.origin.y = 0;
//        _scanLayer.frame = frame;
        [self dismissScanLine];
        [self showScanLine];
    }
    else
    {
        frame.origin.y += 10;
        [UIView animateWithDuration:0.1 animations:^{
            _scanLayer.frame = frame;
        }];
    }
}

#pragma mark -- AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    NSString *stringValue;
    if ([metadataObjects count] > 0)
    {
        //stop session
        [self.session stopRunning];
        
        AVMetadataMachineReadableCodeObject *metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
        NSLog(@"metadataObject = %@", metadataObject.stringValue);

        if (self.delegate)
        {
            [self.delegate scanResult:stringValue];
        }
        
        if ([metadataObject.type isEqualToString:AVMetadataObjectTypeQRCode])
        {
            NSLog(@"是二维码...");
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - 扫描框的四个角
- (UILabel *)setUpLabelFrame:(CGRect)frame
{
    UILabel *lable = [[UILabel alloc] initWithFrame:frame];
    lable.backgroundColor = [UIColor redColor];
    return lable;
}

@end
