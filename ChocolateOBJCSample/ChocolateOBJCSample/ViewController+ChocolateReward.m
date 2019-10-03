//
//  ViewController+ChocolateReward.m
//  ChocolateOBJCSample
//
//  Created by Lev Trubov on 10/3/19.
//  Copyright © 2019 Lev Trubov. All rights reserved.
//

#import "ViewController+ChocolateReward.h"

static ChocolatePlatformRewardAdDisplay *ad = nil;
UIAlertController *rewardAlert = nil;

@implementation ViewController (ChocolateReward)

-(void)loadRewardAd {
    ChocolatePlatformFullscreenAdState state = [ChocolatePlatformRewardAdDisplay adState];
    if(state == CHPFullscreenAdStateReadyToLoad ||
       state == CHPFullscreenAdStateFailedToLoad) {
        ad = [[ChocolatePlatformRewardAdDisplay alloc] initWithAdUnitID:[ChocolatePlatform getAdUnitID] delegate:self];
        [ad load];
    } else if(state == CHPFullscreenAdStateLoading) {
        NSLog(@"REWD is loading...");
    }
}

-(void)showRewardAd {
    ChocolatePlatformRewardAdSettings *rewardSettings = [ChocolatePlatformRewardAdSettings blankSettings];
    rewardSettings.rewardName = @"Coins";
    rewardSettings.rewardAmount = 1000;
    [ad show:rewardSettings];
}

#pragma mark - Reward callbacks

- (UIViewController *)rewardAdViewControllerForPresentingModalView {
    return self;
}

- (void)rewardedVideoDidFailToLoadAdWithError:(int)error rewardAdView:(ChocolatePlatformRewardAdDisplay *)rewardedAd {
    NSLog(@"%@: failed to load reward ad: %d", appName, error);
    adTypeLoadedStates[1] = @NO;
    [self adjustUIForAdState];
}

- (void)rewardedVideoDidFailToStartVideoWithError:(int)error rewardAdView:(ChocolatePlatformRewardAdDisplay *)rewardedAd {
    adTypeLoadedStates[1] = @NO;
    [self adjustUIForAdState];
}

- (void)rewardedVideoDidFinish:(NSUInteger)rewardAmount name:(NSString *)rewardName {
    rewardAlert = [UIAlertController alertControllerWithTitle:@"Reward Ad Done!" message:[NSString stringWithFormat:@"You've received %ld %@!", rewardAmount, rewardName] preferredStyle:UIAlertControllerStyleAlert];
    [rewardAlert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
        rewardAlert = nil;
    }]];
}

- (void)rewardedVideoDidLoadAd:(ChocolatePlatformRewardAdDisplay *)rewardedAd {
    NSLog(@"%@: loaded reward ad", appName);
    adTypeLoadedStates[1] = @YES;
    [self adjustUIForAdState];
}

- (void)rewardedVideoDidStartVideo:(ChocolatePlatformRewardAdDisplay *)rewardedAd {
    NSLog(@"%@: shown rewarded ad", appName);
}

- (void)rewardedVideoWillDismiss:(ChocolatePlatformRewardAdDisplay *)rewardedAd {
    NSLog(@"%@: dismissed rewarded ad", appName);
    adTypeLoadedStates[1] = @NO;
    [self adjustUIForAdState];
    ad = nil;
    
    if(rewardAlert) {
        [self presentViewController:rewardAlert animated:YES completion:nil];
    }
}

@end
