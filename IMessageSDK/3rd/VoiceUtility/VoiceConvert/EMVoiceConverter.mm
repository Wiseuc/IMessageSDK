//
//  VoiceConverter.m
//  Jeans
//
//  Created by Jeans Huang on 12-7-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EMVoiceConverter.h"
#import "wav.h"
#import "interf_dec.h"
#import "dec_if.h"
#import "interf_enc.h"
#import "amrFileCodec.h"
#import <AVFoundation/AVFoundation.h>

@implementation EMVoiceConverter


+ (int)isMP3File:(NSString *)filePath{
    const char *_filePath = [filePath cStringUsingEncoding:NSASCIIStringEncoding];
    return isMP3File(_filePath);
}

+ (int)isAMRFile:(NSString *)filePath{
    const char *_filePath = [filePath cStringUsingEncoding:NSASCIIStringEncoding];
    return isAMRFile(_filePath);
}

+ (int)amrToWav:(NSString*)_amrPath wavSavePath:(NSString*)_savePath{
    
    if (EM_DecodeAMRFileToWAVEFile([_amrPath cStringUsingEncoding:NSASCIIStringEncoding], [_savePath cStringUsingEncoding:NSASCIIStringEncoding]))
        return 0; // success
    
    return 1;   // failed
}

+ (int)wavToAmr:(NSString*)_wavPath amrSavePath:(NSString*)_savePath{
    
    if (EM_EncodeWAVEFileToAMRFile([_wavPath cStringUsingEncoding:NSASCIIStringEncoding], [_savePath cStringUsingEncoding:NSASCIIStringEncoding], 1, 16))
        return 0;   // success
    
    return 1;   // failed
}


+ (int)voiceDurationForPath:(NSString *)sourcePath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ( [fileManager fileExistsAtPath:sourcePath] ) {
        NSURL *voiceUrl = [NSURL fileURLWithPath:sourcePath];
        AVURLAsset* audioAsset =[AVURLAsset URLAssetWithURL:voiceUrl options:nil];
        CMTime audioDuration = audioAsset.duration;
        CGFloat audioDurationSeconds = CMTimeGetSeconds(audioDuration);
        
        return ceil(audioDurationSeconds);
    }
    return 0;
}


@end
