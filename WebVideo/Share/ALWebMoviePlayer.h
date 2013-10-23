#import <Foundation/Foundation.h>

@class MPMoviePlayerController;

@interface ALWebMoviePlayer : NSObject {
    MPMoviePlayerController* moviePlayer;
}

@property (strong) UIView* view;

-(id) initWithURL: (NSString*)url ;

-(void) setURL: (NSString*)url ;
-(void) setFrame: (CGRect)frame ;
-(void) play ;

-(void) show: (UIView*)parentView ;
-(void) remove ;


@end
