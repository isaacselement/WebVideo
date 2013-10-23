#import "ALWebMoviePlayer.h"

#import <MediaPlayer/MediaPlayer.h>

@implementation ALWebMoviePlayer

@synthesize view;

- (id)init
{
    self = [super init];
    if (self) {
        moviePlayer = [[MPMoviePlayerController alloc] init];
        self.view = moviePlayer.view;
        
        moviePlayer.movieSourceType = MPMovieSourceTypeStreaming;
        [moviePlayer setControlStyle: MPMovieControlStyleDefault];
    }
    return self;
}

-(id) initWithURL: (NSString*)url {
    self = [self init];
    [self setURL: url];
    return self;
}

-(void) setURL: (NSString*)url {
    NSURL* movieURL = [NSURL URLWithString: url];
    [moviePlayer setContentURL: movieURL];
    [moviePlayer prepareToPlay];
}

-(void) play {
    [moviePlayer play];
}

-(void) setFrame: (CGRect)frame {
    view.frame = frame;
}

-(void) show: (UIView*)parentView {
    [parentView addSubview: view];
}

-(void) remove {
    [view removeFromSuperview];
}

@end
