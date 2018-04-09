//
//  MarqueeView.m
//  PC
//
//  Created by Kelly Brown on 2018-04-05.
//  Copyright © 2018 Kelly Brown. All rights reserved.
//

#import "MarqueeView.h"

@implementation MarqueeView

@synthesize itemDictionary = _itemDictionary;

- (id)init {
    self = [self initWithItemDictionary:nil];
    
    return self;
}


- (id)initWithItemDictionary:(NSDictionary *)dict {
    self = [super init];
    
    if( dict != nil ) {
        self.itemDictionary = dict;
    }

    if( self ) {
        self.translatesAutoresizingMaskIntoConstraints = false;
        
        self.backgroundColor = UIColor.whiteColor;
        
        
        feedView = [[FeedView alloc] init];

        descriptionLbl = [[UILabel alloc] init];
        descriptionLbl.translatesAutoresizingMaskIntoConstraints = false;
        descriptionLbl.numberOfLines = 2;
        
        [self setupConstraints];
    }
    
    return self;
}

- (void)setItemDictionary:(NSDictionary *)itemDictionary {
     _itemDictionary = itemDictionary;
    
    feedView.itemDictionary = itemDictionary;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        descriptionLbl.attributedText = [self stripHTMLTags: [itemDictionary objectForKey: @"description"]];
    });
}

- (void)setupConstraints {
    [self addSubview: feedView];
    [[feedView topAnchor] constraintEqualToAnchor: self.topAnchor].active = true;
    [[feedView leadingAnchor] constraintEqualToAnchor: self.leadingAnchor].active = true;
    [[feedView trailingAnchor] constraintEqualToAnchor: self.trailingAnchor].active = true;
    
    [self addSubview:descriptionLbl];
    [[descriptionLbl topAnchor] constraintEqualToAnchor: feedView.bottomAnchor constant: 5.0].active = true;
    [[descriptionLbl leadingAnchor] constraintEqualToAnchor: self.leadingAnchor constant: 10.0].active = true;
    [[descriptionLbl trailingAnchor] constraintEqualToAnchor: self.trailingAnchor constant: -10.0].active = true;
    [[descriptionLbl bottomAnchor] constraintEqualToAnchor: self.bottomAnchor constant: -5.0].active = true;
}

- (void)downloadImageWithString:(NSString *)urlString completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock {
    
    NSURL *url = [[NSURL alloc] initWithString: urlString];
    NSURLSessionDataTask *sessionTask = [[NSURLSession sharedSession] dataTaskWithRequest: [NSURLRequest requestWithURL: url]
                                                                          completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil) {
            if ([error code] == NSURLErrorAppTransportSecurityRequiresSecureConnection) {
                    completionBlock(false, nil);
            }
        } else {
            [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIImage *image = [[UIImage alloc] initWithData: data];
                    completionBlock(true, image);
                });
            }];
        }
    }];
    [sessionTask resume];
}

-(NSAttributedString *)stripHTMLTags:(NSString *)string {
    NSData *stringData = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *options = @{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType};
    
    NSMutableAttributedString *decodedString;
    decodedString = [[NSMutableAttributedString alloc] initWithData:stringData
                                                     options:options
                                          documentAttributes:NULL
                                                       error:NULL];
    [decodedString addAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15.0]} range:NSMakeRange(0, decodedString.length)];

    return decodedString;
}

-(void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(ctx);
    
    CGContextSetStrokeColorWithColor(ctx, [UIColor lightGrayColor].CGColor);

    CGContextMoveToPoint(ctx, 0, self.frame.size.height);
    CGContextAddLineToPoint(ctx, self.frame.size.width, self.frame.size.height);
    CGContextSetLineWidth(ctx, 3.0);
    CGContextDrawPath(ctx, kCGPathStroke);
    
    CGContextRestoreGState(ctx);
}

@end
