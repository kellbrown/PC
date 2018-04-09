//
//  WebViewController.m
//  PC
//
//  Created by Kelly Brown on 2018-04-09.
//  Copyright © 2018 Kelly Brown. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.navigationController.navigationBar.translucent = false;

    webView = [[UIWebView alloc] init];
    webView.translatesAutoresizingMaskIntoConstraints = false;
    webView.delegate = self;
    [webView setScalesPageToFit: true];
    [self.view addSubview: webView];
     webView.backgroundColor = UIColor.yellowColor;
    [[webView topAnchor] constraintEqualToAnchor: self.view.topAnchor].active = true;
    [[webView leadingAnchor] constraintEqualToAnchor: self.view.leadingAnchor].active = true;
    [[webView trailingAnchor] constraintEqualToAnchor: self.view.trailingAnchor].active = true;
    [[webView bottomAnchor] constraintEqualToAnchor: self.view.bottomAnchor].active = true;

    
    NSURL *url = [[NSURL alloc] initWithString: _link];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadRevalidatingCacheData timeoutInterval:30.0];
    
    [webView loadRequest:request];
}

-(void)setLink:(NSString *)link {
    _link = [[link stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] stringByAppendingString: @"?displayMobileNavigation=0"];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    if( spinner == nil ) {
        spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        spinner.translatesAutoresizingMaskIntoConstraints = false;
        [self.view addSubview:spinner];
        
        [[spinner centerXAnchor] constraintEqualToAnchor: self.view.centerXAnchor].active = true;
        [[spinner centerYAnchor] constraintEqualToAnchor: self.view.centerYAnchor].active = true;
        
        [spinner startAnimating];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [spinner stopAnimating];
    
    [spinner removeFromSuperview];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"%@", error.debugDescription);
}

@end
