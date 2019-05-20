//
//  SGScanningQRCodeVC.m
//  SGQRCodeExample
//
//  Created by Sorgle on 16/8/25.
//  Copyright © 2016年 Sorgle. All rights reserved.
//
//  - - - - - - - - - - - - - - 交流QQ：1357127436 - - - - - - - - - - - - - - - //
//
//  - - 如在使用中, 遇到什么问题或者有更好建议者, 请于 kingsic@126.com 邮箱联系 - - - - //
//  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//  - - GitHub下载地址 https://github.com/kingsic/SGQRCode.git - - - - - - - - - //
//
//  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - //

#import "SGScanningQRCodeVC.h"
#import <AVFoundation/AVFoundation.h>
#import "SGScanningQRCodeView.h"
#import "ScanSuccessJumpVC.h"
#import "SGQRCodeTool.h"
#import <Photos/Photos.h>
#import "SGAlertView.h"
#import "HCY_CarDetailController.h"
#import "LoginViewController.h"
 
@interface SGScanningQRCodeVC () <AVCaptureMetadataOutputObjectsDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIAlertViewDelegate>
/** 会话对象 */
@property (nonatomic, strong) AVCaptureSession *session;
/** 图层类 */
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic, strong) SGScanningQRCodeView *scanningView;
@property (nonatomic, strong) UIButton *right_Button;
@property (nonatomic, assign) BOOL first_push;
@property (nonatomic, assign) BOOL isNetValid;

@end

@implementation SGScanningQRCodeVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 创建扫描边框
    
    
    self.scanningView = [[SGScanningQRCodeView alloc] initWithFrame:self.view.frame outsideViewLayer:self.view.layer];
    [self.view addSubview:self.scanningView];

  
    // 二维码扫描
    [self setupScanningQRCode];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"扫一扫";
    self.first_push = YES;
    self.isNetValid = YES;
    
}

-(void)popview{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
#pragma mark - - - rightBarButtonItenAction 的点击事件
- (void)rightBarButtonItenAction {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - - - UIImagePickerControllerDelegate
/*
// 此方法，已过期
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {

    [self dismissViewControllerAnimated:YES completion:^{
        [self scanQRCodeFromPhotosInTheAlbum:image];
    }];
}
*/
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    [self dismissViewControllerAnimated:YES completion:^{
//        [self scanQRCodeFromPhotosInTheAlbum:[info objectForKey:@"UIImagePickerControllerOriginalImage"]];
    }];
}
#pragma mark - - - 从相册中识别二维码, 并进行界面跳转
- (void)scanQRCodeFromPhotosInTheAlbum:(UIImage *)image {
    // CIDetector(CIDetector可用于人脸识别)进行图片解析，从而使我们可以便捷的从相册中获取到二维码
    // 声明一个CIDetector，并设定识别类型 CIDetectorTypeQRCode
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{ CIDetectorAccuracy : CIDetectorAccuracyHigh }];
    
    // 取得识别结果
    NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
    
    CIQRCodeFeature *feature = [features objectAtIndex:0];
    NSString *scannedResult = feature.messageString;
    
    ScanSuccessJumpVC *jumpVC = [[ScanSuccessJumpVC alloc] init];
    jumpVC.jump_URL = scannedResult;
    [self.navigationController pushViewController:jumpVC animated:YES];

    
    for (int index = 0; index < [features count]; index ++) {
        CIQRCodeFeature *feature = [features objectAtIndex:index];
        NSString *scannedResult = feature.messageString;
        
        if (self.first_push) {
            
            self.first_push = NO;
        }
    }
}

#pragma mark - - - 二维码扫描
- (void)setupScanningQRCode {
    // 初始化链接对象（会话对象）
    self.session = [[AVCaptureSession alloc] init];
    // 实例化预览图层, 传递_session是为了告诉图层将来显示什么内容
    self.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    [SGQRCodeTool SG_scanningQRCodeOutsideVC:self session:_session previewLayer:_previewLayer];
    
    __weak typeof(self) weakSelf = self;
    weakSelf.scanningView.popBlock =  ^(SGScanningQRCodeView *code) {
        [weakSelf popview];
    };
}

#pragma mark - - - 二维码扫描代理方法
// 调用代理方法，会频繁的扫描
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    
    // 0、扫描成功之后的提示音
    [self playSoundEffect:@"sound.caf"];
    
    // 2、删除预览图层
    [self.previewLayer removeFromSuperlayer];
    // 1、如果扫描完成，停止会话
    [self.session stopRunning];

    
    // 3、设置界面显示扫描结果
    if (metadataObjects.count > 0) {
        AVMetadataMachineReadableCodeObject *obj = metadataObjects[0];
        
        NSString *str = [NSString stringWithFormat:@"%@",obj.stringValue];
        
        // [self setupScanningQRCode];

         NSString *str1 = [NSString stringWithFormat:@"/member/cashcard/getCard.jhtml?imageCode=%@",str];

        [[NetworkManager sharedNetworkManager] requestWithType:0 urlString:str1 parameters:nil successBlock:^(id response) {
            //             [hud hideAnimated:YES];
            if ([response[@"status"] integerValue] == 100){
                HCY_CarDetailController *vc = [[HCY_CarDetailController alloc]init];
                vc.dateDic = response;
                [self.navigationController pushViewController:vc animated:YES];
            } else if ([response[@"status"] intValue]== 44) {
                
                UIAlertController *alerVC = [UIAlertController alertControllerWithTitle:ModuleZW(@"提示") message:ModuleZW(@"登录超时，请重新登录") preferredStyle:(UIAlertControllerStyleAlert)];
                UIAlertAction *suerAction = [UIAlertAction actionWithTitle:ModuleZW(@"确定") style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                    LoginViewController *loginVC = [[LoginViewController alloc]init];
                    [self.navigationController pushViewController:loginVC animated:YES];
                }];
                [alerVC addAction:suerAction];
                [self presentViewController:alerVC animated:YES completion:nil];
            } else  {
                NSString *str = [response objectForKey:@"data"];
                UIAlertController *alerVC = [UIAlertController alertControllerWithTitle:ModuleZW(@"提示") message:str preferredStyle:(UIAlertControllerStyleAlert)];
                UIAlertAction *suerAction = [UIAlertAction actionWithTitle:ModuleZW(@"确定") style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                    [self setupScanningQRCode];
                }];
                [alerVC addAction:suerAction];
                [self presentViewController:alerVC animated:YES completion:nil];
                
            }
        } failureBlock:^(NSError *error) {
            
        }];
            
        }

}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - - - 扫描提示声
/** 播放音效文件 */
- (void)playSoundEffect:(NSString *)name{
    // 获取音效
    NSString *audioFile = [[NSBundle mainBundle] pathForResource:name ofType:nil];
    NSURL *fileUrl = [NSURL fileURLWithPath:audioFile];
    
    // 1、获得系统声音ID
    SystemSoundID soundID = 0;

    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(fileUrl), &soundID);
    
    // 如果需要在播放完之后执行某些操作，可以调用如下方法注册一个播放完成回调函数
    AudioServicesAddSystemSoundCompletion(soundID, NULL, NULL, soundCompleteCallback, NULL);
    
    // 2、播放音频
    AudioServicesPlaySystemSound(soundID); // 播放音效
}
/**
 *  播放完成回调函数
 *
 *  @param soundID    系统声音ID
 *  @param clientData 回调时传递的数据
 */
void soundCompleteCallback(SystemSoundID soundID, void *clientData){
}

#pragma mark - - - 移除定时器
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.scanningView removeTimer];
    [self.scanningView removeFromSuperview];
    self.scanningView = nil;
    //    NSLog(@" - - -- viewDidAppear");
}





@end

/*
 
 二维码扫描的步骤：
     1、创建设备会话对象，用来设置设备数据输入
     2、获取摄像头，并且将摄像头对象加入当前会话中
     3、实时获取摄像头原始数据显示在屏幕上
     4、扫描到二维码/条形码数据，通过协议方法回调
 
 AVCaptureSession 会话对象。此类作为硬件设备输入输出信息的桥梁，承担实时获取设备数据的责任
 AVCaptureDeviceInput 设备输入类。这个类用来表示输入数据的硬件设备，配置抽象设备的port
 AVCaptureMetadataOutput 输出类。这个支持二维码、条形码等图像数据的识别
 AVCaptureVideoPreviewLayer 图层类。用来快速呈现摄像头获取的原始数据
 二维码扫描功能的实现步骤是创建好会话对象，用来获取从硬件设备输入的数据，并实时显示在界面上。在扫描到相应图像数据的时候，通过AVCaptureVideoPreviewLayer类型进行返回
 
 */

