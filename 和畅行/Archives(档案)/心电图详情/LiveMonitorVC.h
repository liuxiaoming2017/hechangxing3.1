//
//  LiveMonitorVC.h
//  ECG
//
//  Created by Will Yang (yangyu.will@gmail.com) on 4/29/11.
//  Copyright 2013 WMS Studio. All rights reserved.
//

#import <UIKit/UIKit.h>


@class LeadPlayer;
@interface LiveMonitorVC : UIView {

	NSMutableArray *leads, *buffer;
	NSTimer *drawingTimer, *readDataTimer, *recordingTimer, *popDataTimer, *playSoundTimer;
	
	UIImage *recordingImage;
	
	int second;
	BOOL stopTheTimer, autoStart, DEMO, monitoring;
	
	UIButton *btnStart, *btnStop, *photoView;
	
//	UIScrollView *scrollView;
	UIImage *screenShot;
	
	int layoutScale;  // 0: 3x4   1: 2x6   2: 1x12
	int startRecordingIndex, endRecordingIndex, HR;
	
	NSString *now;
	BOOL liveMode;
	UILabel *labelRate, *labelProfileId, *labelProfileName, *labelMsg;
	UIBarButtonItem *statusInfo, *btnDismiss, *btnRefresh;
	
	
	int countOfPointsInQueue, countOfRecordingPoints;
	int currentDrawingPoint, bufferCount;
	
	
	LeadPlayer *firstLead;
	
	int lastHR;
    int newBornMode, errorCount;
    
    int num0;
}

@property (nonatomic, strong) NSMutableArray *leads, *buffer;
@property (nonatomic, strong) IBOutlet UIButton *btnStart, *photoView, *btnRecord;
@property (nonatomic, strong) IBOutlet UIView *vwProfile, *vwMonitor;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic) BOOL liveMode, DEMO;
@property (nonatomic, strong) IBOutlet UILabel *labelRate, *labelProfileId, *labelProfileName, *labelMsg;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *statusInfo, *btnDismiss, *btnRefresh;
@property (nonatomic) int startRecordingIndex, HR, newBornMode;
@property (nonatomic) BOOL stopTheTimer;
@property (nonatomic, strong) IBOutlet UILabel *lbDevice;

@property (nonatomic,strong) NSMutableArray *dataArr;
@property (nonatomic,strong) NSMutableArray *tempData;

/**float drawingInterval = 0.04;*/
@property (nonatomic,assign) float drawingInterval;
/**int sampleRate = 500;*/
@property (nonatomic,assign) NSInteger sampleRate;

- (void)heartView;
- (void)startLiveMonitoring;

@end
