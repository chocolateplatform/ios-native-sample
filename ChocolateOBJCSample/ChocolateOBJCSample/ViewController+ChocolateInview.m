//
//  ViewController+ChocolateInview.m
//  ChocolateOBJCSample
//
//  Created by Lev Trubov on 10/3/19.
//  Copyright © 2019 Lev Trubov. All rights reserved.
//

#import "ViewController+ChocolateInview.h"

static ChocolatePlatformInviewAdDisplay *ad = nil;

@implementation ViewController (ChocolateInview)

-(void)loadInviewAd {
    adTypeLoadedStates[2] = @NO;
    [self adjustUIForAdState];
    [ad removeFromSuperview];
    ad = nil;
    ad = [[ChocolatePlatformInviewAdDisplay alloc]
            initWithAdUnitID:[ChocolatePlatform getAdUnitID]
            size:adSizeInView
            delegate:self];
    [ad loadAd];
}

-(void)showInviewAd {
    adTypeLoadedStates[2] = @NO;
    [self adjustUIForAdState];
    [ad showIn:inviewAdContainer at:[self.view convertPoint:inviewAdContainer.center toView:inviewAdContainer]];
}

#pragma mark - banner ad view delegate

- (void)onBannerAdLoaded:(ChocolatePlatformInviewAdDisplay*)banner {
    adTypeLoadedStates[2] = @YES;
    [self adjustUIForAdState];
}

- (void)onBannerAdFailed:(ChocolatePlatformInviewAdDisplay*)banner errorCode:(int)errorCode {
    adTypeLoadedStates[2] = @NO;
    [self adjustUIForAdState];
    
}
- (void)onBannerAdClicked:(ChocolatePlatformInviewAdDisplay*)banner {
    NSLog(@"Inview ad clicked");
}

- (void)onBannerAdDissmiss:(ChocolatePlatformInviewAdDisplay *)banner {
    NSLog(@"Inview ad dismiss");
    adTypeLoadedStates[2] = @NO;
    [self adjustUIForAdState];
}

@end
