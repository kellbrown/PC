//
//  FeedView.h
//  PC
//
//  Created by Kelly Brown on 2018-04-08.
//  Copyright © 2018 Kelly Brown. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    marquee,
    feed
} FeedType;

@interface FeedView : UIView {
    UIImageView *imageView;
    UILabel *articleTitleLbl;
    
    CGFloat labelMargin;
    
    UIActivityIndicatorView *spinner;
}

@property (strong, nonatomic) NSDictionary *itemDictionary;
@property (nonatomic) FeedType feedType;

- (id)initWithItemDictionary:(NSDictionary *)dict;

@end
