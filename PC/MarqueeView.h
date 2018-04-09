//
//  MarqueeView.h
//  PC
//
//  Created by Kelly Brown on 2018-04-05.
//  Copyright © 2018 Kelly Brown. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedView.h"

@interface MarqueeView : UIView {
    FeedView *feedView;
    UILabel *descriptionLbl;
}

@property (strong, nonatomic) NSDictionary *itemDictionary;

@end


