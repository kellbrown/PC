//
//  FeedView.m
//  PC
//
//  Created by Kelly Brown on 2018-04-08.
//  Copyright © 2018 Kelly Brown. All rights reserved.
//

#import "FeedView.h"

@implementation FeedView

@synthesize itemDictionary = _itemDictionary;
@synthesize feedType = _feedType;

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
        
        _feedType = marquee;
        labelMargin = 10.0;
        
        imageView = [[UIImageView alloc] init];
        imageView.translatesAutoresizingMaskIntoConstraints = false;
        imageView.contentMode = UIViewContentModeScaleToFill;
        imageView.image = [[UIImage alloc] init];
        
        articleTitleLbl = [[UILabel alloc] init];
        articleTitleLbl.translatesAutoresizingMaskIntoConstraints = false;
        articleTitleLbl.font = [UIFont systemFontOfSize: 20.0 weight: UIFontWeightMedium];
        articleTitleLbl.numberOfLines = 2;
        
        [self setupConstraints];
    }
    
    return self;
}

- (void)setItemDictionary:(NSDictionary *)itemDictionary {
    _itemDictionary = itemDictionary;
    
    [self downloadImageWithString: [itemDictionary objectForKey: @"media:content"] completionBlock:^(BOOL succeeded, UIImage *image) {
        imageView.image = image;
        [self stopSpinner];
        if( !succeeded ) {
            imageView.backgroundColor = UIColor.lightGrayColor;
        }
    }];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        articleTitleLbl.text = [itemDictionary objectForKey: @"title"];
    });
}

- (void)setFeedType:(FeedType)feedType {
    if( feedType == feed ) {
        articleTitleLbl.font = [UIFont systemFontOfSize: 15.0];
        
        labelMargin = 0.0;
    }
}

- (void)setupConstraints {
    [self addSubview: imageView];
    [[imageView topAnchor] constraintEqualToAnchor: self.topAnchor].active = true;
    [[imageView leadingAnchor] constraintEqualToAnchor: self.leadingAnchor].active = true;
    [[imageView trailingAnchor] constraintEqualToAnchor: self.trailingAnchor].active = true;
    
    [self addSubview:articleTitleLbl];
    [[articleTitleLbl topAnchor] constraintEqualToAnchor: imageView.bottomAnchor constant: 5.0].active = true;
    [[articleTitleLbl leadingAnchor] constraintEqualToAnchor: self.leadingAnchor constant: labelMargin].active = true;
    [[articleTitleLbl trailingAnchor] constraintEqualToAnchor: self.trailingAnchor constant: -labelMargin].active = true;
    [[articleTitleLbl bottomAnchor] constraintEqualToAnchor: self.bottomAnchor].active = true;
}

- (void)downloadImageWithString:(NSString *)urlString completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock {
    [self startSpinner];
    
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

- (void)startSpinner {
    dispatch_async(dispatch_get_main_queue(), ^{
        spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        spinner.translatesAutoresizingMaskIntoConstraints = false;
        [self addSubview:spinner];
        
        
        [[spinner centerXAnchor] constraintEqualToAnchor: imageView.centerXAnchor].active = true;
        [[spinner centerYAnchor] constraintEqualToAnchor: imageView.centerYAnchor].active = true;
        
        [spinner startAnimating];
    });
}

- (void)stopSpinner {
    [spinner stopAnimating];
    
    [spinner removeFromSuperview];
}

@end
