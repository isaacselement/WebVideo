#import "ALWebVideoView.h"
#import <QuartzCore/QuartzCore.h>

#define YOUKU @"youku.com"
#define IDPlayerYOUKU @"player"

#define TODOU @"tudou.com"
#define IDPlayViewTODOU @"playView"

#define FXDOTCOM @"56.com"
#define IDVideoLayerFXDOTCOM @"videoLayer"

#define FENGHUANG @"ifeng.com"
#define IDVideoJSFENGHUANG @"js_video"

#define SINACOM @"sina.com"
#define IDPlayerSINACOM @"video-box"

@implementation ALWebVideoView

@synthesize delegate;

- (id)init {
    self = [super init];
    if (self) {
        self.layer.borderWidth = 1.0f;
        self.layer.borderColor = [[UIColor blueColor] CGColor];
        webView = [[UIWebView alloc] init];
        webView.delegate = self;
        webView.hidden = YES;
        webView.userInteractionEnabled = NO;
        [self addSubview: webView];
        
        [self initConfig];
        
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
        [self addGestureRecognizer:tapRecognizer];
        
    }
    return self;
}

-(void) initConfig {
    webSiteRequestCount = [NSDictionary dictionaryWithObjectsAndKeys:
                        [NSNumber numberWithInt: 2], YOUKU,
                        [NSNumber numberWithInt: 2], TODOU,
                        [NSNumber numberWithInt: 1], FXDOTCOM,
                        [NSNumber numberWithInt: 1], FENGHUANG,
                        [NSNumber numberWithInt: 1], SINACOM,
                        nil];
    webSitePlayerIDMap = [NSDictionary dictionaryWithObjectsAndKeys:
                              IDPlayerYOUKU, YOUKU,
                              IDPlayViewTODOU, TODOU,
                              IDVideoLayerFXDOTCOM, FXDOTCOM,
                              IDVideoJSFENGHUANG, FENGHUANG,
                              IDPlayerSINACOM, SINACOM,
                          nil];
}

-(void) loadVideoWithURLString: (NSString*)videoPath {
    requestFinishCount = 0;
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:videoPath]];
    [webView loadRequest: request];
    
    // youku: player , tudou: playView
    if ([videoPath rangeOfString: YOUKU].location != NSNotFound) {
        webSite = YOUKU;
    } else if ([videoPath rangeOfString: TODOU].location != NSNotFound) {
        webSite = TODOU;
    } else if ([videoPath rangeOfString: FXDOTCOM].location != NSNotFound) {
        webSite = FXDOTCOM;
    } else if ([videoPath rangeOfString: FENGHUANG].location != NSNotFound) {
        webSite = FENGHUANG;
    } else if ([videoPath rangeOfString: SINACOM].location != NSNotFound) {
        webSite = SINACOM;
    }
}

-(void) loadVideoWithHTMLString: (NSString*)videohtml {
    [webView loadHTMLString: videohtml baseURL:nil];
}


-(void) tapAction {
    if (delegate && [delegate respondsToSelector: @selector(didTapVideoView:)]) {
        [delegate didTapVideoView: videoStreamPath];
    }
}


#pragma mark - Override Methods

-(void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    webView.frame = frame;
    CGRect rect = CGRectMake(0, 0, frame.size.width, frame.size.height);
    CGFloat x = CGRectGetMidX(rect);
    CGFloat y = CGRectGetMidY(rect);
    webView.center = CGPointMake(x, y);
}


#pragma mark - UIWebViewDelegate Methods

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSLog(@"start load request %@", [[request URL] absoluteString]);
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"start !");
}

- (void)webViewDidFinishLoad:(UIWebView *)webViewObj {
    requestFinishCount++;
    
    NSLog(@"finish !");
//    NSString *allHtmlContents = [webViewObj stringByEvaluatingJavaScriptFromString:@"document.documentElement.innerHTML"];
//    NSLog(@"all Contents: %@", allHtmlContents);
//    [self cutVideoHTML: allHtmlContents webViewObj:webViewObj];
    
    [self hideHtmlElement: webViewObj excepID: [webSitePlayerIDMap objectForKey: webSite]];
    [self fitToView: webViewObj onID: [webSitePlayerIDMap objectForKey: webSite]];
    [self getVideoStream: webViewObj];

    if ((!videoStreamPath || [videoStreamPath isEqualToString: @""]) && [[webSiteRequestCount objectForKey: webSite] intValue] <= requestFinishCount) {
        NSLog(@"Fail to get video url");
        if (delegate && [delegate respondsToSelector: @selector(didFailedGetVideoURL)]) {
            [delegate didFailedGetVideoURL];
        }
    }
}

- (void)webView:(UIWebView *)webViewObj didFailLoadWithError:(NSError *)error {
    if (delegate && [delegate respondsToSelector: @selector(didFailedLoadVideoView:)]) {
        [delegate didFailedLoadVideoView: error];
    }
}


#pragma mark - Utilties Methods
-(void) getVideoStream:(UIWebView *)webViewObj {
    NSString *jsSource = @"(document.getElementsByTagName(\"video\")[0]).src";
    if ([webSite isEqualToString: SINACOM]) jsSource = @"(document.getElementById(\"video-hlv\")).src";
    
    NSString* m3u8ResourcePath = [webViewObj stringByEvaluatingJavaScriptFromString:jsSource];
    if (m3u8ResourcePath && ![m3u8ResourcePath isEqualToString:@""]) {
        videoStreamPath = m3u8ResourcePath;
        NSLog(@"video stream source:%@",videoStreamPath);
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void){
            webView.hidden = NO;
        });
        if (delegate && [delegate respondsToSelector: @selector(didSuccessGetVideoURL:)]) {
            [delegate didSuccessGetVideoURL: videoStreamPath];
        }
    }
}

-(void) hideHtmlElement: (UIWebView *)webViewObj excepID:(NSString*)idName {
    NSString* hideJSFormat =
    @"function hideAllExcept(id) {\
        var el = document.getElementById(id);\
        while (el && el != document.body) {\
            var parent = el.parentNode;\
            var siblings = parent.childNodes;\
            for (var i = 0, len = siblings.length; i < len; i++) {\
                if (siblings[i] != el && siblings[i].nodeType == 1) {\
                    siblings[i].style.display = \"none\";\
                }\
            }\
            el = parent;\
        }\
    }\
    hideAllExcept(\"%@\");";
    
    NSString* hideJS = [NSString stringWithFormat: hideJSFormat, idName];
    [webViewObj stringByEvaluatingJavaScriptFromString:hideJS];
}

-(void) fitToView: (UIWebView *)webViewObj onID:(NSString*)idName {
    NSString* fitJSFormat =
    @"var el = document.getElementById(\"%@\");\
        el.style.height = \"%fpx\";\
        el.style.width = \"%fpx\";\
    ";
    NSString* fitJS = [NSString stringWithFormat: fitJSFormat, idName, self.frame.size.height,self.frame.size.width];
    [webViewObj stringByEvaluatingJavaScriptFromString:fitJS];
}

@end
