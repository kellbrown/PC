//
//  WebViewController.h
//  PC
//
//  Created by Kelly Brown on 2018-04-09.
//  Copyright © 2018 Kelly Brown. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController <UIWebViewDelegate> {
    UIWebView *webView;
    UIActivityIndicatorView *spinner;
}

@property (strong, nonatomic) NSString *link;
@end
