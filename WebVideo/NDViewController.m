//
//  NDViewController.m
//  WebVideo
//
//  Created by user on 8/6/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import "NDViewController.h"

#import "ALWebMoviePlayer.h"
#import "ALWebVideoView.h"

@interface NDViewController ()

@end

@implementation NDViewController

@synthesize moviePlayer;
@synthesize videoView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    videoView = [[ALWebVideoView alloc] init];
    videoView.frame = CGRectMake(50, 50, 200, 200);
    videoView.delegate = self;
    [self.view addSubview:videoView];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)triggerButton:(id)sender {
    [self viewMovieAction];
}


-(void) viewMovieAction {
    NSString* url = @"http://v.youku.com/v_show/id_XNTg5NDY1NzAw_ev_1.html";
//    NSString* url = @"http://www.tudou.com/albumplay/MgWfoV9cT4E.html";
//    NSString* url = @"http://m.56.com/view/id-OTQ4MDgxNjA.html";
//    NSString* url = @"http://v.ifeng.com/v/hwdd2311/index.shtml#105b3ef7-db42-4347-9ba2-e632fba8ece1";
    
//    NSString* url = @"http://video.sina.com.cn/p/news/c/v/2013-08-06/083262752839.html";
    
    [videoView loadVideoWithURLString: url];
}

#pragma mark - ALWebVideoDelegate Methods
-(void) didTapVideoView: (NSString*)videoStreamPath {
    NSLog(@"View Movie");
    
    if (!moviePlayer)moviePlayer = [[ALWebMoviePlayer alloc] init];
    [moviePlayer setFrame: CGRectMake(50, 50, 200, 200)];
    [moviePlayer show: self.view];
    [moviePlayer setURL: videoStreamPath];
    [moviePlayer play];
}
-(void) didSuccessGetVideoURL: (NSString*)videoStreamPath{}
-(void) didFailedGetVideoURL {}
-(void) didFailedLoadVideoView: (NSError*)error{}

@end
