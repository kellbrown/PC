//
//  ViewController.m
//  PC
//
//  Created by Kelly Brown on 2018-04-04.
//  Copyright © 2018 Kelly Brown. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
    @property (nonatomic, strong) NSXMLParser *xmlParser;
@end

static NSString *const feedLink = @"https://www.personalcapital.com/blog/feed/?cat=3,891,890,68,284";

@implementation ViewController 

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Feed Title";
    self.navigationController.navigationBar.translucent = false;
    UIBarButtonItem *refreshBtn = [[UIBarButtonItem alloc] initWithTitle:@"Refresh" style:UIBarButtonItemStylePlain
                                                                     target:self action:@selector(getFeed)];
    self.navigationItem.rightBarButtonItem = refreshBtn;
    
    [self getFeed];
    
    marqueeView = [[MarqueeView alloc] init];
    [self.view addSubview: marqueeView];
    [[marqueeView topAnchor] constraintEqualToAnchor: self.view.topAnchor].active = true;
    [[marqueeView leadingAnchor] constraintEqualToAnchor: self.view.leadingAnchor].active = true;
    [[marqueeView trailingAnchor] constraintEqualToAnchor: self.view.trailingAnchor].active = true;
    [[marqueeView heightAnchor] constraintEqualToAnchor: self.view.heightAnchor multiplier: 0.40].active = true;

    previewArticlesLbl = [[UILabel alloc] init];
    [self.view addSubview:previewArticlesLbl];
    previewArticlesLbl.translatesAutoresizingMaskIntoConstraints = false;
    previewArticlesLbl.text = @"Previous Articles";
    [[previewArticlesLbl topAnchor] constraintEqualToAnchor: marqueeView.bottomAnchor constant: 15.0].active = true;
    [[previewArticlesLbl leadingAnchor] constraintEqualToAnchor: self.view.leadingAnchor constant: 10.0].active = true;
    [[previewArticlesLbl trailingAnchor] constraintEqualToAnchor: self.view.trailingAnchor constant: -10.0].active = true;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setSectionInset:UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)];
    [flowLayout setMinimumInteritemSpacing: 10.0];
    feedCollectionView = [[FeedCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout: flowLayout];
    
    feedCollectionView.translatesAutoresizingMaskIntoConstraints = false;
    feedCollectionView.delegate = self;
    [self.view addSubview: feedCollectionView];
    [[feedCollectionView topAnchor] constraintEqualToAnchor: previewArticlesLbl.bottomAnchor constant: 15.0].active = true;
    [[feedCollectionView leadingAnchor] constraintEqualToAnchor: self.view.leadingAnchor].active = true;
    [[feedCollectionView trailingAnchor] constraintEqualToAnchor: self.view.trailingAnchor].active = true;
    [[feedCollectionView bottomAnchor] constraintEqualToAnchor: self.view.bottomAnchor].active = true;
}



- (void)getFeed {
    
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:feedLink]];
    
    [urlRequest setHTTPMethod:@"GET"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if( error != nil ) {
            NSLog(@"%@", error.debugDescription);
        }
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        
        if( httpResponse.statusCode == 200 ) {
            if (data != nil) {
                self.xmlParser = [[NSXMLParser alloc] initWithData:data];
                self.xmlParser.delegate = self;
                
                parseItems = false;
                foundValue = [[NSMutableString alloc] init];
                
                // Start parsing.
                [self.xmlParser parse];
            }
        } else {
            NSLog(@"Error");
        }
    }];
    
    [dataTask resume];
}

-(void)parserDidStartDocument:(NSXMLParser *)parser{
    items = [[NSMutableArray alloc] init];
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
   
    if ( [currentElement isEqualToString:@"title"] ) {
        title = [title stringByAppendingString:string];
    } else if ( [currentElement isEqualToString:@"link"] ) {
        link = [link stringByAppendingString:string];
    } else if ( [currentElement isEqualToString:@"pubDate"] ) {
        pubDate = [pubDate stringByAppendingString:string];
    } else if ( [currentElement isEqualToString:@"description"] ) {
        description = [description stringByAppendingString:string];
    }
    
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    
    if( [elementName isEqualToString: @"channel"] ) {
        // We're starting
        NSLog( @"Channel");
    } else if( [elementName isEqualToString: @"item"] ) {
        itemDictionary = [[NSMutableDictionary alloc] init];
        
        link = [[NSString alloc] init];
        pubDate = [[NSString alloc] init];
        description = [[NSString alloc] init];
        mediaContent = [[NSString alloc] init];
        mediaUrl = [[NSString alloc] init];
        
    } else if( [elementName isEqualToString: @"title"] ) {
        title = [[NSString alloc] init];
    } else if( [elementName isEqualToString: @"media:content"]) {
        mediaContent = [attributeDict valueForKey:@"url"];
    }
    
    currentElement = elementName;
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    if([elementName isEqualToString: @"title"]) {
        if( !parseItems ) {
            parseItems = true;
            channelTitle = title;
        }
        
    
    } else if( [elementName isEqualToString: @"item"] ) {
        [itemDictionary setValue: title forKey: @"title"];
        [itemDictionary setValue: link forKey: @"link"];
        [itemDictionary setValue: pubDate forKey: @"pubDate"];
        [itemDictionary setValue: description forKey: @"description"];
        [itemDictionary setValue: mediaContent forKey: @"media:content"];
        
        [items addObject:itemDictionary];
    }

    [foundValue setString:@""];
}

-(void)parserDidEndDocument:(NSXMLParser *)parser{
    NSLog( @"XML Parsing Completed");
    
    if( items != nil ) {
        NSLog( @"Items count: [%lu]", items.count );
        
        marqueeView.itemDictionary = items[0];
        
        [items removeObjectAtIndex:0];
        feedCollectionView.items = items;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [feedCollectionView reloadData];
        });
       
    }
}

-(void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError{
    NSLog(@"%@", [parseError localizedDescription]);
}

// UICollectionViewContorllerDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = self.view.frame.size.width / 2.0 - 20;
    
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) {
        width = self.
        view.frame.size.width / 3.0 - 30;
    }
    return CGSizeMake(width, 140.0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    WebViewController *webViewController = [[WebViewController alloc] init];
    
    NSString *link = [feedCollectionView.items[indexPath.row] objectForKey: @"link"];
    webViewController.link = link;
    webViewController.title = [feedCollectionView.items[indexPath.row] objectForKey: @"title"];
    [self.navigationController pushViewController:webViewController animated: true];
}
@end
