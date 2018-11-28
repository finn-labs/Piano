//
//  AVAudioSession+AVAudioSession_Swift.m
//  Piano
//
//  Created by Vadym Markov on 28/11/2018.
//  Copyright © 2018 FINN. All rights reserved.
//

#import "AVAudioSession+Swift.h"

@implementation AVAudioSession (Swift)

- (BOOL)swift_setCategory:(AVAudioSessionCategory)category error:(NSError **)outError {
    return [self setCategory:category error:outError];
}

@end
