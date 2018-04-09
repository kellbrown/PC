//
//  FeedCollectionView.m
//  PC
//
//  Created by Kelly Brown on 2018-04-05.
//  Copyright © 2018 Kelly Brown. All rights reserved.
//

#import "FeedCollectionView.h"

@implementation FeedCollectionView

-(id) init {
    self = [super self];
    if( self ) {
        [self setup];
    }
    
    return self;
}

-(id)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithFrame: frame collectionViewLayout: layout];
    
    if( self ) {
        [self setup];
    }
    
    return self;
}

- (void)setup {
    self.backgroundColor = UIColor.whiteColor;
    
    self.delegate = self;
    self.dataSource = self;
    
    [self registerClass:[FeedCell class] forCellWithReuseIdentifier: @"FeedCell"];
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    FeedCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FeedCell" forIndexPath: indexPath];
    
    cell.feedView.itemDictionary = self.items[indexPath.row];
    
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _items.count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

@end
