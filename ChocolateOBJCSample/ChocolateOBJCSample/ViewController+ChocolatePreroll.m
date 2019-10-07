//
//  ViewController+ChocolatePreroll.m
//  ChocolateOBJCSample
//
//  Created by Lev Trubov on 10/3/19.
//  Copyright © 2019 Lev Trubov. All rights reserved.
//

#import "ViewController+ChocolatePreroll.h"

static ChocolatePlatformPrerollAdDisplay *ad = nil;
static UIViewController *fullscreenAdContainer = nil;

@implementation ViewController (ChocolatePreroll)

-(void)loadPrerollAd {
    ad = [[ChocolatePlatformPrerollAdDisplay alloc] initWithAdUnitID:[ChocolatePlatform getAdUnitID]
                                                                size:adSizeFullScreenPhone
                                                            delegate:self];
    [ad load];
}

-(void)showPrerollAd {
    adTypeLoadedStates[3] = @NO;
    [self adjustUIForAdState];
    [publisherVideo.player pause];
    if(prerollFullscreenToggle.on) {
        fullscreenAdContainer = [[UIViewController alloc] init];
        fullscreenAdContainer.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:fullscreenAdContainer animated:YES completion:^{
            [ad showIn:fullscreenAdContainer.view at:fullscreenAdContainer.view.center];
        }];
    } else {
        [ad showOnPlayer:publisherVideo];
    }
}

#pragma mark - preroll ad delegate

- (void)onPrerollAdLoaded:(ChocolatePlatformPrerollAdDisplay *)ad {
    NSLog(@"preroll ad loaded");
    adTypeLoadedStates[3] = @YES;
    [self adjustUIForAdState];
}

- (void)onPrerollAdLoadFailed:(ChocolatePlatformPrerollAdDisplay *)ad
                    errorCode:(ChocolatePlatformNoAdReason)errorCode {
    NSLog(@"preroll ad load failed");
    adTypeLoadedStates[3] = @NO;
    [self adjustUIForAdState];
}

- (void)onPrerollAdPlaybackFailed:(ChocolatePlatformPrerollAdDisplay *)ad
                        errorCode:(ChocolatePlatformNoAdReason)errorCode {
    NSLog(@"preroll playback failed");
    adTypeLoadedStates[3] = @YES;
    [self adjustUIForAdState];
    
    [publisherVideo.player play];
}

- (void)onPrerollAdStarted:(ChocolatePlatformPrerollAdDisplay*)ad {
    NSLog(@"preroll ad started");

}

- (void)onPrerollAdClicked:(ChocolatePlatformPrerollAdDisplay*)ad {
    NSLog(@"preroll ad clicked");
}

- (void)onPrerollAdFinished:(ChocolatePlatformPrerollAdDisplay*)ad {
    NSLog(@"preroll ad done");
    adTypeLoadedStates[3] = @NO;
    [self adjustUIForAdState];
    
    if(fullscreenAdContainer) {
        [fullscreenAdContainer dismissViewControllerAnimated:YES completion:^{
            [self->publisherVideo.player play];
            fullscreenAdContainer = nil;
        }];
    } else {
        [publisherVideo.player play];
    }
}

@end
