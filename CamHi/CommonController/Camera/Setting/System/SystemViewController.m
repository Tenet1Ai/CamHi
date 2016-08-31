//
//  SystemViewController.m
//  CamHi
//
//  Created by HXjiang on 16/8/12.
//  Copyright © 2016年 Hichip. All rights reserved.
//

#import "SystemViewController.h"
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>

typedef NS_ENUM(NSInteger, CommandType) {
    CommandTypeNone,
    CommandTypeReboot,
    CommandTypeReset,
    CommandTypeGetInfo,
};

@interface SystemViewController ()

@property (nonatomic, strong) NSMutableArray *titles;
@property (nonatomic, strong) __block DeviceInfoExt *deviceInfoExt;
@property (nonatomic, strong) SetDownload *download;
@property (nonatomic, copy) NSString *onlineVersion;
@property (nonatomic, copy) NSString *urlAddress;
@property (nonatomic, assign) CommandType commandType;

@end

@implementation SystemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setup];
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = RGBA_COLOR(220, 220, 220, 0.5);
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.camera setReconnectTimes:3];
    [HXProgress dismiss];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setup {
    
    _commandType = CommandTypeNone;
    
    _titles = [[NSMutableArray alloc] initWithCapacity:0];
    [_titles addObject:INTERSTR(@"Reboot Camera")];
    [_titles addObject:INTERSTR(@"Reset Camera")];
    if ([self.camera isGoke]) {
        [_titles addObject:INTERSTR(@"Check update")];
    }

    _download = [[SetDownload alloc] init];
    
    __weak typeof(self) weakSelf = self;
    
    self.camera.cmdBlock = ^(BOOL success, NSInteger cmd, NSDictionary *dic) {
      
        if (cmd == HI_P2P_SET_REBOOT) {
            if (success) {
                [HXProgress showProgress];
                //[weakSelf.navigationController popToRootViewControllerAnimated:YES];
            }
        }
        
        if (cmd == HI_P2P_SET_RESET) {
            if (success) {
                [HXProgress showProgress];
                //[weakSelf.navigationController popToRootViewControllerAnimated:YES];
            }
        }
        
        
        if (cmd == HI_P2P_GET_DEV_INFO_EXT) {
            
            if (_commandType == CommandTypeGetInfo) {
                _commandType = CommandTypeNone;
                if (success) {
                    weakSelf.deviceInfoExt = [weakSelf.camera object:dic];
                    [weakSelf requestOnlineVersion];
                    LOG(@"weakSelf.deviceInfoExt.aszSystemSoftVersion:%@", weakSelf.deviceInfoExt.aszSystemSoftVersion)
                }
            }
            
            if (_commandType == CommandTypeNone) {
                
            }
            
        }
        
        if (cmd == HI_P2P_SET_DOWNLOAD) {
            if (success) {
                [HXProgress showProgress];
                //[weakSelf.navigationController popToRootViewControllerAnimated:YES];
            }
        }

    };//@cmdBlock
    
    
    self.camera.connectBlock = ^(NSInteger state, NSString *connection) {
        
        LOG(@">>> connection:%@", connection);
        if (state == CAMERA_CONNECTION_STATE_DISCONNECTED) {
            //[HXProgress dismiss];
            //[weakSelf.camera connect];
        }
        
        
        
        /*
         *  重启或者恢复出厂设置时都会增加重连次数以保证能成功连接
         *  连接成功或者密码错误时需将连接次数恢复至默认值(3次)后返回主界面
         */
        if (state == CAMERA_CONNECTION_STATE_LOGIN) {
            
            [weakSelf.camera setReconnectTimes:3];
            [HXProgress dismiss];
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        }
        
        if (state == CAMERA_CONNECTION_STATE_WRONG_PASSWORD) {
         
            [weakSelf.camera setReconnectTimes:3];
            [HXProgress dismiss];
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        }
        
    };//@connectBlock
    
}


#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _titles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"SystemCellID";
    HXCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[HXCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    
    NSInteger section = indexPath.section;
    cell.textLabel.text = _titles[section];
    cell.textLabel.textColor = [UIColor redColor];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    
    if (section == 0) {
        [self rebootCamera];
    }
    
    if (section == 1) {
        [self resetCamera];
    }
    
    if (section == 2) {
        [self checkUpdate];
    }
}




#pragma mark - UIAlertViewDelegate
- (void)presentAlertViewBeforeIOS8WithTag:(NSInteger)tag message:(NSString *)message {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:INTERSTR(@"Warning") message:message delegate:self cancelButtonTitle:INTERSTR(@"No") otherButtonTitles:INTERSTR(@"Yes"), nil];
    alertView.tag = tag;
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    NSLog(@"buttonIndex:%ld", buttonIndex);
    
    if (buttonIndex == 1) {
        
        /*
         *  重启或者恢复出厂设置或者远程升级时增加重连次数以保证能连接成功
         *  连接成功后需修改为默认的3次
         */

        if (alertView.tag == 0) {
            
            [self.camera setReconnectTimes:10];
            [self.camera request:HI_P2P_SET_REBOOT dson:nil];
            self.commandType = CommandTypeReboot;
        }
        
        
        if (alertView.tag == 1) {
         
            [self.camera setReconnectTimes:10];
            [self.camera request:HI_P2P_SET_RESET dson:nil];
            self.commandType = CommandTypeReset;
        }
        
        if (alertView.tag == 1) {
            
            [self.camera setReconnectTimes:20];
            [self.camera request:HI_P2P_SET_DOWNLOAD dson:[self.camera dic:_download]];
        }

        
    }
    
}




- (void)rebootCamera {
    
    if (SystemVersion > 8.0) {
        
        __weak typeof(self) weakSelf = self;
        
        [self presentAlertTitle:INTERSTR(@"Warning") message:INTERSTR(@"Are you sure to reboot camera?") alertStyle:UIAlertControllerStyleAlert actionDefaultTitle:INTERSTR(@"Yes") actionDefaultBlock:^{
            
            [self.camera setReconnectTimes:10];
            [weakSelf.camera request:HI_P2P_SET_REBOOT dson:nil];
            weakSelf.commandType = CommandTypeReboot;

        } actionCancelTitle:INTERSTR(@"No") actionCancelBlock:^{
            
        }];//@presentAlertTitle
    }
    else {
        [self presentAlertViewBeforeIOS8WithTag:0 message:INTERSTR(@"Are you sure to reboot camera?")];
    }
    
}

- (void)resetCamera {
    
    if (SystemVersion > 8.0) {
        
        __weak typeof(self) weakSelf = self;
        
        [self presentAlertTitle:INTERSTR(@"Warning") message:INTERSTR(@"Setup data will be initialized. Are you sure to reset?") alertStyle:UIAlertControllerStyleAlert actionDefaultTitle:INTERSTR(@"Yes") actionDefaultBlock:^{
            
            [self.camera setReconnectTimes:10];
            [weakSelf.camera request:HI_P2P_SET_RESET dson:nil];
            weakSelf.commandType = CommandTypeReset;

        } actionCancelTitle:INTERSTR(@"No") actionCancelBlock:^{
            
        }];//@presentAlertTitle
    }
    else {
        [self presentAlertViewBeforeIOS8WithTag:1 message:INTERSTR(@"Setup data will be initialized. Are you sure to reset?")];
    }
    
}

- (void)checkUpdate {
    [self.camera request:HI_P2P_GET_DEV_INFO_EXT dson:nil];
    _commandType = CommandTypeGetInfo;
}


-(void) requestOnlineVersion {
    
    //20160706  更换新的服务器地址以及新格式json数据
    //  服务器后缀名：goke_update.html
    //  新的json数据格式：{"list": [ {"url":"http://58.64.153.34/","ver":"V9.1.4.1.17"},
    //                           {"url":"http://58.64.153.34/","ver":"V9.1.4.2.18"}]}
    //20160706  end
    
    
    
    [HXProgress showProgress];
    //    1.设置请求路径
    //    NSString *urlStr=[NSString stringWithFormat:@"http://58.64.153.34/goke_hx_motor_update.html"];
    NSString *urlStr=[NSString stringWithFormat:@"http://58.64.153.34/goke_update.html"];
    NSURL *urls=[NSURL URLWithString:urlStr];
    
    //    2.创建请求对象
    NSURLRequest *request=[NSURLRequest requestWithURL:urls];
    
    
    dispatch_queue_t queue = dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        //    3.发送请求
        //3.1发送同步请求，在主线程执行
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        //（一直在等待服务器返回数据，这行代码会卡住，如果服务器没有返回数据，那么在主线程UI会卡住不能继续执行操作）
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self recvUrlData:data];
        });
    });
    
    NSLog(@"Dersialized JSON Dictionary end");
    
}


- (void) recvUrlData:(NSData*)data {
    
    [HXProgress dismiss];
    BOOL isUpdate = NO;
    NSError *error = nil;
    
    id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    
    NSDictionary *jsonDic = (NSDictionary *)jsonObject;
    
    NSArray *jsonLists = jsonDic[@"list"];
    
    for (NSDictionary *dic in jsonLists) {
        
        NSString *url = dic[@"url"];
        NSString *ver = dic[@"ver"];
        
        isUpdate = [self isUpdateNewVersion:ver oldVersion:_deviceInfoExt.aszSystemSoftVersion];
        
        if (isUpdate) {
            
            _urlAddress = url;
            _onlineVersion = ver;
            _download.sFileName = [NSString stringWithFormat:@"%@%@.exe", _urlAddress, _onlineVersion];
            break;
        }
        
//        _urlAddress = url;
//        _onlineVersion = ver;

    }
    
    
//    isUpdate = YES;
    
    if (isUpdate) {
        [self doCheckRedirect:_urlAddress Version:_onlineVersion];
    }
    else {
        [HXProgress showText:INTERSTR(@"It is the latest version already")];
    }
}



//判断是否有新版本
- (BOOL)isUpdateNewVersion:(NSString *)new oldVersion:(NSString *)old {
    
    NSLog(@"new:%@  old:%@", new, old);
    
    BOOL update = NO;
    
    NSArray *b_new = [new componentsSeparatedByString:@"."];
    NSArray *b_old = [old componentsSeparatedByString:@"."];
    
    if( (b_new.count == b_old.count) || b_old.count==5) {
        for(int i=0;i<b_new.count;i++) {
            
            if(i==b_new.count-1) {
                for(id obj in b_old)
                {
                    NSLog(@"str:%@",obj);
                }
                
                NSArray * last_new_array = [[b_new objectAtIndex:i]componentsSeparatedByString:@"-"];
                NSArray * last_old_array = [[b_old objectAtIndex:i]componentsSeparatedByString:@"-"];
                NSInteger newi = 0;
                if(last_new_array.count>=1) {
                    newi = [[last_new_array objectAtIndex:0]integerValue];
                    NSLog(@"newi:%ld",(long)newi);
                }
                
                NSInteger oldi =0;
                if(last_old_array.count>=1) {
                    oldi = [[last_old_array objectAtIndex:0]integerValue];
                    NSLog(@"oldi:%ld",(long)oldi);
                    
                }
                if(newi>oldi) {
                    update = 1;
                }
                
            }
            else  {
                
                NSString* n = [b_new objectAtIndex:i];
                NSString* o = [b_old objectAtIndex:i];
                
                if(![n isEqualToString:o]) {
                    NSLog(@"  -----str:%@  %@",n,o);
                    update = false;
                    break;
                }
            }
            
        }//@for
    }
    
    return update;
}







- (void)startDownload:(NSString*)url_ {
    
    if (url_ != nil) {
        _download.sFileName = url_;
    }
    
    LOG(@">>> _download.sFileName:%@", _download.sFileName);
    
    if (SystemVersion > 8.0) {
        
        [self presentAlertTitle:INTERSTR(@"Warning") message:INTERSTR(@"new firmware is available, update?") alertStyle:UIAlertControllerStyleAlert actionDefaultTitle:INTERSTR(@"Yes") actionDefaultBlock:^{
            
            
            [self.camera setReconnectTimes:20];
            [self.camera request:HI_P2P_SET_DOWNLOAD dson:[self.camera dic:_download]];
            
        } actionCancelTitle:INTERSTR(@"No") actionCancelBlock:^{
            
        }];
        
    }
    else {
        [self presentAlertViewBeforeIOS8WithTag:2 message:INTERSTR(@"new firmware is available, update?")];
    }
}







-(void) doCheckRedirect:(NSString*)host_ Version:(NSString*)ver_ {
    
    dispatch_queue_t queue = dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        
        char* redirect_url = NULL;
        //        char ipaddr[128] = "58.64.153.34";
        char ipaddr[128] = {0};
        int ipport = 80;
        
        HI_Get_Host_Port((char*)[host_ UTF8String],ipaddr,&ipport);
        
        //        const char* verc = [ver_ UTF8String];
        
        char version[64] = {0};
        sprintf(version, "/%s.exe",[ver_ UTF8String]);
        //        char version[64] = "/V7.1.4.1.11.exe";
        //    char version[] = "/V9.1.4.1.14.exe";
        int s32Timeout = 10000;
        char* head = malloc(256);
        
        int u32BufLen = 1024;
        char* pBuf = malloc(u32BufLen);
        
        int s32Sock,s32Ret;
        
        
        printf("ip:%s   port:%d   version:%s\n",ipaddr,ipport,version);
        
        
        struct sockaddr_in addr;
        
        if ((s32Sock = socket(AF_INET, SOCK_STREAM, 0)) < 0)
        {
            return;
        }
        addr.sin_family = AF_INET;
        addr.sin_port=htons(ipport);
        addr.sin_addr.s_addr = inet_addr(ipaddr);
        
        
        
        
        
        s32Ret = connect(s32Sock, (struct sockaddr *)&addr, sizeof(addr));
        if (s32Sock < 0)
        {
            printf("connect error \n");
            //        close(s32Sock);
            goto RET;
            return;
        }
        
        
        char *pTemp = head;
        memset(pTemp, 0, 256);
        
        
        pTemp += sprintf(pTemp,"GET %s HTTP/1.1\r\n",version);
        pTemp += sprintf(pTemp,"Accept: */*\r\n");
        pTemp += sprintf(pTemp,"Accept-Language: zh-cn\r\n");
        pTemp += sprintf(pTemp,"User-Agent: Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1)\r\n");
        pTemp += sprintf(pTemp,"Host: %s\r\n", ipaddr);
        pTemp += sprintf(pTemp,"Connection: Keep-Alive\r\n");
        pTemp += sprintf(pTemp,"\r\n");
        
        //    printf("-------------pTemp--------------:%s \n",pTemp);
        
        //    memset(head, 0, 256);
        
        s32Ret = (int)send(s32Sock, head, strlen(head), 0);
        if(s32Ret < 0) {
            printf("send error \n");
            //        close(s32Sock);
            goto RET;
        }
        //    printf("-------------send--------------:%d \n",s32Ret);
        
        
        
        int ret=0;
        ssize_t recvBytes = 0;
        int u32LineLen  =0;
        fd_set rfds;
        struct timeval tv;
        
        FD_ZERO(&rfds);
        FD_SET((HI_U32)s32Sock, &rfds);
        tv.tv_sec = s32Timeout / 1000;
        tv.tv_usec = (s32Timeout % 1000) * 1000;
        
        
        
        
        
        ret = select(s32Sock+1,&rfds,NULL,NULL,&tv);
        
        if(ret > 0) {
            if(FD_ISSET(s32Sock, &rfds))
            {
                while (u32LineLen<u32BufLen)
                {
                    recvBytes = recv(s32Sock, pBuf+u32LineLen, 1,0);//一次读取一个字节
                    
                    if(recvBytes <= 0){
                        return;
                    }
                    
                    u32LineLen ++;
                    if(u32LineLen >= 4
                       && pBuf[u32LineLen-1] =='\n' && pBuf[u32LineLen-2] == '\r'
                       && pBuf[u32LineLen-3] == '\n' && pBuf[u32LineLen-4] == '\r'){
                        break;
                    }
                }//end while
            }
            
            printf("0-------------recv--------------:%s \n",pBuf);
            
            if(strstr(pBuf,"302 Found") || strstr(pBuf,"301 Moved Permanently")) {
                
                char* local = strstr(pBuf,"Location:");
                
                char* ptr = strchr(local, '\n');
                long end = ptr-local;
                
                
                redirect_url = malloc(end + 1);
                memset(redirect_url, 0, end +1);
                
                memcpy(redirect_url, local + 10, end-11);
                
                
                
                printf("0-------------url--------------:%s \n",redirect_url);
                
            }
            
        }
        
        
        
        
    RET:
        
        free(head);
        free(pBuf);
        
        close(s32Sock);
        
        printf("1-------------url--------------:%s \n",redirect_url);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            printf("2-------------url--------------:%s \n",redirect_url);
            if(redirect_url)
                [self startDownload:[NSString stringWithUTF8String:redirect_url]];
            else {
                [self startDownload:nil];
            }
            
        });
        if(redirect_url) {
            free(redirect_url);
        }
    });
    
    
}


HI_S32 HI_Get_Host_Port(HI_CHAR * szSrc, HI_CHAR * szPath, HI_S32 * s32Port)
{
    HI_S32 s32Len = 0, i;
    HI_CHAR *pPtr = NULL, *pCol = NULL, *pSrc = szSrc, szPort[32] = {0};
    HI_CHAR *pHttp = NULL;
    
    pHttp = strstr(pSrc, "http://");
    if(pHttp)
        pSrc = pHttp + 7;
    
    pHttp = strstr(pSrc, "https://");
    if(pHttp)
        pSrc = pHttp + 8;
    
    pPtr = strstr(pSrc, "/");
    if(NULL == pPtr)
    {
        printf("filepath hao no '/', error");
        return HI_FAILURE;
    }
    s32Len = (HI_S32)(pPtr-pSrc);
    if(s32Len > 64)
    {
        printf("filepath's len is too long\n");
        return HI_FAILURE;
    }
    
    pCol = strstr(pSrc, ":");
    if(pCol != NULL && pCol < pPtr)
    {
        s32Len = (HI_S32)(pCol-pSrc);
        memcpy(szPath, pSrc, s32Len);
        szPath[s32Len] = '\0';
        pCol++;
        s32Len = (HI_S32)(pPtr-pCol);
        memcpy(szPort, pCol, s32Len);
        szPort[s32Len] = '\0';
        for(i=0;i<s32Len;i++)
            if(szPort[i] < 0 || szPort[i] > 9)
            {
                printf("port error(%s)\n", szPort);
                return HI_FALSE;
            }
        *s32Port = atoi(szPort);
    }
    else
    {
        memcpy(szPath, pSrc, s32Len);
        szPath[s32Len] = '\0';
        *s32Port = 80;
    }
    
    return HI_SUCCESS;
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
