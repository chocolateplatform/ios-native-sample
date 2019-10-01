//
//  ViewController.m
//  ChocolateOBJCSample
//
//  Created by Lev Trubov on 9/30/19.
//  Copyright © 2019 Lev Trubov. All rights reserved.
//

#import "ViewController.h"
@import AVKit;

static NSString *CONTENT = @"https://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_30mb.mp4";

@interface ViewController () <UIPickerViewDataSource, UIPickerViewDelegate> {
    UILabel *prompt;
    UIPickerView *adTypePicker;
    NSArray *adTypes;
    
    UIButton *loadButton, *showButton;
    UILabel *prerollFullscreenPrompt;
    UISwitch *prerollFullscreenToggle;
    
    AVPlayerViewController *publisherVideo;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
}

-(void)viewDidAppear:(BOOL)animated {
    [publisherVideo.player play];
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

#pragma mark - Publisher content

-(NSURL *)sampleContentVideo {
    NSURL *local = [[NSBundle mainBundle] URLForResource:@"bunny" withExtension:@"mp4"];
    return local ? local : [NSURL URLWithString:CONTENT];
}

- (void)mainContentDone:(NSNotification *)notification {
    AVPlayerItem *p = [notification object];
    [p seekToTime:kCMTimeZero];
}

@end
