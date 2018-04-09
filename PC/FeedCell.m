//
//  ArcticleCell.m
//  PC
//
//  Created by Kelly Brown on 2018-04-08.
//  Copyright © 2018 Kelly Brown. All rights reserved.
//

#import "FeedCell.h"

@implementation FeedCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _feedView = [[FeedView alloc] init];
        _feedView.feedType = feed;
        
        [self setupConstraints];
    }
    return self;
}

- (void)setupConstraints {
    [self addSubview: _feedView];
    [[_feedView topAnchor] constraintEqualToAnchor: self.topAnchor].active = true;
    [[_feedView leadingAnchor] constraintEqualToAnchor: self.leadingAnchor].active = true;
    [[_feedView trailingAnchor] constraintEqualToAnchor: self.trailingAnchor].active = true;
    [[_feedView bottomAnchor] constraintEqualToAnchor: self.bottomAnchor].active = true;
}

@end
