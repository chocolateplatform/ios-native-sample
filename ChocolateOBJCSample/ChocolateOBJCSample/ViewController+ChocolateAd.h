//
//  ViewController+ChocolateAd.h
//  ChocolateOBJCSample
//
//  Created by Lev Trubov on 11/8/19.
//  Copyright © 2019 Lev Trubov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ViewController.h"
@import ChocolatePlatform_SDK_Core;

NS_ASSUME_NONNULL_BEGIN

@interface ViewController (ChocolateAd) <ChocolateAdDelegate>

-(void)loadInterstitialAd;
-(void)showInterstitialAd;
-(void)loadRewardAd;
-(void)showRewardAd;
-(void)loadBannerAd;
-(void)showBannerAd;
-(void)loadSmallBannerAd;
-(void)showSmallBannerAd;
-(void)loadPrerollAd;
-(void)showPrerollAd;

@end

NS_ASSUME_NONNULL_END
