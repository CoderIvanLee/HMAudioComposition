//
//  HMAudioComposition.m
//  HMAVAudoTools
//
//  Created by 传智.小飞燕 on 16/7/25.
//  Copyright © 2016年 itheima. All rights reserved.
//

#import "HMAudioComposition.h"
#import <AVFoundation/AVFoundation.h>

@implementation HMAudioComposition

/// 合并音频文件
/// @param sourceURLs 需要合并的多个音频文件
/// @param toURL      合并后音频文件的存放地址
/// 注意:导出的文件是:m4a格式的.
+ (void) sourceURLs:(NSArray *) sourceURLs composeToURL:(NSURL *) toURL completed:(void (^)(NSError *error)) completed{
    
    NSAssert(sourceURLs.count > 1,@"源文件不足两个无需合并");
 
    //  合并所有的录音文件
    AVMutableComposition* mixComposition = [AVMutableComposition composition];
    
    //  音频插入的开始时间
    CMTime beginTime = kCMTimeZero;
    //  获取音频合并音轨
    AVMutableCompositionTrack *compositionAudioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    
//  用于记录错误的对象
    NSError *error = nil;
    for (NSURL *sourceURL in sourceURLs) {
//      音频文件资源
        AVURLAsset  *audioAsset = [[AVURLAsset alloc]initWithURL:sourceURL options:nil];
//      需要合并的音频文件的区间
         CMTimeRange audio_timeRange = CMTimeRangeMake(kCMTimeZero, audioAsset.duration);
//      参数说明:
        //      insertTimeRange:源录音文件的的区间
        //      ofTrack:插入音频的内容
        //      atTime:源音频插入到目标文件开始时间
        //      error: 插入失败记录错误
        //      返回:YES表示插入成功,`NO`表示插入失败
        BOOL success = [compositionAudioTrack insertTimeRange:audio_timeRange ofTrack:[[audioAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime:beginTime error:&error];
//      如果插入失败,打印插入失败信息
        if (!success) {
            NSLog(@"插入音频失败: %@",error);
        }
        //      记录开始时间
        beginTime = CMTimeAdd(beginTime, audioAsset.duration);
    }
    
    
// 创建一个导入M4A格式的音频的导出对象
    AVAssetExportSession* assetExport = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetAppleM4A];
//  导入音视频的URL
    assetExport.outputURL = toURL;
//  导出音视频的文件格式
    assetExport.outputFileType = @"com.apple.m4a-audio";
//  导入出
    [assetExport exportAsynchronouslyWithCompletionHandler:^{
//      分发到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            completed(assetExport.error);
        });
    }];
    
}


@end
