//
//  EMCDDeviceManager+Media.m
//  ChatDemo-UI2.0
//
//  Created by dujiepeng on 5/14/15.
//  Copyright (c) 2015 dujiepeng. All rights reserved.
//

#import "EMCDDeviceManager+Media.h"
#import "EMAudioPlayerUtil.h"
#import "EMAudioRecorderUtil.h"
#import "EMVoiceConverter.h"
#import "UIConfig.h"
#import "lame.h"

typedef NS_ENUM(NSInteger, EMAudioSession){
    EM_DEFAULT = 0,
    EM_AUDIOPLAYER,
    EM_AUDIORECORDER
};

@implementation EMCDDeviceManager (Media)
#pragma mark - AudioPlayer
// 播放音频
- (void)asyncPlayingWithPath:(NSString *)aFilePath
                  completion:(void(^)(NSError *error))completon
{
    BOOL isNeedSetActive = YES;
    // 如果正在播放音频，停止当前播放。
    if([EMAudioPlayerUtil isPlaying]){
        [EMAudioPlayerUtil stopCurrentPlaying];
        isNeedSetActive = NO;
    }
    
    if (isNeedSetActive) {
        // 设置播放时需要的category
        [self setupAudioSessionCategory:EM_AUDIOPLAYER
                               isActive:YES];
    }
    
    if ( [aFilePath hasSuffix:@".amr"] ) {
        // 播放 amr 格式，先转 wav 格式，这里先测试 mp3格式
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *wavFilePath = [[aFilePath stringByDeletingPathExtension] stringByAppendingPathExtension:@"wav"];
        //如果转换后的wav文件不存在, 则去转换一下
        if (![fileManager fileExistsAtPath:wavFilePath]) {
            BOOL covertRet = [self convertAMR:aFilePath toWAV:wavFilePath];
            if (!covertRet) {
                if (completon) {
                    completon([NSError errorWithDomain:@"File format conversion failed"
                                                  code:EMErrorFileTypeConvertionFailure
                                              userInfo:nil]);
                }
                return ;
            }
        }
        [EMAudioPlayerUtil asyncPlayingWithPath:wavFilePath
                                     completion:^(NSError *error)
         {
             [self setupAudioSessionCategory:EM_DEFAULT
                                    isActive:NO];
             if (completon) {
                 completon(error);
             }
             
             if ( self.playCompleteBlock) {
                 self.playCompleteBlock(error);
             }
         }];
    }
    else {
        // 播放 mp3 格式
        [EMAudioPlayerUtil asyncPlayingWithPath:aFilePath
                                     completion:^(NSError *error)
         {
             [self setupAudioSessionCategory:EM_DEFAULT
                                    isActive:NO];
             if (completon) {
                 completon(error);
             }
             
             if ( self.playCompleteBlock) {
                 self.playCompleteBlock(error);
             }
         }];
    }
}

// 停止播放
- (void)stopPlaying{
    [EMAudioPlayerUtil stopCurrentPlaying];
    [self setupAudioSessionCategory:EM_DEFAULT
                           isActive:NO];
}

- (void)stopPlayingWithChangeCategory:(BOOL)isChange{
    [EMAudioPlayerUtil stopCurrentPlaying];
    if (isChange) {
        [self setupAudioSessionCategory:EM_DEFAULT
                               isActive:NO];
    }
}

// 获取播放状态
- (BOOL)isPlaying{
    return [EMAudioPlayerUtil isPlaying];
}

#pragma mark - Recorder

+(NSTimeInterval)recordMinDuration{
    return 1.0;
}

// 开始录音
- (void)asyncStartRecordingWithFileName:(NSString *)fileName
                             completion:(void(^)(NSError *error))completion{
    NSError *error = nil;
    
    // 判断当前是否是录音状态
    
    //NSLog(@"%@",error);
    
    if ([self isRecording]) {
        if (completion) {
            error = [NSError errorWithDomain:@"Record voice is not over yet"
                                        code:EMErrorAudioRecordStoping
                                    userInfo:nil];
            completion(error);
        }
        return ;
    }
    
    // 文件名不存在
    if (!fileName || [fileName length] == 0) {
        error = [NSError errorWithDomain:@"File name not exist"
                                    code:EMErrorAttachmentNotFound
                                userInfo:nil];
        completion(error);
        return ;
    }
    
    BOOL isNeedSetActive = YES;
    if ([self isRecording])
    {
        [EMAudioRecorderUtil cancelCurrentRecording];
        isNeedSetActive = NO;
    }
    
    [self setupAudioSessionCategory:EM_AUDIORECORDER
                           isActive:YES];
    
    _recorderStartDate = [NSDate date];
    
    NSString *recordPath = kVoiceFilePath;
    recordPath = [NSString stringWithFormat:@"%@/%@",recordPath,fileName];
    NSLog(@"%@",recordPath);
    NSFileManager *fm = [NSFileManager defaultManager];
    if(![fm fileExistsAtPath:[recordPath stringByDeletingLastPathComponent]]){
        [fm createDirectoryAtPath:[recordPath stringByDeletingLastPathComponent]
      withIntermediateDirectories:YES
                       attributes:nil
                            error:nil];
    }
    
    [EMAudioRecorderUtil asyncStartRecordingWithPreparePath:recordPath
                                                 completion:completion];
}

// 停止录音
-(void)asyncStopRecordingWithCompletion:(void(^)(NSString *recordPath,
                                                 NSInteger aDuration,
                                                 NSError *error))completion{
    NSError *error = nil;
    // 当前是否在录音
    if(![self isRecording]){
        if (completion) {
            error = [NSError errorWithDomain:@"Recording has not yet begun"
                                        code:EMErrorAudioRecordNotStarted
                                    userInfo:nil];
            completion(nil,0,error);
            return;
        }
    }
    
    __weak typeof(self) weakSelf = self;
    _recorderEndDate = [NSDate date];
    
    if([_recorderEndDate timeIntervalSinceDate:_recorderStartDate] < [EMCDDeviceManager recordMinDuration]){
        if (completion) {
            error = [NSError errorWithDomain:@"Recording time is too short"
                                        code:EMErrorAudioRecordDurationTooShort
                                    userInfo:nil];
            completion(nil,0,error);
        }
        
        // 如果录音时间较短，延迟1秒停止录音（iOS中，如果快速开始，停止录音，UI上会出现红条,为了防止用户又迅速按下，UI上需要也加一个延迟，长度大于此处的延迟时间，不允许用户循序重新录音。PS:研究了QQ和微信，就这么玩的,聪明）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)([EMCDDeviceManager recordMinDuration] * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [EMAudioRecorderUtil asyncStopRecordingWithCompletion:^(NSString *recordPath) {
                [weakSelf setupAudioSessionCategory:EM_DEFAULT isActive:NO];
            }];
        });
        return ;
    }
    
    [EMAudioRecorderUtil asyncStopRecordingWithCompletion:^(NSString *recordPath) {
        if (completion) {
            if (recordPath) {
                
#if 0
                //录音格式转换，从wav转为amr
                NSString *amrFilePath = [[recordPath stringByDeletingPathExtension]
                                         stringByAppendingPathExtension:@"amr"];
                BOOL convertResult = [self convertWAV:recordPath toAMR:amrFilePath];
#endif
                
                //录音格式转换，从 caf 转为 mp3
                NSString *mp3FilePath = [[recordPath stringByDeletingPathExtension]
                                         stringByAppendingPathExtension:@"mp3"];
//                convertResult = [self convertCAF:recordPath toMP3:mp3FilePath];
//                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{ // 1
//                    BOOL convertResult = [self convertCAF:recordPath toMP3:mp3FilePath];
//                    if (convertResult) {
//                        // 删除录的 转码之前的文件（wav、caf）
//                        NSFileManager *fm = [NSFileManager defaultManager];
//                        [fm removeItemAtPath:recordPath error:nil];
//                    }
//                    NSLog(@"当前再主线程下.....%d",[NSThread isMainThread]);
//                    dispatch_async(dispatch_get_main_queue(), ^{ // 2
//                        NSLog(@"当前再主线程下.....%d",[NSThread isMainThread]);
//                        
//                        completion(mp3FilePath,(int)[self->_recorderEndDate timeIntervalSinceDate:self->_recorderStartDate],nil);
//                    }); 
//                });
//                
                dispatch_queue_t q2=dispatch_queue_create("com.wiseuc.gcd", DISPATCH_QUEUE_CONCURRENT);
                dispatch_async(q2, ^{
                    BOOL convertResult = [self convertCAF:recordPath toMP3:mp3FilePath];
                    if (convertResult) {
                        // 删除录的 转码之前的文件（wav、caf）
                        NSFileManager *fm = [NSFileManager defaultManager];
                        [fm removeItemAtPath:recordPath error:nil];
                    }
                    NSLog(@"当前再主线程下.....%@",[NSThread currentThread]);
                    dispatch_async(dispatch_get_main_queue(), ^{ // 2
                        NSLog(@"当前再主线程下.....%@",[NSThread currentThread]);
                        
                        completion(mp3FilePath,(int)[self->_recorderEndDate timeIntervalSinceDate:self->_recorderStartDate],nil);
                    });
                });
                
//                BOOL convertResult = [self convertCAF:recordPath toMP3:mp3FilePath];
//                
//                
//                if (convertResult) {
//                    // 删除录的 转码之前的文件（wav、caf）
//                    NSFileManager *fm = [NSFileManager defaultManager];
//                    [fm removeItemAtPath:recordPath error:nil];
//                }
//                completion(mp3FilePath,(int)[self->_recorderEndDate timeIntervalSinceDate:self->_recorderStartDate],nil);
            }
            [weakSelf setupAudioSessionCategory:EM_DEFAULT isActive:NO];
        }
    }];
}

// 取消录音
-(void)cancelCurrentRecording{
    [EMAudioRecorderUtil cancelCurrentRecording];
}

// 获取录音状态
-(BOOL)isRecording{
    return [EMAudioRecorderUtil isRecording];
}

#pragma mark - Private
-(NSError *)setupAudioSessionCategory:(EMAudioSession)session
                             isActive:(BOOL)isActive{
    BOOL isNeedActive = NO;
    if (isActive != _currActive) {
        isNeedActive = YES;
        _currActive = isActive;
    }
    NSError *error = nil;
    NSString *audioSessionCategory = nil;
    switch (session) {
        case EM_AUDIOPLAYER:
            // 设置播放category
            audioSessionCategory = AVAudioSessionCategoryPlayback;
            break;
        case EM_AUDIORECORDER:
            // 设置录音category
            audioSessionCategory = AVAudioSessionCategoryRecord;
            break;
        default:
            // 还原category
            audioSessionCategory = AVAudioSessionCategoryAmbient;
            break;
    }
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    // 如果当前category等于要设置的，不需要再设置
    if (![_currCategory isEqualToString:audioSessionCategory]) {
        [audioSession setCategory:audioSessionCategory error:nil];
    }
    
    if (isNeedActive) {
        BOOL success = [audioSession setActive:isActive
                                   withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation
                                         error:&error];
        if(!success || error){
            error = [NSError errorWithDomain:@"Failed to initialize AVAudioPlayer"
                                        code:EMErrorInitFailure
                                    userInfo:nil];
            return error;
        }
    }
    _currCategory = audioSessionCategory;
    
    return error;
}

#pragma mark - Convert

- (BOOL)convertAMR:(NSString *)amrFilePath
             toWAV:(NSString *)wavFilePath
{
    BOOL ret = NO;
    BOOL isFileExists = [[NSFileManager defaultManager] fileExistsAtPath:amrFilePath];
    if (isFileExists) {
        [EMVoiceConverter amrToWav:amrFilePath wavSavePath:wavFilePath];
        isFileExists = [[NSFileManager defaultManager] fileExistsAtPath:wavFilePath];
        if (isFileExists) {
            ret = YES;
        }
    }
    
    return ret;
}

- (BOOL)convertWAV:(NSString *)wavFilePath
             toAMR:(NSString *)amrFilePath {
    BOOL ret = NO;
    BOOL isFileExists = [[NSFileManager defaultManager] fileExistsAtPath:wavFilePath];
    if (isFileExists) {
        [EMVoiceConverter wavToAmr:wavFilePath amrSavePath:amrFilePath];
        isFileExists = [[NSFileManager defaultManager] fileExistsAtPath:amrFilePath];
        if (!isFileExists) {
            
        } else {
            ret = YES;
        }
    }
    
    return ret;
}

- (BOOL)convertCAF:(NSString *)cafFilePath toMP3:(NSString *)MP3FilePath {
    NSURL *recordUrl = [NSURL URLWithString:cafFilePath];
    NSURL *mp3FilePath = [NSURL URLWithString:MP3FilePath];
    @try {
        int read, write;
        
        FILE *pcm = fopen([[recordUrl absoluteString] cStringUsingEncoding:1], "rb");   //source 被转换的音频文件位置
        fseek(pcm, 4*1024, SEEK_CUR);                                                   //skip file header
        FILE *mp3 = fopen([[mp3FilePath absoluteString] cStringUsingEncoding:1], "wb"); //output 输出生成的Mp3文件位置
        
        const int PCM_SIZE = 8192;
        const int MP3_SIZE = 8192;
        short int pcm_buffer[PCM_SIZE*2];
        unsigned char mp3_buffer[MP3_SIZE];
        
        lame_t lame = lame_init();
        lame_set_in_samplerate(lame, 11025.0);
        lame_set_VBR(lame, vbr_default);
        lame_init_params(lame);
        
        do {
            read = fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
            if (read == 0)
                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
            else
                write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
            
            fwrite(mp3_buffer, write, 1, mp3);
            
        } while (read != 0);
        
        lame_close(lame);
        fclose(mp3);
        fclose(pcm);
    }
    @catch (NSException *exception) {
        //        NSLog(@"%@",[exception description]);
    }
    @finally {
        return YES;
    }
    return NO;
}

@end
