//
//  LiveMonitorVC.m
//  ECG
//
//  Created by Will Yang (yangyu.will@gmail.com) on 4/29/11.
//  Copyright 2013 WMS Studio. All rights reserved.
//


#import <QuartzCore/QuartzCore.h>
#import "LiveMonitorVC.h"
#import "LeadPlayer.h"
#import "Helper.h"

@implementation LiveMonitorVC
@synthesize leads, btnStart,scrollView, labelProfileId, labelProfileName, btnDismiss;
@synthesize liveMode, labelRate, statusInfo, startRecordingIndex, HR, stopTheTimer;
@synthesize buffer, DEMO, labelMsg, photoView, btnRefresh, newBornMode;

int leadCount = 1;

float uVpb = 0.9;

int bufferSecond = 300;
float pixelPerUV = 5 * 10.0 / 1000;

- (void)heartView{
    _dataArr = [[NSMutableArray alloc]init];
//    _tempData = [[NSMutableArray alloc] init];
    [self addViews];
    [self initialMonitor];
    [self setLeadsLayout:1];
    [self startLiveMonitoring];
}


-(BOOL)canBecomeFirstResponder 
{
    return YES;
}


- (void)viewWillDisappear:(BOOL)animated
{	
//    [super viewWillDisappear:animated];
}


#pragma mark -
#pragma mark Initialization, Monitoring and Timer events 

- (void)initialMonitor
{
	bufferCount = 10;
	self.labelMsg.text = @"25mm/s  10mm/mv";
    
    self.btnRecord.enabled = NO;
    self.btnDismiss.enabled = NO;
    
    NSMutableArray *buf = [[NSMutableArray alloc] init];
    self.buffer = buf;
}

- (void)startLiveMonitoring
{
	monitoring = YES;
	stopTheTimer = NO;
    
    [self startTimer_popDataFromBuffer];
    [self startTimer_drawing];
}

- (void)startTimer_popDataFromBuffer
{	
	CGFloat popDataInterval = 420.0f / self.sampleRate;
	
	popDataTimer = [NSTimer scheduledTimerWithTimeInterval:popDataInterval
													target:self
												  selector:@selector(timerEvent_popData)
												  userInfo:NULL
												   repeats:YES];
}

- (void)startTimer_drawing
{	
	drawingTimer = [NSTimer scheduledTimerWithTimeInterval:self.drawingInterval
													target:self
												  selector:@selector(timerEvent_drawing)
												  userInfo:NULL
                                                    repeats:YES];
}


- (void)timerEvent_drawing
{
    [self drawRealTime];
}

- (void)timerEvent_popData
{
    [self popDemoDataAndPushToLeads];
}

- (void)popDemoDataAndPushToLeads
{
//	int length = 440;
//	short **data = [Helper getDemoData:length];
//	
//	NSArray *data12Arrays = [self convertDemoData:data dataLength:length doWilsonConvert:NO];
//	
//	for (int i=0; i<leadCount; i++)
//	{
//		NSArray *data = [data12Arrays objectAtIndex:i];
//		[self pushPoints:data data12Index:i];
//	}
    //数据全部在tempData里面，所以从tempData里面取用到的数据，用完后直接把tempData已经取出得数据删掉
    if (_tempData.count >= 250) {
        [_dataArr setArray:[_tempData subarrayWithRange:NSMakeRange(0, 250)]];
        [_tempData removeObjectsInRange:NSMakeRange(0, 250)];
        [self pushPoints:_dataArr data12Index:0];
    }
    
}

- (void)pushPoints:(NSArray *)_pointsArray data12Index:(NSInteger)data12Index;
{
	LeadPlayer *lead = [self.leads objectAtIndex:data12Index];
    
//	if (lead.pointsArray.count > bufferSecond * sampleRate)
//	{
//		[lead resetBuffer];
//	}
	
    [lead.pointsArray addObjectsFromArray:_pointsArray];
    
//    NSLog(@"lead.pointsArray : %lu",(unsigned long)lead.pointsArray.count);
    if (lead.pointsArray.count - lead.currentPoint == 0)
    {
        [lead.pointsArray removeAllObjects];
        lead.currentPoint = 0;
    }

	if (data12Index==0)
	{
		countOfPointsInQueue = (int)lead.pointsArray.count;
		currentDrawingPoint = lead.currentPoint;
	}
}

- (NSArray *)convertDemoData:(short **)rawdata dataLength:(int)length doWilsonConvert:(BOOL)wilsonConvert
{
	NSMutableArray *data = [[NSMutableArray alloc] init];
	for (int i=0; i<12; i++)
	{
		NSMutableArray *array = [[NSMutableArray alloc] init];
		[data addObject:array];
	}
	
	for (int i=0; i<length; i++)
	{
		for (int j=0; j<12; j++)
		{
			NSMutableArray *array = [data objectAtIndex:j];
			NSNumber *number = [NSNumber numberWithInt:rawdata[i][j]];
			[array insertObject:number atIndex:i];
		}
	}
	
	return data;
}

- (void)drawRealTime
{
	LeadPlayer *l = [self.leads objectAtIndex:0];
	
	if (l.pointsArray.count > l.currentPoint)
	{	
		for (LeadPlayer *lead in self.leads)
		{
			[lead fireDrawing];
		}
	}
}

- (void)addViews
{	
	NSMutableArray *array = [[NSMutableArray alloc] init];
	
	for (int i=0; i<leadCount; i++) {
		LeadPlayer *lead = [[LeadPlayer alloc] init];
        lead.backgroundColor = [UIColor redColor];
        lead.layer.cornerRadius = 8;
        lead.layer.borderColor = [[UIColor grayColor] CGColor];
        lead.layer.borderWidth = 1;
        lead.clipsToBounds = YES;
        
		lead.index = i;
        lead.pointsArray = [[NSMutableArray alloc] init];
                
        lead.liveMonitor = self;
		      
        [array insertObject:lead atIndex:i];
        
        [self.scrollView addSubview:lead];
	}
	
	self.leads = array;
}

- (void)setLeadsLayout:(UIInterfaceOrientation)orientation
{
    float margin = 5;
	NSInteger leadHeight = self.scrollView.frame.size.height / 3 - margin * 2;
	NSInteger leadWidth = self.scrollView.frame.size.width;
    scrollView.contentSize = CGSizeMake(ScreenWidth, 0);
    
    for (int i=0; i<leadCount; i++)
    {
        LeadPlayer *lead = [self.leads objectAtIndex:i];
        float pos_y = i * (margin + leadHeight);
        
        [lead setFrame:CGRectMake(0., pos_y, leadWidth, leadHeight)];
        lead.pos_x_offset = lead.currentPoint;
        lead.alpha = 0;
        [lead setNeedsDisplay];
    }
    
    [UIView animateWithDuration:0.6f animations:^{
        for (int i=0; i<leadCount; i++)
        {
            LeadPlayer *lead = [self.leads objectAtIndex:i];
            lead.alpha = 1;
        }
    }];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{

}


#pragma mark -
#pragma mark Memory and others

- (void)didReceiveMemoryWarning
{
//    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
//    [super viewDidUnload];
}

- (void)dealloc {
	
	



	drawingTimer = nil;
	readDataTimer = nil;
	popDataTimer = nil;
	
}

- (UIScrollView *)scrollView{
    if (scrollView == nil) {
        scrollView = [[UIScrollView alloc] init];
//        scrollView.frame = CGRectMake(0, 0, self.bounds.size.width, 500);
        scrollView.frame = self.bounds;
        scrollView.contentSize = CGSizeMake(10000, 10000);
        scrollView.backgroundColor = [UIColor orangeColor];
        [self addSubview:scrollView];
    }
    return scrollView;
}

- (float)drawingInterval{
    
    if (_drawingInterval == 0) {
        _drawingInterval = 0.04;
    }
    return _drawingInterval;
}

- (NSInteger)sampleRate{
    
    if (_sampleRate == 0) {
        _sampleRate = 500;
    }
    return _sampleRate;
}

@end
