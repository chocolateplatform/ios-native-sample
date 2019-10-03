//
//  ViewController+ChocolateInterstitial.h
//  ChocolateOBJCSample
//
//  Created by Lev Trubov on 10/3/19.
//  Copyright © 2019 Lev Trubov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ViewController.h"
@import ChocolatePlatform_SDK_Core;

NS_ASSUME_NONNULL_BEGIN

@interface ViewController (ChocolateInterstitial) <ChocolatePlatformInterstitialAdDelegate>

-(void)loadInterstitialAd;
-(void)showInterstitialAd;

@end

NS_ASSUME_NONNULL_END
