//
//  AVAudioSession+AVAudioSession_Swift.h
//  Piano
//
//  Created by Vadym Markov on 28/11/2018.
//  Copyright © 2018 FINN. All rights reserved.
//

@import AVFoundation;

NS_ASSUME_NONNULL_BEGIN

@interface AVAudioSession (Swift)

- (BOOL)swift_setCategory:(AVAudioSessionCategory)category error:(NSError **)outError NS_SWIFT_NAME(setCategory(_:));

@end

NS_ASSUME_NONNULL_END
