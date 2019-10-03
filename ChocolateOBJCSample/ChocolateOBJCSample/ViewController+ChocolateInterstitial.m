//
//  ViewController+ChocolateInterstitial.m
//  ChocolateOBJCSample
//
//  Created by Lev Trubov on 10/3/19.
//  Copyright © 2019 Lev Trubov. All rights reserved.
//

#import "ViewController+ChocolateInterstitial.h"

static ChocolatePlatformInterstitialAdDisplay *ad = nil;

@implementation ViewController (ChocolateInterstitial) 

-(void)loadInterstitialAd {
    ad = [[ChocolatePlatformInterstitialAdDisplay alloc] initWithAdUnitID:[ChocolatePlatform getAdUnitID] delegate:self];
    [ad load];
}

-(void)showInterstitialAd {
    [ad showFrom:self];
}

#pragma mark - Interstitial callbacks

- (void)onInterstitialClicked:(ChocolatePlatformInterstitialAdDisplay *)interstitialAd {
    NSLog(@"%@: clicked interstitial ad", appName);
}

- (void)onInterstitialDismissed:(ChocolatePlatformInterstitialAdDisplay *)interstitialAd {
    NSLog(@"%@: dismissed interstitial ad", appName);
    adTypeLoadedStates[0] = @NO;
    [self adjustUIForAdState];
    ad = nil;
}

- (void)onInterstitialFailed:(ChocolatePlatformInterstitialAdDisplay *)interstitialAd errorCode:(int)errorCode {
    NSLog(@"%@: failed to load interstitial ad: %d", appName, errorCode);
}

- (void)onInterstitialLoaded:(ChocolatePlatformInterstitialAdDisplay *)interstitialAd {
    NSLog(@"%@: loaded interstitial ad", appName);
    adTypeLoadedStates[0] = @YES;
    [self adjustUIForAdState];
}

- (void)onInterstitialShown:(ChocolatePlatformInterstitialAdDisplay *)interstitialAd {
    NSLog(@"%@: shown interstitial ad", appName);
}

@end
