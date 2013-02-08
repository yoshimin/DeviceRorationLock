//
//  YSViewController.m
//  RotationLock
//
//  Created by Shingai Yoshimi on 2/8/13.
//  Copyright (c) 2013 Shingai Yoshimi. All rights reserved.
//

#import "YSViewController.h"

typedef enum {
	BUTTON_RELOAD,
	BUTTON_STOP,
} ToolbarButton;

@interface YSViewController ()

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) NSURL *url;

@property (nonatomic, strong) UIToolbar* toolbar;

@property (nonatomic, strong) UIBarButtonItem *backButton;
@property (nonatomic, strong) UIBarButtonItem *forwardButton;
@property (nonatomic, strong) UIBarButtonItem *actionButton;

@end

@implementation YSViewController


//★─☆｡oﾟ｡★─☆｡oﾟ｡★─☆｡oﾟ｡★─☆｡oﾟ｡★─☆｡oﾟ｡★─☆｡oﾟ｡★─☆｡oﾟ｡★─☆｡oﾟ｡★─☆｡oﾟ｡★─☆｡oﾟ｡★//
#pragma mark -- Initialize --
//★─☆｡oﾟ｡★─☆｡oﾟ｡★─☆｡oﾟ｡★─☆｡oﾟ｡★─☆｡oﾟ｡★─☆｡oﾟ｡★─☆｡oﾟ｡★─☆｡oﾟ｡★─☆｡oﾟ｡★─☆｡oﾟ｡★//

- (id) initWithURL:(NSURL *)url {
    
    if ( self = [super init] ) {
        self.backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back.png"]
                                                           style:UIBarButtonItemStylePlain
                                                          target:self
                                                          action:@selector(goBack)];
        
        self.forwardButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"forward.png"]
                                                              style:UIBarButtonItemStylePlain
                                                             target:self
                                                             action:@selector(goForward)];
        
        self.actionButton = [[UIBarButtonItem	alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                          target:self
                                                                          action:@selector(doAction)];
        
        
        _toolbar = [UIToolbar new];
        _toolbar.barStyle  = UIBarStyleDefault;
        
        _toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        _toolbar.barStyle = UIBarStyleBlackTranslucent;
        _toolbar.frame = CGRectMake(0, self.view.frame.size.height - 44, self.view.frame.size.width, 44);
        
        self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        _webView.delegate = self;
        _webView.scalesPageToFit = YES;
        _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        url = [url copy];
        
        [self.view addSubview:_webView];
        [self.view addSubview:_toolbar];
        
        
        UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        NSArray *items = [NSArray arrayWithObjects: flexItem, _backButton, flexItem, flexItem, flexItem, _forwardButton,
                          flexItem, flexItem, flexItem, flexItem, flexItem, flexItem,
                          _actionButton, flexItem, flexItem, flexItem, _actionButton, flexItem, nil];
        [_toolbar setItems:items animated:NO];
        
        [_webView loadRequest:[NSURLRequest requestWithURL:url]];
    }
    
    return self;
}


//★─☆｡oﾟ｡★─☆｡oﾟ｡★─☆｡oﾟ｡★─☆｡oﾟ｡★─☆｡oﾟ｡★─☆｡oﾟ｡★─☆｡oﾟ｡★─☆｡oﾟ｡★─☆｡oﾟ｡★─☆｡oﾟ｡★//
#pragma mark -- View Lifesycle --
//★─☆｡oﾟ｡★─☆｡oﾟ｡★─☆｡oﾟ｡★─☆｡oﾟ｡★─☆｡oﾟ｡★─☆｡oﾟ｡★─☆｡oﾟ｡★─☆｡oﾟ｡★─☆｡oﾟ｡★─☆｡oﾟ｡★//

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}


//★─☆｡oﾟ｡★─☆｡oﾟ｡★─☆｡oﾟ｡★─☆｡oﾟ｡★─☆｡oﾟ｡★─☆｡oﾟ｡★─☆｡oﾟ｡★─☆｡oﾟ｡★─☆｡oﾟ｡★─☆｡oﾟ｡★//
#pragma mark -- WebView --
//★─☆｡oﾟ｡★─☆｡oﾟ｡★─☆｡oﾟ｡★─☆｡oﾟ｡★─☆｡oﾟ｡★─☆｡oﾟ｡★─☆｡oﾟ｡★─☆｡oﾟ｡★─☆｡oﾟ｡★─☆｡oﾟ｡★//

- (BOOL)webView:(UIWebView *)aWebView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return true;
}

- (void)webViewDidStartLoad:(UIWebView *)aWebView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self updateToolbar:BUTTON_STOP];
}

- (void)webViewDidFinishLoad:(UIWebView *)aWebView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    self.title = [aWebView stringByEvaluatingJavaScriptFromString:@"document.title"];
    [self updateToolbar:BUTTON_RELOAD];
    self.url = aWebView.request.mainDocumentURL;
}

- (void)webView:(UIWebView *)aWebView didFailLoadWithError:(NSError *)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

-(void)updateToolbar:(ToolbarButton)button
{
    NSMutableArray *items = [_toolbar.items mutableCopy];
    UIBarButtonItem *newItem;
    
    if (button == BUTTON_STOP) {
        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [activityView startAnimating];
        newItem = [[UIBarButtonItem alloc] initWithCustomView:activityView];
    }
    else {
        newItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reload)];
    }
    
    [items replaceObjectAtIndex:12 withObject:newItem];
    [_toolbar setItems:items animated:false];
    
    // workaround to change toolbar state
    _backButton.enabled = true;
    _forwardButton.enabled = true;
    _backButton.enabled = false;
    _forwardButton.enabled = false;
    
    _backButton.enabled = (_webView.canGoBack) ? true : false;
    _forwardButton.enabled = (_webView.canGoForward) ? true : false;
}


//★─☆｡oﾟ｡★─☆｡oﾟ｡★─☆｡oﾟ｡★─☆｡oﾟ｡★─☆｡oﾟ｡★─☆｡oﾟ｡★─☆｡oﾟ｡★─☆｡oﾟ｡★─☆｡oﾟ｡★─☆｡oﾟ｡★//
#pragma mark -- WebViewActions --
//★─☆｡oﾟ｡★─☆｡oﾟ｡★─☆｡oﾟ｡★─☆｡oﾟ｡★─☆｡oﾟ｡★─☆｡oﾟ｡★─☆｡oﾟ｡★─☆｡oﾟ｡★─☆｡oﾟ｡★─☆｡oﾟ｡★//

- (void)reload {
    
    [_webView reload];
    [self updateToolbar:BUTTON_STOP];
}

- (void)stop {
    
    [_webView stopLoading];
    [self updateToolbar:BUTTON_RELOAD];
}

- (void) goBack {
    
    [_webView goBack];
}

- (void) goForward {
    
    [_webView goForward];
}

- (void) doAction {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:[self.url absoluteString]
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Open with Safari", nil];
    
    [actionSheet showInView:self.navigationController.view];
}

- (void)actionSheet:(UIActionSheet *)as clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (as.cancelButtonIndex == buttonIndex) return;
    
    if (buttonIndex == 0) {
        [[UIApplication sharedApplication] openURL:self.url];
    }
}


@end
