//
//  NDViewController.h
//  WebVideo
//
//  Created by user on 8/6/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ALWebVideoView.h"

@class ALWebVideoView;
@class ALWebMoviePlayer;

@interface NDViewController : UIViewController <ALWebVideoDelegate>

@property (strong) ALWebMoviePlayer* moviePlayer;
@property (strong) ALWebVideoView* videoView;

@property (strong, nonatomic) IBOutlet UIButton *button;

- (IBAction)triggerButton:(id)sender;

@end
