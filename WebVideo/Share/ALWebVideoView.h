#import <UIKit/UIKit.h>

@protocol ALWebVideoDelegate;

@interface ALWebVideoView : UIView <UIWebViewDelegate> {
    NSString* videoStreamPath;
    
    UIWebView* webView ;
    NSString* webSite;
    
    int requestFinishCount ;
    NSDictionary* webSiteRequestCount;
    NSDictionary* webSitePlayerIDMap;
}


@property (assign) id<ALWebVideoDelegate> delegate;

-(void) loadVideoWithURLString: (NSString*)videoPath ;
-(void) loadVideoWithHTMLString: (NSString*)videohtml ;

@end

@protocol ALWebVideoDelegate <NSObject>

@optional
-(void) didTapVideoView: (NSString*)videoStreamPath ;
-(void) didSuccessGetVideoURL: (NSString*)videoStreamPath;
-(void) didFailedGetVideoURL ;
-(void) didFailedLoadVideoView: (NSError*)error;

@end


