//
//  ViewController.m
//  ChocolateOBJCSample
//
//  Created by Lev Trubov on 9/30/19.
//  Copyright © 2019 Lev Trubov. All rights reserved.
//

#import "ViewController.h"
#import "ViewController+ChocolateInterstitial.h"
#import "ViewController+ChocolateReward.h"
#import "ViewController+ChocolateInview.h"
#import "ViewController+ChocolatePreroll.h"

static NSString *CONTENT = @"https://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_30mb.mp4";

@interface ViewController () <UIPickerViewDataSource, UIPickerViewDelegate> {
    UILabel *prompt;
    UIPickerView *adTypePicker;
    NSArray *adTypes;
    
    UIButton *loadButton, *showButton;
    UILabel *prerollFullscreenPrompt;
    
    UILabel *inviewAdPrompt;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
    adTypeLoadedStates = [@[@NO,@NO,@NO,@NO] mutableCopy];
    
    adTypes = @[@"Interstitial", @"Rewarded", @"Inview", @"Preroll"];
    
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.whiteColor;
    self.title = @"Chocolate";
    
    prompt = [[UILabel alloc] init];
    prompt.font = [UIFont preferredFontForTextStyle:UIFontTextStyleTitle3];
    prompt.text = @"Ad Type:";
    [prompt sizeToFit];
    [self.view addSubview:prompt];
    prompt.translatesAutoresizingMaskIntoConstraints = NO;
    if (@available(iOS 11.0, *)) {
        [prompt.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:20].active = YES;
    } else {
        [prompt.topAnchor constraintEqualToAnchor:self.topLayoutGuide.topAnchor].active = YES;
    }
    [prompt.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:10].active = YES;
    
    adTypePicker = [[UIPickerView alloc] init];
    adTypePicker.dataSource = self;
    adTypePicker.delegate = self;
    [self.view addSubview: adTypePicker];
    adTypePicker.translatesAutoresizingMaskIntoConstraints = NO;
    [adTypePicker.centerYAnchor constraintEqualToAnchor:prompt.centerYAnchor].active = YES;
    [adTypePicker.leftAnchor constraintEqualToAnchor:prompt.rightAnchor constant:20].active = YES;
    
    publisherVideo = [[AVPlayerViewController alloc] init];
    publisherVideo.player = [AVPlayer playerWithURL:[self sampleContentVideo]];
    [self.view addSubview:publisherVideo.view];
    publisherVideo.view.translatesAutoresizingMaskIntoConstraints = NO;
    if (@available(iOS 11.0, *)) {
        [publisherVideo.view.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor].active = YES;
    } else {
        [publisherVideo.view.bottomAnchor constraintEqualToAnchor:self.topLayoutGuide.bottomAnchor].active = YES;
    }
    [publisherVideo.view.widthAnchor constraintEqualToAnchor:self.view.widthAnchor].active = YES;
    [publisherVideo.view.heightAnchor constraintEqualToAnchor:publisherVideo.view.widthAnchor multiplier:0.5625].active = YES; //9:16 aspect ratio
    
    publisherVideo.player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    publisherVideo.showsPlaybackControls = NO;
        
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(mainContentDone:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:[publisherVideo.player currentItem]];
    
    loadButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [loadButton setTitle:@"Load" forState:UIControlStateNormal];
    [loadButton.titleLabel setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleTitle1]];
    [loadButton addTarget:self action:@selector(loadSelectedAdType:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loadButton];
    loadButton.translatesAutoresizingMaskIntoConstraints = NO;
    [loadButton.leftAnchor constraintEqualToAnchor:prompt.leftAnchor].active = YES;
    [loadButton.topAnchor constraintEqualToAnchor:adTypePicker.bottomAnchor constant:20].active = YES;
    
    showButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [showButton setTitle:@"Show" forState:UIControlStateNormal];
    showButton.enabled = NO;
    [showButton.titleLabel setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleTitle1]];
    [showButton addTarget:self action:@selector(showSelectedAdType:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:showButton];
    showButton.translatesAutoresizingMaskIntoConstraints = NO;
    [showButton.leftAnchor constraintEqualToAnchor:loadButton.rightAnchor constant:20].active = YES;
    [showButton.topAnchor constraintEqualToAnchor:adTypePicker.bottomAnchor constant:20].active = YES;
    
    prerollFullscreenToggle = [[UISwitch alloc] init];
    [self.view addSubview:prerollFullscreenToggle];
    prerollFullscreenToggle.translatesAutoresizingMaskIntoConstraints = NO;
    [prerollFullscreenToggle.centerYAnchor constraintEqualToAnchor:showButton.centerYAnchor].active = YES;
    [prerollFullscreenToggle.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-10].active = YES;
    
    prerollFullscreenPrompt = [[UILabel alloc] init];
    prerollFullscreenPrompt.font = [UIFont preferredFontForTextStyle:UIFontTextStyleTitle3];
    prerollFullscreenPrompt.text = @"Fullscreen";
    [prerollFullscreenPrompt sizeToFit];
    [self.view addSubview:prerollFullscreenPrompt];
    prerollFullscreenPrompt.translatesAutoresizingMaskIntoConstraints = NO;
    [prerollFullscreenPrompt.centerYAnchor constraintEqualToAnchor:prerollFullscreenToggle.centerYAnchor].active = YES;
    [prerollFullscreenPrompt.trailingAnchor constraintEqualToAnchor:prerollFullscreenToggle.leadingAnchor constant:-20].active = YES;
    
    prerollFullscreenPrompt.hidden = YES;
    prerollFullscreenToggle.hidden = YES;
    
    inviewAdContainer = [[UIView alloc] init];
    inviewAdContainer.backgroundColor = UIColor.lightGrayColor;
    [self.view addSubview:inviewAdContainer];
    inviewAdContainer.translatesAutoresizingMaskIntoConstraints = NO;
    [inviewAdContainer.topAnchor constraintEqualToAnchor:loadButton.bottomAnchor constant:10].active = YES;
    [inviewAdContainer.bottomAnchor constraintEqualToAnchor:publisherVideo.view.topAnchor constant:-10].active = YES;
    [inviewAdContainer.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    [inviewAdContainer.widthAnchor constraintEqualToAnchor:self.view.widthAnchor].active = YES;
    
    inviewAdPrompt = [[UILabel alloc] init];
    inviewAdPrompt.font = [UIFont preferredFontForTextStyle:UIFontTextStyleTitle3];
    inviewAdPrompt.text = @"Inview ad:";
    [inviewAdPrompt sizeToFit];
    [inviewAdContainer addSubview:inviewAdPrompt];
    inviewAdPrompt.translatesAutoresizingMaskIntoConstraints = NO;
    [inviewAdPrompt.leadingAnchor constraintEqualToAnchor:inviewAdContainer.leadingAnchor constant:10].active = YES;
    [inviewAdPrompt.topAnchor constraintEqualToAnchor:inviewAdPrompt.topAnchor constant:10].active = YES;
    
    prerollFullscreenPrompt.hidden = YES;
    prerollFullscreenToggle.hidden = YES;
    publisherVideo.view.hidden = YES;
    
    inviewAdContainer.hidden = YES;
}

#pragma mark - Picker Data Source

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 4;
}

#pragma mark - Picker Delegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return adTypes[row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if([adTypes[row] isEqualToString:@"Preroll"]) {
        prerollFullscreenPrompt.hidden = NO;
        prerollFullscreenToggle.hidden = NO;
        publisherVideo.view.hidden = NO;
        [publisherVideo.player play];
    } else {
        prerollFullscreenPrompt.hidden = YES;
        prerollFullscreenToggle.hidden = YES;
        [publisherVideo.player pause];
        publisherVideo.view.hidden = YES;
    }
    
    if([adTypes[row] isEqualToString:@"Inview"]) {
        inviewAdContainer.hidden = NO;
    } else {
        inviewAdContainer.hidden = YES;
    }
    
    [self adjustUIForAdState];
}

#pragma mark - Publisher content

-(NSURL *)sampleContentVideo {
    NSURL *local = [[NSBundle mainBundle] URLForResource:@"bunny" withExtension:@"mp4"];
    return local ? local : [NSURL URLWithString:CONTENT];
}

- (void)mainContentDone:(NSNotification *)notification {
    AVPlayerItem *p = [notification object];
    [p seekToTime:kCMTimeZero];
}

#pragma mark - button actions

-(void)loadSelectedAdType:(id)sender {
    NSString *adType = adTypes[[adTypePicker selectedRowInComponent:0]];
    
    if([adType isEqualToString:@"Interstitial"]) {
        [self loadInterstitialAd];
    } else if([adType isEqualToString:@"Rewarded"]) {
        [self loadRewardAd];
    } else if([adType isEqualToString:@"Inview"]) {
        [self loadInviewAd];
    } else if([adType isEqualToString:@"Preroll"]) {
        [self loadPrerollAd];
    }
}

-(void)showSelectedAdType:(id)sender {
    NSString *adType = adTypes[[adTypePicker selectedRowInComponent:0]];

    if([adType isEqualToString:@"Interstitial"]) {
        [self showInterstitialAd];
    } else if([adType isEqualToString:@"Rewarded"]) {
        [self showRewardAd];
    }else if([adType isEqualToString:@"Inview"]) {
        [self showInviewAd];
    } else if([adType isEqualToString:@"Preroll"]) {
        [self showPrerollAd];
    }
}

#pragma mark - UI correctness

-(void)adjustUIForAdState {
    BOOL relevantAdTypeState = [adTypeLoadedStates[[adTypePicker selectedRowInComponent:0]] boolValue];
    showButton.enabled = relevantAdTypeState;
}

@end
