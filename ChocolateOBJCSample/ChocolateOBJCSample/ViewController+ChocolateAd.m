//
//  ViewController+ChocolateAd.m
//  ChocolateOBJCSample
//
//  Created by Lev Trubov on 11/8/19.
//  Copyright © 2019 Lev Trubov. All rights reserved.
//

#import "ViewController+ChocolateAd.h"

static ChocolateInterstitialAd *interstitial = nil;
static ChocolateRewardedAd *reward = nil;
static ChocolateBannerAd *banner = nil;
static ChocolateBannerAd *smallBanner = nil;
static ChocolatePrerollAd *preroll = nil;

static UIAlertController *rewardAlert = nil;
static UIViewController *fullscreenAdContainer = nil;


@implementation ViewController (ChocolateAd)

-(void)loadInterstitialAd {
    interstitial = [[ChocolateInterstitialAd alloc] initWithDelegate:self];
    [interstitial load];
}

-(void)showInterstitialAd {
    [interstitial showFrom:self];
}

-(void)loadRewardAd {
    reward = [[ChocolateRewardedAd alloc] initWithDelegate:self];
    ChocolateAdLoadingState state = reward.adState;
    if(state == ChocolateAdReadyToLoad ||
       state == ChocolateAdFailedToLoad) {
        [reward load];
    } else if(state == ChocolateAdLoading) {
        NSLog(@"REWD is loading...");
    }
}

-(void)showRewardAd {
    ChocolateReward *rew = [ChocolateReward blankReward];
    rew.rewardName = @"Coins";
    rew.rewardAmount = 1000;
    reward.reward = rew;
    [reward showFrom:self];
}

-(void)loadBannerAd {
    adTypeLoadedStates[2] = @NO;
    [self adjustUIForAdState];
    [banner close];
    banner = nil;
    [smallBanner close];
    smallBanner = nil;
    banner = [[ChocolateBannerAd alloc] initWithDelegate:self];
    [banner load];
}

-(void)showBannerAd {
    adTypeLoadedStates[2] = @NO;
    [self adjustUIForAdState];
    [banner showIn:inviewAdContainer at:[self.view convertPoint:inviewAdContainer.center toView:inviewAdContainer]];
}

-(void)loadPrerollAd {
    preroll = [[ChocolatePrerollAd alloc] initWithDelegate:self];
    [preroll load];
}

-(void)showPrerollAd {
    adTypeLoadedStates[3] = @NO;
    [self adjustUIForAdState];
    [publisherVideo.player pause];
    if(prerollFullscreenToggle.on) {
        fullscreenAdContainer = [[UIViewController alloc] init];
        fullscreenAdContainer.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:fullscreenAdContainer animated:YES completion:^{
            [preroll showIn:fullscreenAdContainer.view at:fullscreenAdContainer.view.center];
        }];
    } else {
        [preroll showOnPlayer:publisherVideo];
    }
}

-(void)loadSmallBannerAd {
    adTypeLoadedStates[4] = @NO;
    [self adjustUIForAdState];
    [smallBanner close];
    smallBanner = nil;
    [banner close];
    banner = nil;
    smallBanner = [[ChocolateBannerAd alloc] initWithDelegate:self];
    smallBanner.size = ChocolateBanner320x50;
    [smallBanner load];
}

-(void)showSmallBannerAd {
    adTypeLoadedStates[4] = @NO;
    [self adjustUIForAdState];
    [smallBanner showIn:inviewAdContainer at:[self.view convertPoint:inviewAdContainer.center toView:inviewAdContainer]];
}


#pragma mark - helpers

-(NSString *)extractAdType:(ChocolateAd *)ad {
    return [[NSStringFromClass(ad.class)
             stringByReplacingOccurrencesOfString:@"Chocolate" withString:@""]
            stringByReplacingOccurrencesOfString:@"Ad" withString:@""];
}

-(NSInteger)extractAdIndex:(ChocolateAd *)ad {
    if(ad == interstitial) {
        return 0;
    } else if (ad == reward) {
        return 1;
    } else if (ad == banner) {
        return 2;
    } else if (ad == preroll) {
        return 3;
    } else if(ad == smallBanner) {
        return 4;
    }
    
    return -1; //invalid ad unit
}

#pragma mark - ChocolateAdDelegate

- (void)onChocolateAdClosed:(nonnull ChocolateAd *)ad {
    ad.delegate = nil; //stop receiving callbacks from this ad
    NSLog(@"%@: dismissed %@ ad", appName, [self extractAdType:ad]);
    adTypeLoadedStates[[self extractAdIndex:ad]] = @NO;
    [self adjustUIForAdState];
    
    if(rewardAlert) {
        [self presentViewController:rewardAlert animated:YES completion:nil];
    }
    
    if([ad isKindOfClass:[ChocolatePrerollAd class]]) {
        if(fullscreenAdContainer) {
            [fullscreenAdContainer dismissViewControllerAnimated:YES completion:^{
                [self->publisherVideo.player play];
                fullscreenAdContainer = nil;
            }];
        } else {
            [publisherVideo.player play];
        }
    }
}

- (void)onChocolateAdLoadFailed:(nonnull ChocolateAd *)ad because:(ChocolateAdNoAdReason)reason {
    ad.delegate = nil; //stop receiving callbacks from this ad
    NSLog(@"%@: failed to load %@ ad", appName, [self extractAdType:ad]);
    adTypeLoadedStates[[self extractAdIndex:ad]] = @NO;
    [self adjustUIForAdState];
}

- (void)onChocolateAdLoaded:(nonnull ChocolateAd *)ad {
    NSLog(@"%@: loaded %@ ad", appName, [self extractAdType:ad]);
    adTypeLoadedStates[[self extractAdIndex:ad]] = @YES;
    [self adjustUIForAdState];
}

- (void)onChocolateAdShown:(nonnull ChocolateAd *)ad {
    NSLog(@"%@: shown %@ ad", appName, [self extractAdType:ad]);
}

-(void)onChocolateAdClicked:(ChocolateAd *)ad {
    NSLog(@"%@: %@ ad clicked", appName, [self extractAdType:ad]);
}

-(void)onChocolateAdFailedToStart:(ChocolateAd *)ad because:(ChocolateAdNoAdReason)reason {
    ad.delegate = nil; //stop receiving callbacks from this ad
    NSLog(@"%@: %@ ad failed to play: %ld", appName, [self extractAdType:ad], reason);
    if([ad isKindOfClass:[ChocolatePrerollAd class]]) {
        [publisherVideo.player play];
    }
}

-(void)onChocolateAdReward:(NSString *)rewardName amount:(NSInteger)rewardAmount {
    rewardAlert = [UIAlertController alertControllerWithTitle:@"Reward Ad Done!" message:[NSString stringWithFormat:@"You've received %ld %@!", rewardAmount, rewardName] preferredStyle:UIAlertControllerStyleAlert];
    [rewardAlert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
        rewardAlert = nil;
    }]];
}

@end
