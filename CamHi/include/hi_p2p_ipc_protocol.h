#ifndef __HI_P2P_IPC_PROTOCOL_H__
#define __HI_P2P_IPC_PROTOCOL_H__
#include "hi_type.h"
/*
1. command structure
header
authauthorization
context
*/
#define HI_P2P_MAX_CMD_BUF_LEN 1000 /*每个请求和回复命令的最大长度*/
#define HI_P2P_MAX_FRAME_SIZE	128*1024
#define HI_P2P_NET_LEN 64
#define HI_P2P_MAX_STRINGLENGTH (40)		// 系统信息长度
#define HI_P2P_MAX_VERLENGTH (64)
#define HI_P2P_HEADER_FLAG		0x99999999
#define HI_P2P_STATUS_SUCCESS 	0
#define HI_P2P_STATUS_FAILURE -1
typedef struct
{
    HI_U32 u32Flag;          /* 标志 */
    HI_U32 u32Lens;          /* 数据长度，不包含头 */
    HI_U32 u32Type;          /* 类型 */
    HI_S32 s32Status;	     /* 状态 */
    HI_U32 u32Reserved[2];   /* 保留字段 */
} HI_P2P_S_HEADER;

#define HI_P2P_VIDEO_FRAME_FLAG 0x46565848	/* 视频帧标志 */
#define HI_P2P_AUDIO_FRAME_FLAG 0x46415848  /* 音频帧标志 */

#define HI_P2P_VIDEO_FRAME_I    1 /* 关键帧 */
#define HI_P2P_VIDEO_FRAME_P    2 /* 非关键帧 */
typedef struct 
{
    HI_U32 u32AVFrameFlag;       /*帧标志*/
    HI_U32 u32AVFrameLen;        /*帧的长度*/
    HI_U32 u32AVFramePTS;        /*时间戳*/
    HI_U32 u32VFrameType;        /*视频的类型，I帧或P帧*/
} HI_P2P_S_AVFrame;

/*****************HI_P2P_LOGIN***********************/
#define P2P_ENCODE_LEN 128
/* 用户名和密码以base64加密放在sClientInfo中
加密格式:  user:password
*/
typedef struct 
{
	HI_U32   u32LoginLevel;/*0: 管理员,1:user 2:guest*/
	HI_CHAR sLognInfo[P2P_ENCODE_LEN];
}HI_P2P_LOGIN_INFO;
/*****************HI_P2P_LOGIN***********************/


/* 用户名和密码为base64加密 */
#define HI_P2P_AUTH_LEN 64
/*****************HI_P2P_GET_USER_PARAM***********************/
typedef struct 
{
    HI_U8 u8UserName[HI_P2P_AUTH_LEN];
    HI_U8 u8Password[HI_P2P_AUTH_LEN];
    HI_U32   u32UserLevel;/*0: 管理员,1:user 2:guest*/
} HI_P2P_S_AUTH;
/*****************HI_P2P_GET_USER_PARAM***********************/

/*****************HI_P2P_SET_USER_PARAM || HI_P2P_SET_USERNAME***********************/
typedef struct
{
	HI_P2P_S_AUTH sNewUser;
	HI_P2P_S_AUTH sOldUser;
}HI_P2P_SET_AUTH;
/*****************HI_P2P_SET_USER_PARAM || HI_P2P_SET_USERNAME***********************/

/****************HI_P2P_START_LIVE*******************/
#define HI_P2P_STREAM_1 1
#define HI_P2P_STREAM_2 0
#define HI_P2P_STREAM_3 2

#define HI_P2P_LIVE_TYPE_VIDEO 	0x00000001
#define HI_P2P_LIVE_TYPE_AUDIO 	0x00000002
#define HI_P2P_LIVE_TYPE_ALL 	0x00000003
typedef struct 
{
    HI_U32 u32Stream;	
    HI_U32 u32Type;
    HI_U32 u32Channel;/*ipc: 0*/
    HI_U32 u32Quality;
    HI_CHAR sReserved[4];
} HI_P2P_S_LIVE_REQ;

/* 音频格式 */
#define HI_P2P_DEV_AUDIO_TYPE_G711		0 /* g711a */
#define HI_P2P_DEV_AUDIO_TYPE_G726		1
#define HI_P2P_DEV_AUDIO_TYPE_AMR		2 /* AMR NB 12.2kbps */

typedef struct 
{
    HI_U32 u32Stream;
    HI_U32 u32VideoWidth;
    HI_U32 u32VideoHeight;
    HI_U32 u32AudioType;
} HI_P2P_S_LIVE_RESP;
/****************HI_P2P_START_LIVE*******************/

/****************HI_P2P_START_TALK*******************/
typedef struct 
{	
    HI_U32 u32Channel;/*ipc: 0*/
    HI_U32 u32AudioType;
} HI_P2P_S_TALK_REQ;
/****************HI_P2P_START_TALK*******************/


/****************HI_P2P_GET_VIDEO_PARAM  HI_P2P_SET_VIDEO_PARAM*******************/
typedef struct 
{
    HI_U32 u32Channel;/*ipc: 0*/
    HI_U32 u32Stream;           /*HI_P2P_STREAM_1 ...*/
    HI_U32 u32Cbr;
    HI_U32 u32Frame;
    HI_U32 u32BitRate;
    HI_U32 u32Quality;
    HI_U32 u32IFrmInter;
} HI_P2P_S_VIDEO_PARAM;
/****************HI_P2P_GET_VIDEO_PARAM  HI_P2P_SET_VIDEO_PARAM*******************/


/****************HI_P2P_GET_AUDIO_ATTR  HI_P2P_SET_AUDIO_ATTR*******************/
typedef struct 
{
    HI_U32 u32Channel;/*ipc: 0*/
    HI_U32 u32Enable;
    HI_U32 u32Stream;           /*HI_P2P_STREAM_1 ...*/
    HI_U32 u32AudioType;
    HI_U32 u32InMode;		/*0：线性输入1：麦克输入*/
    HI_U32 u32InVol;	/* 输入音量*/
    HI_U32 u32OutVol;  /*输出音量*/
} HI_P2P_S_AUDIO_ATTR;
/****************HI_P2P_GET_AUDIO_ATTR  HI_P2P_SET_AUDIO_ATTR*******************/


/****************HI_P2P_GET_DISPLAY_PARAM  HI_P2P_SET_DISPLAY_PARAM*******************/
typedef struct 
{
    HI_U32 u32Channel;/*ipc: 0*/
    HI_U32 u32Brightness;
    HI_U32 u32Contrast;
    HI_U32 u32Saturation;
    HI_U32 u32Sharpness;    
    HI_U32 u32Flip;
    HI_U32 u32Mirror;
    HI_U32 u32Mode;
    HI_U32 u32Wdr;
    HI_U32 u32Shutter;
    HI_U32 u32Night;
} HI_P2P_S_DISPLAY;
/****************HI_P2P_GET_DISPLAY_PARAM  HI_P2P_SET_DISPLAY_PARAM*******************/


/****************HI_P2P_GET_FREQ_PARAM  HI_P2P_SET_FREQ_PARAM*******************/
#define HI_P2P_PAL_50HZ 50
#define HI_P2P_NTSC_60HZ 60
typedef struct
{
    HI_U32 u32Channel;/*ipc: 0*/
    HI_U32 u32Freq;
} HI_P2P_S_Frequency;
/****************HI_P2P_GET_FREQ_PARAM  HI_P2P_SET_FREQ_PARAM*******************/

/****************HI_P2P_GET_OSD_PARAM  HI_P2P_SET_OSD_PARAM*******************/
typedef struct 
{    
    HI_U32 u32Channel;/*ipc: 0*/
    HI_U32 u32EnTime; /*时间,0 :close  !0 :open*/
    HI_U32 u32EnName; /*名称,0 :close  !0 :open*/
    HI_U32 u32PlaceTime;/*时间坐标*/
    HI_U32 u32PlaceName;/*名称坐标*/
    HI_CHAR strName[64];
} HI_P2P_S_OSD;
/****************HI_P2P_GET_OSD_PARAM  HI_P2P_SET_OSD_PARAM*******************/

/****************HI_P2P_GET_NET_PARAM  HI_P2P_SET_NET_PARAM*******************/
typedef struct 
{    
    HI_U32 u32Channel;/*ipc: 0*/
	HI_CHAR strIPAddr[HI_P2P_NET_LEN];
	HI_CHAR strNetMask[HI_P2P_NET_LEN];
	HI_CHAR strGateWay[HI_P2P_NET_LEN];
	HI_CHAR strFDNSIP[HI_P2P_NET_LEN];
	HI_CHAR strSDNSIP[HI_P2P_NET_LEN];
	HI_U32	u32Port;
	HI_U32 u32DhcpFlag;
	HI_U32 u32DnsDynFlag;
} HI_P2P_S_NET_PARAM;
/****************HI_P2P_GET_NET_PARAM  HI_P2P_SET_NET_PARAM*******************/

/****************HI_P2P_GET_WIFI_PARAM  HI_P2P_SET_WIFI_PARAM*****************
 ****************HI_P2P_GET_WIFI_LIST   HI_P2P_SET_WIFI_CHECK*************/
typedef enum
{
	HI_P2P_WIFIAPMODE_INFRA				= 0x00,
	HI_P2P_WIFIAPMODE_ADHOC				= 0x01,
}ENUM_AP_MODE;

typedef enum
{
	HI_P2P_WIFIAPENC_INVALID			= 0x00, 
	HI_P2P_WIFIAPENC_NONE				= 0x01, //
	HI_P2P_WIFIAPENC_WEP				= 0x02, //WEP, for no password
	HI_P2P_WIFIAPENC_WPA_TKIP			= 0x03, 
	HI_P2P_WIFIAPENC_WPA_AES			= 0x04, 
	HI_P2P_WIFIAPENC_WPA2_TKIP			= 0x05, 
	HI_P2P_WIFIAPENC_WPA2_AES			= 0x06, 
}ENUM_AP_ENCTYPE;

typedef struct 
{    
    HI_U32 u32Channel;/*ipc: 0*/
	HI_U32 u32Enable;
	HI_CHAR Mode;/*ENUM_AP_MODE*/
	HI_CHAR EncType;/*ENUM_AP_ENCTYPE*/
	HI_CHAR strSSID[32];
	HI_CHAR strKey[HI_P2P_NET_LEN];
} HI_P2P_S_WIFI_PARAM;

/*HI_P2P_SET_WIFI_CHECK*/
typedef struct 
{    
    HI_U32 u32Channel;/*ipc: 0*/
	HI_U32 u32Enable;
	HI_CHAR Mode;/*ENUM_AP_MODE*/
	HI_CHAR EncType;/*ENUM_AP_ENCTYPE*/
	HI_CHAR strSSID[32];
	HI_CHAR strKey[HI_P2P_NET_LEN];
	HI_U32 u32Check;						/*1: check, 0:nocheck*/
} HI_P2P_S_WIFI_CHECK;

typedef struct
{
	HI_CHAR strSSID[32];			// WiFi ssid
	HI_CHAR Mode;	   				// refer to ENUM_AP_MODE
	HI_CHAR EncType; 				// refer to ENUM_AP_ENCTYPE
	HI_CHAR Signal;   				// signal intensity 0--100%
	HI_CHAR Status;   				// 0 : invalid ssid
								// 1 : connected							
}SWifiAp;
#define HI_P2P_MAX_LIST_WIFI_NUM 26
typedef struct
{ 
	HI_U32 u32Num;
	SWifiAp sWifiInfo[0];
} HI_P2P_S_WIFI_LIST;
 /****************HI_P2P_GET_WIFI_PARAM  HI_P2P_SET_WIFI_PARAM HI_P2P_GET_WIFI_LIST*******************/

/****************HI_P2P_GET_MD_PARAM  HI_P2P_SET_MD_PARAM******************
 移动侦测参数的设置************************************************/
#define HI_P2P_MOTION_AREA_MAX	4
#define HI_P2P_MOTION_AREA_1    1
#define HI_P2P_MOTION_AREA_2    2
#define HI_P2P_MOTION_AREA_3    3
#define HI_P2P_MOTION_AREA_4    4
typedef struct 
{
	HI_U32 u32Area;/*获取和设置那个区域就赋值那个区域*/
	HI_U32 u32Enable;
	HI_U32 u32X;
	HI_U32 u32Y;
	HI_U32 u32Width;
	HI_U32 u32Height;
	HI_U32 u32Sensi;	/* 报警灵敏度，取值范围1~99 */
} HI_P2P_S_MD_AREA;
typedef struct 
{
  	HI_U32 u32Channel;/*ipc: 0*/
	HI_P2P_S_MD_AREA struArea;
} HI_P2P_S_MD_PARAM;
/****************HI_P2P_GET_MD_PARAM  HI_P2P_SET_MD_PARAM*******************/


/****************HI_P2P_GET_IO_PARAM  HI_P2P_SET_IO_PARAM*************
IO报警开关***************************************************************/
typedef struct 
{
	HI_U32 u32Channel;/*ipc: 0*/
	HI_U32 u32Enable;
	HI_U32 u32Mode;
} HI_P2P_S_IO_PARAM;
/****************HI_P2P_GET_IO_PARAM  HI_P2P_SET_IO_PARAM*******************/


/****************HI_P2P_GET_AUDIO_ALM_PARAM  HI_P2P_SET_AUDIO_ALM_PARAM*************
声音报警参数***************************************************************/
typedef struct 
{
	HI_U32 u32Channel;/*ipc: 0*/
	HI_U32 u32Enable;
	HI_U32 u32Sensi;
	HI_U32 u32conti;
} HI_P2P_S_AUDIO_ALM_PARAM;
/****************HI_P2P_GET_AUDIO_ALM_PARAM  HI_P2P_SET_AUDIO_ALM_PARAM*******************/


/****************HI_P2P_GET_ALARM_PARAM  HI_P2P_SET_ALARM_PARAM*************
所有报警联动报警的参数***************************************************************/
typedef struct 
{
	HI_U32 u32Channel;/*ipc: 0*/
	HI_U32 u32EmailSnap;
	HI_U32 u32SDSnap;
	HI_U32 u32SDRec;
	HI_U32 u32FtpRec;
	HI_U32 u32FtpSnap;
	HI_U32 u32Relay;
	HI_U32 u32RelayTime;		/*5, 10, 20, 30*/
	HI_U32 u32PTZ;/*预置位 */
	HI_U32 u32Svr;/*联动push*/
} HI_P2P_S_ALARM_PARAM;
/****************HI_P2P_GET_ALARM_PARAM  HI_P2P_SET_ALARM_PARAM*******************/

/****************HI_P2P_GET_SNAP_AUTO_PARAM  HI_P2P_SET_SNAP_AUTO_PARAM*************
抓拍参数***************************************************************/
typedef struct 
{
	HI_U32 u32Channel;/*ipc: 0*/
	HI_U32 u32FtpSnap;/*ftp抓拍张数*/
	HI_U32 u32FtpInter;/*抓拍间隔 seconds*/
	HI_U32 u32SDSnap;
	HI_U32 u32SDInter;
} HI_P2P_S_SNAP_AUTO_PARAM;
/****************HI_P2P_GET_SNAP_AUTO_PARAM  HI_P2P_SET_SNAP_AUTO_PARAM*******************/

/****************HI_P2P_GET_REC_AUTO_PARAM  HI_P2P_SET_REC_AUTO_PARAM************************/
typedef struct 
{
	HI_U32 u32Channel;/*ipc: 0*/
	HI_U32 u32Enable;
	HI_U32 u32FileLen;/* 文件长度:<15-900>sec*/
	HI_U32 u32Stream;
} HI_P2P_S_REC_AUTO_PARAM;
/****************HI_P2P_GET_REC_AUTO_PARAM  HI_P2P_SET_REC_AUTO_PARAM*******************/

/******HI_P2P_GET_ALARM_SCHEDULE**HI_P2P_GET_SNAP_AUTO_SCHEDULE**HI_P2P_GET_REC_AUTO_SCHEDULE***/
#define HI_P2P_TYPE_ALARM 0  /*报警联动计划*/
#define HI_P2P_TYPE_PLAN  1  /*定时录像计划*/
#define HI_P2P_TYPE_SNAP  2 /*定时抓拍计划*/
typedef struct 
{
	HI_U32 u32QtType;			//HI_P2P_TYPE_ALARM, HI_P2P_TYPE_PLAN,HI_P2P_TYPE_SNAP
	HI_CHAR sDayData[7][48+1];	//P, N
}HI_P2P_QUANTUM_TIME;
/******HI_P2P_GET_ALARM_SCHEDULE**HI_P2P_GET_SNAP_AUTO_SCHEDULE**HI_P2P_GET_REC_AUTO_SCHEDULE***/

/**********HI_P2P_GET_FTP_PARAM  HI_P2P_SET_FTP_PARAM  HI_P2P_GET_FTP_PARAM_EXT*********/
typedef struct
{
	HI_U32 u32Channel;/*ipc: 0*/
	HI_CHAR strSvr[64];
	HI_U32  u32Port;
	HI_CHAR strUsernm[64];
	HI_CHAR strPasswd[64];
	HI_CHAR strFilePath[256];
} HI_P2P_S_FTP_PARAM;

typedef struct
{
	HI_U32 u32Channel;/*ipc: 0*/
	HI_CHAR strSvr[64];
	HI_U32  u32Port;
	HI_U32  u32Mode;
	HI_CHAR strUsernm[64];
	HI_CHAR strPasswd[64];
	HI_CHAR strFilePath[256];
	HI_U32 u32CreatePath;			/*自动创建目录, 1:创建, 0:不创建*/
	HI_U32 u32Check;				/*1:check, 0:no check*/
	HI_CHAR strReserved[8];		/*预留*/
} HI_P2P_S_FTP_PARAM_EXT;
/**********HI_P2P_GET_FTP_PARAM  HI_P2P_SET_FTP_PARAM  HI_P2P_GET_FTP_PARAM_EXT*********/


/*******HI_P2P_GET_EMAIL_PARAM  HI_P2P_SET_EMAIL_PARAM  HI_P2P_SET_EMAIL_PARAM_EXT*******/
typedef struct
{
	HI_U32 u32Channel;/*ipc: 0*/
	HI_CHAR strSvr[64];
	HI_U32  u32Port;
	HI_U32  u32Auth;
	HI_U32  u32LoginType;	/*1：开启验证   3：关闭验证*/
	HI_CHAR strUsernm[64];
	HI_CHAR strPasswd[64];
	HI_CHAR strFrom[64];
	HI_CHAR strTo[3][64];
	HI_CHAR strSubject[128];
	HI_CHAR strText[256];
} HI_P2P_S_EMAIL_PARAM;

typedef struct
{
	HI_U32 u32Channel;/*ipc: 0*/
	HI_CHAR strSvr[64];
	HI_U32  u32Port;
	HI_U32  u32Auth;
	HI_U32  u32LoginType;	/*1：开启验证   3：关闭验证*/
	HI_CHAR strUsernm[64];
	HI_CHAR strPasswd[64];
	HI_CHAR strFrom[64];
	HI_CHAR strTo[3][64];
	HI_CHAR strSubject[128];
	HI_CHAR strText[256];
	HI_U32  u32Check;				/*1:check,  0:no check*/
	HI_CHAR strReserved[8];		/*预留*/
} HI_P2P_S_EMAIL_PARAM_EXT;

/*******HI_P2P_GET_EMAIL_PARAM  HI_P2P_SET_EMAIL_PARAM  HI_P2P_SET_EMAIL_PARAM_EXT*******/

/****************HI_P2P_GET_NTP_PARAM  HI_P2P_SET_NTP_PARAM*************/
typedef struct
{
	HI_U32 u32Channel;/*ipc: 0*/
	HI_U32 u32Enable;
	HI_U32 u32Interval;
	HI_CHAR strSvr[64];
} HI_P2P_S_NTP_PARAM;
/****************HI_P2P_GET_NTP_PARAM  HI_P2P_SET_NTP_PARAM*************/

/****************HI_P2P_SET_TIME_ZONE  HI_P2P_GET_TIME_ZONE*************/
typedef struct
{
	HI_U32 u32Channel;/*ipc: 0*/
	HI_S32 s32TimeZone;
	HI_U32 u32DstMode;
}HI_P2P_S_TIME_ZONE;
/****************HI_P2P_SET_TIME_ZONE  HI_P2P_GET_TIME_ZONE*************/

/****************HI_P2P_GET_TIME_PARAM  HI_P2P_SET_TIME_PARAM*************/
typedef struct
{
	HI_U32  u32Year;
	HI_U32  u32Month;
	HI_U32  u32Day;
	HI_U32  u32Hour;
	HI_U32  u32Minute;
	HI_U32  u32Second;
} HI_P2P_S_TIME_PARAM;
/****************HI_P2P_GET_TIME_PARAM  HI_P2P_SET_TIME_PARAM*************/

/****************HI_P2P_GET_DEV_INFO*************/
#define HI_P2P_NET_TYPE_CABLE 0
#define HI_P2P_NET_TYPE_WIFI  1
typedef struct
{	
	HI_CHAR strCableMAC[32];
	HI_CHAR strWifiMAC[32];
	HI_U32  u32NetType;
	HI_CHAR strSoftVer[32];
	HI_CHAR strHardVer[32];
	
	HI_CHAR strDeviceName[32];		/*设备名称*/
	HI_S32  sUserNum;				/*用户连接数*/
} HI_P2P_S_DEV_INFO;
/****************HI_P2P_GET_DEV_INFO*************/

/**************************HI_P2P_GET_DEV_INFO_EXT************************/
typedef struct
{
	HI_U32 u32Channel;
	HI_CHAR strCableMAC[32];
	HI_CHAR strWifiMAC[32];
	HI_U32  u32NetType;
    HI_CHAR aszSystemSoftVersion[HI_P2P_MAX_VERLENGTH];
	HI_CHAR strHardVer[32];
   	HI_CHAR aszSystemName[HI_P2P_MAX_STRINGLENGTH];		/*设备名称*/
	HI_S32  sUserNum;									/*用户连接数*/
	
    HI_CHAR aszSystemModel[HI_P2P_MAX_STRINGLENGTH];
   	HI_CHAR aszStartDate[HI_P2P_MAX_STRINGLENGTH];
   	HI_S32  s32SDStatus;
   	HI_S32  s32SDFreeSpace;
   	HI_S32  s32SDTotalSpace;
   	HI_CHAR aszWebVersion[HI_P2P_MAX_VERLENGTH];
	HI_CHAR sReserved[8];								/*预留*/
}HI_P2P_S_DEV_INFO_EXT;
/**************************HI_P2P_GET_DEV_INFO_EXT************************/


/****************HI_P2P_GET_SD_INFO*************/
#define HI_P2P_SD_IS_NONE 	0
#define HI_P2P_SD_IS_OK 	1
typedef struct
{	
	HI_U32 u32Channel;/*ipc: 0*/
	HI_U32 u32Status;
	HI_U32 u32Space;
	HI_U32 u32LeftSpace;
} HI_P2P_S_SD_INFO;
/****************HI_P2P_GET_SD_INFO*************/

/****************HI_P2P_GET_VENDOR_INFO*****HI_P2P_GET_CAPACITY********/
typedef struct
{	
	HI_CHAR strVendor[32];
	HI_CHAR strProduct[32];
} HI_P2P_S_VENDOR;

typedef struct
{	
    HI_U32 u32Channel;/*ipc: 0*/
	HI_U32 u32MaxStream;
	HI_U32 u32MaxWidth;
	HI_U32 u32MaxHeight;
} HI_P2P_S_CAPACITY;

/****************HI_P2P_GET_VENDOR_INFO*****HI_P2P_GET_CAPACITY********/

/****************HI_P2P_SET_PTZ_CTRL*************/
#define HI_P2P_PTZ_CTRL_STOP		0
#define HI_P2P_PTZ_CTRL_LEFT  		1
#define HI_P2P_PTZ_CTRL_RIGHT 		2
#define HI_P2P_PTZ_CTRL_UP    		3
#define HI_P2P_PTZ_CTRL_DOWN	 	4
#define HI_P2P_PTZ_CTRL_LEFT_UP		5
#define HI_P2P_PTZ_CTRL_LEFT_DOWN	6
#define HI_P2P_PTZ_CTRL_RIGHT_UP	7
#define HI_P2P_PTZ_CTRL_RIGHT_DOWN	8
#define HI_P2P_PTZ_CTRL_ZOOMIN		9
#define HI_P2P_PTZ_CTRL_ZOOMOUT		10
#define HI_P2P_PTZ_CTRL_FOCUSIN		11
#define HI_P2P_PTZ_CTRL_FOCUSOUT	12
#define HI_P2P_PTZ_CTRL_ARIN		13
#define HI_P2P_PTZ_CTRL_AROUT		14

#define HI_P2P_PTZ_CTRL_HOME		20
#define HI_P2P_PTZ_CTRL_CRUISE_PAN	21
#define HI_P2P_PTZ_CTRL_CRUISE_TITL	22

#define HI_P2P_PTZ_MODE_RUN		0
#define HI_P2P_PTZ_MODE_STEP	1
typedef struct
{	
	HI_U32 u32Channel;/*ipc: 0*/
	HI_U32 u32Ctrl;/*云台控制命令*/
	HI_U32 u32Mode;/*控制模式: 单步 or  自动*/
	HI_U16 u16Speed;	/*速度*/
	HI_U16 u16TurnTime;	/*0: 无,  1-100: 转动持续时间*/
} HI_P2P_S_PTZ_CTRL;

/****************HI_P2P_SET_PTZ_CTRL*************/

/****************HI_P2P_S_PTZ_CTRL_EXT************/
typedef struct
{	
	HI_U32 u32Channel;/*ipc: 0*/
	HI_U32 u32Ctrl;/*云台控制命令*/
	HI_CHAR strReserve[8];
} HI_P2P_S_PTZ_CTRL_EXT_RESP;
/****************HI_P2P_S_PTZ_CTRL_EXT************/

/****************HI_P2P_GET_PTZ_PRESET*************/
#define HI_P2P_PTZ_PRESET_NUM_MAX 16
#define HI_P2P_PTZ_PRESET_ACT_CALL	23
#define HI_P2P_PTZ_PRESET_ACT_SET	24
#define HI_P2P_PTZ_PRESET_ACT_DEL	25
typedef struct
{	
	HI_U32 u32Channel;/*ipc: 0*/
	HI_U32 u32Action;
	HI_U32 u32Number;
} HI_P2P_S_PTZ_PRESET;
/****************HI_P2P_GET_PTZ_PRESET*************/

/************HI_P2P_SET_PTZ_PRESET_EXT*************/
typedef struct
{	
	HI_U32 u32Channel;/*ipc: 0*/
	HI_U32 u32Action;
	HI_CHAR strReserve[8];
} HI_P2P_S_PTZ_PRESET_EXT_RESP;
/************HI_P2P_SET_PTZ_PRESET_EXT*************/



typedef struct
{	
	HI_U32 u32Channel;/*ipc: 0*/
	HI_U32 u32State[HI_P2P_PTZ_PRESET_NUM_MAX];
}HI_P2P_S_PTZ_PRESET_LIST;

/****************HI_P2P_GET_PTZ_PARAM****HI_P2P_SET_PTZ_PARAM*********/
typedef struct
{	
	HI_U32 u32Channel;/*ipc: 0*/
	HI_U8 sPanSpeed;/*水平速度0~2*/
	HI_U8 sTiltSpeed;/*垂直速度0~2*/
	HI_U8 sPanScan;/*水平巡航圈数 1~50*/
	HI_U8 sTiltScan;/*垂直巡航圈数 1~50*/
	HI_U8 sMoveHome;/*1  自检中心位置 0:自检到预置位1*/
	HI_U8 sPtzAlarmMask;/*1 云台运动时关闭报警*/
	HI_U8 sAlarmPresetIndex;/*报警联动预置位，1-8*/
	HI_CHAR strReserve[8];
} HI_P2P_S_PTZ_PARAM;
/****************HI_P2P_GET_PTZ_PARAM****HI_P2P_SET_PTZ_PARAM*********/


/****************HI_P2P_SET_INFRARED************红外灯控制*/
#define HI_P2P_INFRARED_AUTO	       0    /* 自动开启 */
#define HI_P2P_INFRARED_ON		1   /* 强制开启 */
#define HI_P2P_INFRARED_OFF		2   /* 强制关闭*/
typedef struct
{
	HI_U32 u32Channel;/*ipc: 0*/
	HI_U32 u32State;
} HI_P2P_S_INFRARED;
/****************HI_P2P_SET_INFRARED*************/

/****************HI_P2P_SET_RELAY************继电器控制*/
typedef struct
{	
	HI_U32 u32Channel;/*ipc: 0*/
	HI_U32 u32State;
} HI_P2P_S_RELAY;
/****************HI_P2P_SET_RELAY*************/

/****************HI_P2P_GET_SNAP************图像预览*/
typedef struct
{	
    HI_U32 u32Channel;/*ipc: 0*/
	HI_U32 u32Stream;
} HI_P2P_S_SNAP_REQ;

typedef struct
{	
	HI_U32 u32SnapLen;/*照片总大小*/
	HI_U32 u32SendLen;/*每次发送的大小,每次发送最大size=1024-24-10=990*/
	HI_U16 u16Flag;	/*0: 开始标志,1:结束标志*/
	HI_CHAR pSnapBuf[0];
} HI_P2P_S_SNAP_RESP;
/****************HI_P2P_GET_SNAP*************/



/*************HI_P2P_PB_QUERY**********HI_P2P_PB_PLAY_CONTROL*************
 查询一个月有录像的天数、录像文件的查询、录像回放*/
#define HI_P2P_DEV_VIDEO_FRAME_FLAG  0x46565848		/* 视频帧标志 */
#define HI_P2P_DEV_AUDIO_FRAME_FLAG  0x46415848  	/* 音频帧标志 */
#define HI_P2P_DEV_PLAYBACK_END_FLAG 0x46000000  	/*回放结束标志*/
#define HI_P2P_DEV_UPLOAD_END_FLAG   0x46000001  	/*上传结束标志*/
#define HI_P2P_DEV_PLAYBACK_POS_FLAG 0x46000002  	/*录像回放拖动标志*/

typedef struct
{
	HI_U32 u32Year;
	HI_U32 u32Month;
}HI_P2P_PB_QUERY_MONTH_REQ;

typedef struct
{
	HI_CHAR sDay[32];	/* 1: 有录像,  0: 没有录像 */
}HI_P2P_PB_QUERY_MONTH_RESP;

typedef struct
{
	HI_U16 year;
	HI_U8  month;
	HI_U8  day;
	HI_U8  hour;
	HI_U8  minute;
	HI_U8 second;
	HI_U8  wday;		// Sunday = 0, Monday = 1, .....
}STimeDay;

typedef enum
{
	 EVENT_ALL=0,
	 EVENT_MANUAL=1,
	 EVENT_ALARM=2,
	 EVEN_PLAN=3
}HI_P2P_ENUM_EVENT;

typedef struct 
{
	HI_U32 u32Chn;/*ipc :0*/
	STimeDay sStartTime; /*2014-12-25-15-54-36*/
	STimeDay sEndtime; /*2014-12-26-15-54-36*/
	HI_CHAR  EventType;/*HI_P2P_ENUM_EVENT*/
	HI_CHAR  sReserved[3];
}HI_P2P_S_PB_LIST_REQ;

typedef struct
{
	STimeDay sStartTime; /*每个录像文件的开始时间*/
	STimeDay sEndTime; /*每个录像文件的开始时间*/
	HI_U32 	  u32size;	/*文件大小单位:M bytes*/
	HI_CHAR  EventType;/*HI_P2P_ENUM_EVENT*/
	HI_CHAR sReserved[3];
}HI_P2P_FILE_INFO;

#define HI_P2P_PB_MAX_FILE_NUM  40   /*每一包数据最大包含60个文件信息*/
typedef struct
{
	HI_U32  total;		// Total event amount in this search session
	HI_U32  index;		// package index, 0,1,2...; 
	HI_U8 endflag;		// end flag; endFlag = 1 means this package is the last one.
	HI_U8 count;		// how much events in this package
	HI_U8 sReserved[2];
	HI_P2P_FILE_INFO sFileInfo[0];		// The first memory address of the events in this package
}HI_P2P_S_PB_LIST_RESP;

typedef struct 						/*录像回放文件信息*/
{
    HI_U32 u32VideoWidth;
    HI_U32 u32VideoHeight;
    HI_U32 u32AudioType;
	HI_U32 u32Command;
} HI_P2P_S_PB_FILE_INFO;

typedef enum
{
	HI_P2P_PB_PLAY=1,
	HI_P2P_PB_STOP=2,
	HI_P2P_PB_PAUSE=3,
	HI_P2P_PB_SETPOS=4,		//2015.12.23起停止使用
	HI_P2P_PB_GETPOS=5,		//2015.12.23起停止使用
}HI_P2P_ENUM_PLAY_CON;

typedef struct
{
	HI_U32 u32Chn;/*ipc :0*/
	HI_U16 command;/*HI_P2P_ENUM_PLAY_CON*/
	STimeDay sStartTime; /*播放录像的开始时间*/
	HI_U8 sReserved[2];
}HI_P2P_S_PB_PLAY_REQ;
/************HI_P2P_PB_QUERY ***********HI_P2P_PB_PLAY_CONTROL**************/



/***************************HI_P2P_ALARM_EVENT****************************/
typedef enum 
{
	MOTION_ALARM=0,
	IO_ALARM	=1,
	AUDIO_ALARM=2,
	UART_ALARM=3
}HI_P2P_ALARM_TYPE;

/*10s*/
typedef struct
{
	HI_U32 u32Channel;
	HI_U32 u32Time; 	// UTC Time
	HI_U32 u32Event; 	// Event Type
	HI_CHAR sReserved[32];
} HI_P2P_EVENT;
/***************************HI_P2P_ALARM_EVENT****************************/

/***********************HI_P2P_GET_SUBSCRIBE_TOKEN************************/
typedef struct
{
	HI_U32 u32Channel;
	HI_CHAR sSubscribeToken[256];
	HI_CHAR sReserved[32];
} HI_P2P_SUBSCRIBE_TOKEN;
/***********************HI_P2P_GET_SUBSCRIBE_TOKEN************************/


/***************************HI_P2P_GET_FUNCTION***************************/
typedef struct
{
	HI_U8 s32Function[32];
}HI_P2P_FUNCTION;
/***************************HI_P2P_GET_FUNCTION***************************/



/**************************HI_P2P_GET_RTSP_PARAM**************************/
typedef struct
{
	HI_U32 u32Channel;
	HI_U32 u32RtspPort;
	HI_U32 u32AuthFlag;
	HI_CHAR sReserved[8];
} HI_P2P_RTSPINFO;
/**************************HI_P2P_GET_RTSP_PARAM**************************/

/**************************HI_P2P_GET_COVER_PARAM**************************/
#define HI_P2P_DEV_COVER_AREA_MAX  4
#define HI_P2P_DEV_COVER_AREA_1    1
#define HI_P2P_DEV_COVER_AREA_2    2
#define HI_P2P_DEV_COVER_AREA_3    3
#define HI_P2P_DEV_COVER_AREA_4    4
typedef struct
{
	HI_U32 u32Channel;
	HI_U32 u32Area;            /* 遮挡区域 */
	HI_BOOL bShow;
	HI_U32 u32X;
	HI_U32 u32Y;
	HI_U32 u32Width;
	HI_U32 u32Height;
	HI_U32 u32Color;
	HI_CHAR sReserved[8];	/*预留*/
} HI_P2P_COVER_PARAM;
/**************************HI_P2P_GET_COVER_PARAM**************************/

/**************************HI_P2P_GET_CODING*******************************/
typedef struct
{
	HI_U32 u32Channel;
	HI_U32 u32Frequency; 	/*50Hz、60Hz*/
	HI_U32 u32Profile;		/*0: baseline 1: mainprofile*/
	HI_CHAR sReserved[8];	/*预留*/
} HI_P2P_CODING_PARAM;
/**************************HI_P2P_GET_CODING*******************************/

/**************************HI_P2P_GET_SNAP_ALARM_PARAM*********************/
typedef struct
{
	HI_U32 u32Channel;
	HI_U32 u32Enable;	//(0, 1)
	HI_U32 u32Chn;		//(主码流:11, 次码流:12, 第三码流:13), 默认11
	HI_U32 u32Number;	//(1, 2, 3)
	HI_U32 u32Interval;	//(>=5)
	HI_CHAR sReserved[8];	/*预留*/
}HI_P2P_SNAP_ALARM;
/**************************HI_P2P_GET_SNAP_ALARM_PARAM*********************/

/**************************HI_P2P_GET_SP_IMAGE_PARAM**************************/
typedef struct
{
	HI_U32 u32Channel;
	HI_U32 u32LdcRatio;		/*畸变值0-511*/
	HI_U32 u32Sharpness;	/*锐度*/
	HI_U32 u32Targety;		/*曝光度*/
	HI_U32 u32Gamma;		
	HI_U32 u32Shutter;		/*快门*/
	HI_U32 u32AeMode;		/*曝光模式:0代表自动，1代表室内，2代表室外*/
	HI_U32 u32DisplayMode;	/*0 代表黑白模式，1代表彩色模式*/
	HI_U32 u32ImgMode;		/*图像优先模式0代表帧率优先，1代表照度优先*/
	HI_U32 u32Wdr;			/*宽动态开关*/
	HI_U32 u32Noise;			/*平滑模式*/
	HI_U32 sReserve[4];
} HI_P2P_SP_IMAGE;
/**************************HI_P2P_GET_SP_IMAGE_PARAM*************************/


/**************************HI_P2P_GET_ONVIF_PARAM**************************/
typedef struct
{
	HI_U32 u32Channel;
	HI_U32 u32Enable;	/*1:开, 0:关*/
	HI_U32 u32Port;
	HI_U32 u32authflag;	/*权限, 1:开, 0:关*/
	HI_U32 u32Forbitset;/*0:时间允、图像允, 1:时间禁、图像允, 2:时间允、图像禁, 3:时间禁、图像禁*/					
	HI_U32 u32SubChn;	/*自码流通道, 第二码流:12, 第三码流:13*/
	HI_U32 sReserve[4];
}HI_P2P_ONVIF_ALARM;
/**************************HI_P2P_GET_ONVIF_PARAM*************************/

/**************************HI_P2P_GET_SYSTEM_LOG**************************/
typedef struct
{
	HI_U32 u32Channel;
	HI_U32 u32SendLen;	/*每次发送的大小,每次发送最大size=1024-24-10=990*/
	HI_U32 u32Flag;		/*0: 开始标志,1:结束标志*/
	HI_CHAR pLogBuf[0];
}HI_P2P_SYS_LOG;
/**************************HI_P2P_GET_SYSTEM_LOG*************************/

/**************************HI_P2P_GET_PTZ_COM_PARAM**********************/
typedef struct
{
	HI_U32 u32Channel;
	HI_U32 u32Protocol;     /* 云台协议  */
	HI_U32 u32Address;     /* 地址码1-255 */ 
	HI_U32 u32Speed;		/*速度*/
	HI_U32 u32Baud;          /* 波特率*/
	HI_U32 u32DataBit;      /* 地址位*/     
	HI_U32 u32StopBit;      /* 停止位*/
	HI_U32 u32Parity;       /* 校验位*/
	HI_CHAR sReserved[8];	/*预留*/
}HI_P2P_PTZ_COM;
/**************************HI_P2P_GET_PTZ_COM_PARAM**********************/

/**************************HI_P2P_GET_LIGNT_CTRL************************/
typedef struct
{
	HI_U32 u32Channel;
	HI_U32 u32LightEnable;			/*0: 关 1:开*/
	HI_CHAR sReserved[8];			/*预留*/
}HI_P2P_LIGNT_CTRL;
/**************************HI_P2P_GET_LIGNT_CTRL************************/

/**************************HI_P2P_GET_RESOLUTION**************************/
/* 图像清晰度 */
#define HI_P2P_RESOLUTION_VGA		0
#define HI_P2P_RESOLUTION_QVGA		1
#define HI_P2P_RESOLUTION_QQVGA 	2
#define HI_P2P_RESOLUTION_D1		3
#define HI_P2P_RESOLUTION_CIF		4
#define HI_P2P_RESOLUTION_QCIF		5
#define HI_P2P_RESOLUTION_720P		6
#define HI_P2P_RESOLUTION_Q720		7
#define HI_P2P_RESOLUTION_QQ720		8
#define HI_P2P_RESOLUTION_UXGA		9
#define HI_P2P_RESOLUTION_960H		10
#define HI_P2P_RESOLUTION_Q960H		11
#define HI_P2P_RESOLUTION_QQ960H	12
#define HI_P2P_RESOLUTION_1080P		13
#define HI_P2P_RESOLUTION_960P		14
typedef struct
{
	HI_U32 u32Channel;      	/* 通道 */
	HI_U32 u32Stream;
	HI_U32 u32Resolution;		/* 图像清晰度 */
	HI_CHAR sReserved[8];		/*预留*/
} HI_P2P_RESOLUTION;
/**************************HI_P2P_GET_RESOLUTION**************************/

/**************************HI_P2P_SET_DOWNLOAD**************************/
#define HI_DOWN_PATH_LEN 128
typedef struct
{
	HI_U32 u32Channel;/*ipc: 0*/
	HI_CHAR sFileName[HI_DOWN_PATH_LEN]; /*APP 从服务器获取的最新升级文件地址（名）*/
}HI_P2P_S_SET_DOWNLOAD;
/**************************HI_P2P_SET_DOWNLOAD**************************/


	
/***********************HI_P2P_START_REC_UPLOAD 已废除(请使用EXT命令)**********************/
typedef struct
{
	HI_U32 u32Chn;				/*ipc :0*/
	STimeDay sStartTime; 		/*录像文件的开始时间*/
	HI_CHAR  sReserved[4];
}HI_P2P_START_REC_UPLOAD_REQ;

typedef struct
{
	HI_U32 u32FileSize; 		/* 大小，单位字节 */
	HI_U16 u16VideoWidth;		/* 宽 */
	HI_U16 u16VideoHeight;		/* 长 */
	HI_U8 u8AudioType; 			/* 音频类型 */
	HI_U8 u8Sample; 			/* 音频采样率  采样率 = 8000（8K） ，此处采样率请填8 ； 采样率  48000（48K） 此处填48； 以此类推*/
	HI_U8 u8Bit; 				/* 音频 8bit=1、 16bit=2、 24bit=3、32bit=4 */
	HI_U8 u8Channel; 			/* 音频 单声道1、双声道2 */
	HI_CHAR  sReserved[4];
}HI_P2P_START_REC_UPLOAD_RESP;
/***********************HI_P2P_START_REC_UPLOAD 已废除(请使用EXT命令)**********************/

/*********************HI_P2P_START_REC_UPLOAD_EXT********************/
typedef enum
{
	P2P_PC_NET_LAN  =0,		/*MAX 8Mb/s*/
	P2P_PC_NET_WAN = 1,
	P2P_PHONE_NET_WIFI = 2,
	P2P_PHONE_NET_3G = 3,
	P2P_PHONE_NET_4G =4,
	P2P_PHONE_NET_2G =5,
}HI_P2P_UPLOAD_LEVEL;
typedef struct
{
	HI_U32 u32Chn;/*ipc :0*/
	STimeDay sStartTime; /*录像文件的开始时间*/
	HI_P2P_UPLOAD_LEVEL eFlag; /* HI_P2P_DOWNLOAD_LEVEL */
	HI_CHAR  sReserved[4];
}HI_P2P_START_REC_UPLOAD_REQ_EXT;

typedef struct
{
	HI_U32 u32FileSize; 		/* 大小，单位字节 */
	HI_U16 u16VideoWidth;		/* 宽 */
	HI_U16 u16VideoHeight;		/* 长 */
	HI_U8 u8AudioType; 			/* 音频类型 */
	HI_U8 u8Sample; 			/* 音频采样率  采样率 = 8000（8K） ，此处采样率请填8 ； 采样率  48000（48K） 此处填48； 以此类推*/
	HI_U8 u8Bit; 				/* 音频 8bit=1、 16bit=2、 24bit=3、32bit=4 */
	HI_U8 u8Channel; 			/* 音频 单声道1、双声道2 */
	HI_U8 u8FileType;			/* 0: ".264",   1: ".avi"*/
	HI_CHAR  sReserved[3];
}HI_P2P_START_REC_UPLOAD_RESP_EXT;

/*****上传录像文件 数据格式*****/
typedef struct
{
	HI_U32 u32Flag; /*0x88888888*/
	HI_U32 u32Size; /*Bytes 设备端每一次发送的字节数*/
	HI_CHAR sFileFlag;/* s: 开始包1: 中间包 2:结束包*/
	HI_CHAR  sReserved[3];
}HI_P2P_REC_FILE_STREAM_HEAD;
typedef struct
{
	HI_P2P_REC_FILE_STREAM_HEAD sHead;
	HI_CHAR sData[0]; /*1024 ~128*1024  Bytes,每次发送的大小根据网络带宽调整*/
}HI_P2P_REC_UPLOAD_DATA;
/*****上传录像文件 数据格式*****/
/*********************HI_P2P_START_REC_UPLOAD_EXT********************/

/***********************HI_P2P_STOP_REC_UPLOAD***********************/
typedef struct
{
	HI_U32 u32Chn;/*ipc :0*/
	HI_CHAR  sReserved[4];
}HI_P2P_STOP_REC_UPLOAD_REQ;
/***********************HI_P2P_STOP_REC_UPLOAD***********************/

/**************************HI_P2P_PB_POS_SET**************************/
typedef struct
{
	HI_U32 u32Chn;		/*ipc :0*/
	HI_S32 s32Pos;		/*录像文件百分比*/
	STimeDay sStartTime; /*播放录像的开始时间*/
	HI_S8 sReserved[4];
}HI_P2P_PB_SETPOS_REQ;
/**************************HI_P2P_PB_POS_SET**************************/

/**************************HI_P2P_WHITE_LIGHT_GET**************************/
typedef struct
{
	HI_U32 u32Chn;			/*ipc :0*/
	HI_U32 u32State;		/*0: 关,  1: 开*/
	HI_S8 sReserved[4];
}HI_P2P_WHITE_LIGHT_INFO;
/**************************HI_P2P_WHITE_LIGHT_GET**************************/

/**************************HI_P2P_INPUT_ALARM_GET**************************/
typedef struct
{
	HI_U32 u32Chn;			/*ipc :0*/
	HI_U32 u32Enable;		/*输入报警使能: 0: 关,  1: 开*/
	HI_U32 u32State;		/*输入报警状态: 0: 常闭,  1: 常开*/
	HI_S8 sReserved[4];
}HI_P2P_INPUT_ALARM_INFO;
/**************************HI_P2P_INPUT_ALARM_GET**************************/

/**************************HI_P2P_WHITE_LIGHT_GET_EXT**************************/
typedef struct
{
	HI_U32 u32Chn;			/*ipc :0*/
	HI_U32 u32State;		/*0普通,1彩色,2智能*/
	HI_S8 sReserved[4];
}HI_P2P_WHITE_LIGHT_INFO_EXT;
/**************************HI_P2P_WHITE_LIGHT_GET_EXT**************************/

/**************************HI_P2P_ALARM_REC_LEN_GET***************************/
typedef struct
{
	HI_U32 u32Chn;			/*ipc :0*/
	HI_U8 u8FileLen;		/*报警录像时长<15-90>sec*/
	HI_S8 sReserved[3];
}HI_P2P_ALARM_REC_LEN_INFO;
/**************************HI_P2P_ALARM_REC_LEN_GET***************************/

/**************************HI_P2P_PRESET_STATUS_GET***************************/
typedef struct
{
	HI_U32 u32Chn;				/*ipc :0*/
	HI_U32 u32PresetNum;		/*获取预置位的个数(1-16个)*/
	HI_CHAR szPresetStatus[16];	/*0-15个报警预置位状态: 0未设置,  1已设置*/
	HI_S8 sReserved[4];
}HI_P2P_PRESET_STATUS_INFO;/*获取时也需要下发该数据结构*/
/**************************HI_P2P_PRESET_STATUS_GET***************************/

/**************************HI_P2P_ALARM_TOKEN_REGIST***************************/
#define HI_P2P_ALARM_TOKEN_MAX	64	/*仅限设备端使用，最大token个数*/
typedef struct
{
	HI_U32 u32Chn;				/*ipc :0*/
	HI_U32 u32TokenId;			/*token*/
	HI_U32 u32UtcTime;			/*客户端当前utc时间(单位小时,即 /3600 )*/
	HI_S8 sReserved[4];
}HI_P2P_ALARM_TOKEN_INFO;
/**************************HI_P2P_ALARM_TOKEN_UNREGIST***************************/

/**************************HI_P2P_TEMP_HUMIDITY_CTRL***************************/
typedef struct
{
	HI_U32 u32Chn;				/*ipc :0*/
	HI_U32 u32Enable;			/*1: open, 0: close*/
	HI_S8 sReserved[4];
}HI_P2P_TEMP_HUMIDITY_REQ;
/**************************HI_P2P_TEMP_HUMIDITY_CTRL***************************/

/**************************HI_P2P_TEMP_HUMIDITY_GET***************************/
typedef struct
{
	HI_U32 u32Chn;					/*ipc :0*/
	HI_FLOAT f32Temperature;
	HI_FLOAT f32Humidity;
	HI_S8 sReserved[4];
}HI_P2P_TEMP_HUMIDITY_INFO;
/**************************HI_P2P_TEMP_HUMIDITY_GET***************************/

/**************************HI_P2P_PIO_SET***************************/
typedef struct
{
	HI_U32 u32Chn;				/*ipc :0*/
	HI_U32 u32Mode;	 			/*播放模式,0-全关,1-全开,2-单灯循环,3-执行时长*/
	HI_U32 u32Timeout;			/*超时时间(单位s),模式为1跟2时默认发300秒,模式3时发900或0(长期有效)*/
	HI_S8 sReserved[4];
}HI_P2P_PIO_INFO;
/**************************HI_P2P_PIO_SET***************************/

/**************************HI_P2P_MP3_LIST_GET***************************/
typedef struct
{
	HI_U32 u32Chn;				/*ipc :0*/
	HI_CHAR sMP3Name[10][97];
	HI_S8 sReserved[4];
}HI_P2P_MP3_LIST_INFO;
/**************************HI_P2P_MP3_LIST_GET***************************/

/**************************HI_P2P_MP3_PLAY***************************/
typedef struct
{
	HI_U32 u32Chn;				/*ipc :0*/
	HI_U32 u32Mode;	 			/*播放模式,0-停止,1-前一首,2-下一首,3-播放制定序号*/
	HI_U32 u32FileIndex;		/*文件序号,范围1-10,只在模式3下有效*/
	HI_S8 sReserved[4];
}HI_P2P_MP3_PLAY_INFO;
/**************************HI_P2P_MP3_PLAY***************************/

/**************************HI_P2P_GET_ALARM_LOG**************************/
#define HI_P2P_ALARM_LOG_MAX_NUM	120
typedef struct
{
	HI_U32 u32TimeUTC;
	HI_U32 u32Type;
} HI_P2P_ALARMLOG;
typedef struct
{
	HI_U32 u32LogNum;
	HI_P2P_ALARMLOG sAlarmLog[HI_P2P_ALARM_LOG_MAX_NUM];
	HI_S8 sReserved[4];
} HI_P2P_ALARM_LOG_INFO;
/**************************HI_P2P_GET_ALARM_LOG**************************/


/**************************HI_P2P_TIO_SET**************************/
typedef struct 
{
	HI_U32 u32Mode;	 	/* 亮灯模式,0-关闭,1-红色,2-粉红,3-蓝色,4-黄色,5-绿色,6-浅蓝,7-白色,8单灯循环,9-执行时长*/
	HI_U32 u32Timeout;	/*超时时间,只在开灯模式下(1-8)下有效,当timeout为0时,为长期有效, 模式为1-8时默认发300秒,模式9时发0(一直执行)或900(15分钟)*/
}HI_P2P_TIO_INFO;
/**************************HI_P2P_TIO_SET**************************/



#define HI_P2P_LOGIN					0x00001000 /*所有命令的访问必须先login成功*/

#define HI_P2P_START_LIVE				0x00001001
#define HI_P2P_STOP_LIVE				0x00001002

#define HI_P2P_START_TALK				0x00001011
#define HI_P2P_STOP_TALK				0x00001012

#define HI_P2P_PB_QUERY_START			0x00002001
#define HI_P2P_PB_PLAY_CONTROL			0x00002003

#define HI_P2P_GET_VIDEO_PARAM			0x00003101
#define HI_P2P_SET_VIDEO_PARAM			0x00003102
#define HI_P2P_AUDIO_START				0x00003103
#define HI_P2P_AUDIO_STOP				0x00003104
#define HI_P2P_GET_DISPLAY_PARAM		0x00003105
#define HI_P2P_SET_DISPLAY_PARAM		0x00003106

#define HI_P2P_GET_NET_PARAM			0x00004101

#define HI_P2P_GET_WIFI_PARAM			0x00004103
#define HI_P2P_SET_WIFI_PARAM			0x00004104
#define HI_P2P_GET_WIFI_LIST			0x00004105

#define HI_P2P_GET_ALARM_PARAM			0x00005107
#define HI_P2P_SET_ALARM_PARAM			0x00005108

#define HI_P2P_GET_MD_PARAM				0x00005101
#define HI_P2P_SET_MD_PARAM				0x00005102

#define HI_P2P_GET_SNAP_AUTO_PARAM		0x00006101
#define HI_P2P_SET_SNAP_AUTO_PARAM		0x00006102

#define HI_P2P_SET_USER_PARAM			0x00007106	/*只能设置密码，设置用户名请使用HI_P2P_SET_USERNAME*/
#define HI_P2P_GET_TIME_PARAM			0x00007107
#define HI_P2P_SET_TIME_PARAM			0x00007108
#define HI_P2P_GET_DEV_INFO				0x00007111
#define HI_P2P_GET_SD_INFO				0x00007112
#define HI_P2P_SET_FORMAT_SD			0x00007113
#define HI_P2P_SET_TIME_ZONE			0x00007116
#define HI_P2P_GET_TIME_ZONE			0x00007117

#define HI_P2P_SET_PTZ_CTRL				0x00008101

#define HI_P2P_SET_REBOOT				0x00009101
#define HI_P2P_GET_SNAP					0x00009105

/********************新增2015.02.11********************/
#define HI_P2P_GET_STREAM_CTRL			0x0000f001		/*判断是否支持流控*/
#define HI_P2P_SET_STREAM_CTRL			0x0000f002

/********************新增2015.04.28********************/
#define HI_P2P_GET_FUNCTION				0x0000f005		/*能力集*/

#define HI_P2P_GET_FREQ_PARAM			0x00003107
#define HI_P2P_SET_FREQ_PARAM			0x00003108
#define HI_P2P_DEF_DISPLAY_PARAM		0x00003207

#define HI_P2P_GET_USER_PARAM			0x00007105




#define HI_P2P_PB_QUERY_MONTH			0x00002000		/*查询一个月有录像的天数*/
#define HI_P2P_PB_QUERY_STOP			0x00002002

#define HI_P2P_GET_OSD_PARAM			0x00003109
#define HI_P2P_SET_OSD_PARAM			0x00003110
#define HI_P2P_GET_AUDIO_ATTR			0x00003111
#define HI_P2P_SET_AUDIO_ATTR			0x00003112

#define HI_P2P_SET_NET_PARAM			0x00004102

#define HI_P2P_GET_IO_PARAM				0x00005103
#define HI_P2P_SET_IO_PARAM				0x00005104
#define HI_P2P_GET_AUDIO_ALM_PARAM		0x00005105
#define HI_P2P_SET_AUDIO_ALM_PARAM		0x00005106
#define HI_P2P_GET_ALARM_SCHEDULE		0x00005109
#define HI_P2P_SET_ALARM_SCHEDULE		0x00005110

#define HI_P2P_GET_SNAP_AUTO_SCHEDULE	0x00006103
#define HI_P2P_SET_SNAP_AUTO_SCHEDULE	0x00006104
#define HI_P2P_GET_REC_AUTO_PARAM		0x00006105
#define HI_P2P_SET_REC_AUTO_PARAM		0x00006106
#define HI_P2P_GET_REC_AUTO_SCHEDULE	0x00006107
#define HI_P2P_SET_REC_AUTO_SCHEDULE	0x00006108

#define HI_P2P_GET_FTP_PARAM			0x00007101
#define HI_P2P_SET_FTP_PARAM			0x00007102
#define HI_P2P_GET_EMAIL_PARAM			0x00007103
#define HI_P2P_SET_EMAIL_PARAM			0x00007104
#define HI_P2P_GET_NTP_PARAM			0x00007109
#define HI_P2P_SET_NTP_PARAM			0x00007110
#define HI_P2P_GET_VENDOR_INFO			0x00007114

#define HI_P2P_SET_PTZ_PRESET			0x00008103
#define HI_P2P_GET_PTZ_PARAM			0x00008104
#define HI_P2P_SET_PTZ_PARAM			0x00008105

#define HI_P2P_SET_RESET				0x00009102
#define HI_P2P_SET_INFRARED				0x00009103
#define HI_P2P_SET_RELAY				0x00009104
#define HI_P2P_GET_CAPACITY				0x00009106				/**/

/********************新增2015.05.06********************/
#define HI_P2P_GET_RTSP_PARAM			0x00004106	/*rtsp*/
#define HI_P2P_SET_RTSP_PARAM			0x00004107
#define HI_P2P_GET_COVER_PARAM			0x00004108	/*视频遮挡*/
#define HI_P2P_SET_COVER_PARAM			0x00004109
#define HI_P2P_GET_VIDEO_CODE			0x0000410a	/*视频编码*/
#define HI_P2P_SET_VIDEO_CODE			0x0000410b
#define HI_P2P_SET_WIFI_CHECK			0x0000410c	/*wifi检测, wifi参数不保存到配置文件*/
#define HI_P2P_SET_EMAIL_PARAM_EXT		0x0000410d	/*新增email检测, email参数不保存到配置文件*/
#define HI_P2P_GET_FTP_PARAM_EXT		0x0000410e	/*新增自动创建目录*/
#define HI_P2P_SET_FTP_PARAM_EXT		0x0000410f	/*新增FTP检测, FTP参数不保存到配置文件*/
#define HI_P2P_GET_SNAP_ALARM_PARAM		0x00004110
#define HI_P2P_SET_SNAP_ALARM_PARAM		0x00004111	
#define HI_P2P_GET_SP_IMAGE_PARAM		0x00004112	/*锐度、曝光度、Gamma、宽动态等*/	
#define HI_P2P_SET_SP_IMAGE_PARAM		0x00004113	
#define HI_P2P_GET_ONVIF_PARAM			0x00004114	/*onvif*/
#define HI_P2P_SET_ONVIF_PARAM			0x00004115	
#define HI_P2P_GET_SYSTEM_LOG			0x00004116	/*系统日志*/
#define HI_P2P_GET_DEV_INFO_EXT			0x00004117  /*系统信息Ext*/
#define HI_P2P_GET_LIGNT_CTRL			0x00004118	/*指示(红外)灯控制*/
#define HI_P2P_SET_LIGNT_CTRL			0x00004119	/*指示(红外)灯控制*/
#define HI_P2P_GET_PTZ_COM_PARAM		0x00008106	/*485 云台参数*/
#define HI_P2P_SET_PTZ_COM_PARAM		0x00008107
#define HI_P2P_GET_INFRARED				0x00009107

/********************新增2015.05.21********************/
#define HI_P2P_STOP_SYSTEM_LOG			0x0000411a	/*停止获取系统日志*/
/********************新增2015.05.25********************/
#define HI_P2P_SET_FORMAT_SD_EXT		0x0000411b	/*格式化SD卡扩展接口，等待格式化结果再返回*/
#define HI_P2P_GET_RESOLUTION			0x0000411c	/*分辨率*/
#define HI_P2P_SET_RESOLUTION			0x0000411d
#define HI_P2P_S_PTZ_CTRL_EXT			0x0000411e
#define HI_P2P_SET_PTZ_PRESET_EXT		0x0000411f
/*******************新增2015.11.03-报警推动*****************/
#define HI_P2P_GET_ALARM_PUSH			0x00004121
/*******************新增2015.12.23-报警推动*****************/
#define HI_P2P_START_REC_UPLOAD			0x00004122	/*开始录像下载,   已废除(请使用EXT命令)*/
#define HI_P2P_STOP_REC_UPLOAD			0x00004123
#define HI_P2P_PAUSE_REC_UPLOAD			0x00004124
#define HI_P2P_PB_POS_SET				0x00004125	/*录像回放拖动*/
/*******************新增2016.01.20-报警推动*****************/
#define HI_P2P_WHITE_LIGHT_GET			0x00004126	/*灯状态获取*/
#define HI_P2P_WHITE_LIGHT_SET			0x00004127
/*******************新增2016.02.23-输入报警*****************/
#define HI_P2P_INPUT_ALARM_GET			0x00004128	/*输入报警状态获取*/
#define HI_P2P_INPUT_ALARM_SET			0x00004129
/*******************新增2016.03.08-输入报警*****************/
#define HI_P2P_WHITE_LIGHT_GET_EXT		0x0000412a		//夜视模式获取
#define HI_P2P_WHITE_LIGHT_SET_EXT		0x0000412b		//夜视模式设置
/*******************新增2016.03.19-输入报警*****************/
#define HI_P2P_VIDEO_FIX_ONE			0x0000412c		//I帧丢失错误修复 
/*************新增2016.04.11-获取录像列表(按时间降序)***********/
#define HI_P2P_PB_QUERY_START_EXT		0x0000412d		//获取录像列表(按时间降序, HI_P2P_PB_QUERY_START为升序)
#define HI_P2P_ALARM_REC_LEN_GET		0x0000412e   	//报警录像时长获取(min)	
#define HI_P2P_ALARM_REC_LEN_SET		0x0000412f   	//报警录像时长设置(min)	
#define HI_P2P_PRESET_STATUS_GET		0x00004130		//预置位状态获取
/*************新增2016.04.27-获取录像列表(按时间降序)***********/
#define HI_P2P_START_REC_UPLOAD_EXT		0x00004131		/*开始录像下载, new*/
/*************新增2016.05.05-报警推送注册、注销功能***********/
#define HI_P2P_ALARM_TOKEN_REGIST		0x00004132		/*报警推送注册*/
#define HI_P2P_ALARM_TOKEN_UNREGIST		0x00004133		/*报警推送注销*/
/********************新增2016.05.26******************/
#define HI_P2P_TEMP_HUMIDITY_GET		0x00004134		/*获取温湿度*/
/********************新增2016.05.26-伊洛PIO版本******************/
#define HI_P2P_PIO_SET					0x00004135		/*设置幻灯片模式*/
#define HI_P2P_MP3_LIST_GET				0x00004136		/*获取MP3列表*/
#define HI_P2P_MP3_PLAY					0x00004137		/*播放MP3*/
#define HI_P2P_GET_ALARM_LOG			0x00004138		/*获取报警日志*/
#define HI_P2P_DEL_ALARM_LOG			0x00004139		/*删除报警日志*/
/********************新增2016.05.31-伊洛TIO版本******************/
#define HI_P2P_TIO_SET					0x0000413a		/*设置TIO灯光*/
/********************新增2016.05.31******************/
#define HI_P2P_SET_USERNAME				0x0000413b		/*修改用户名*/

//#define HI_P2P_TEMP_HUMIDITY_CTRL		0x00004140		/*未完成——温湿度控制(显示/隐藏)*/











/*******************新增2015.09.19-升级*****************/
#define HI_P2P_SET_DOWNLOAD				0x00004801
/*******************新增2015.09.19-升级*****************/








/************************预留***************************/
/*命令  0x00004800-0x00004900 外部使用*/
#define HI_P2P_ALARM_MSG_MD			0x0000a001				/**/
#define HI_P2P_ALARM_MSG_IO			0x0000a002				/**/
#define HI_P2P_ALARM_MSG_AUD		0x0000a003				/**/

#define HI_P2P_STRM_MEIDA_DATA 		0x0000c001
#define HI_P2P_TALK_DATA 			0x0000d001
#define HI_P2P_PB_DATA 				0x0000e001

#define HI_P2P_GET_MEVP_INFO		0x00007115

/*新增2015.04.08*/
#define HI_P2P_GET_SUBSCRIBE_TOKEN	0x0000f003	/*获取验证码*/
#define HI_P2P_ALARM_EVENT			0x0000f004	/*P2P推送报警*/


#endif
