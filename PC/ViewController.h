//
//  ViewController.h
//  PC
//
//  Created by Kelly Brown on 2018-04-04.
//  Copyright © 2018 Kelly Brown. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MarqueeView.h"
#import "FeedCollectionView.h"
#import "WebViewController.h"

@interface ViewController : UIViewController <NSXMLParserDelegate, UICollectionViewDelegate> {
    NSString *channelTitle;
    
    NSMutableArray *items;
    NSMutableDictionary *itemDictionary;
    
    NSString *title;
    NSString *link;
    NSString *pubDate;
    NSString *description;
    NSString *mediaContent;
    NSString *mediaUrl;
    
    NSString *currentElement;
    NSMutableString *foundValue;
    
    BOOL parseItems;
    
    MarqueeView *marqueeView;
    UILabel *marqueeDescription;
    UILabel *previewArticlesLbl;
    FeedCollectionView *feedCollectionView;
}

@end

