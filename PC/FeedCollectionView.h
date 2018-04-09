//
//  FeedCollectionView.h
//  PC
//
//  Created by Kelly Brown on 2018-04-05.
//  Copyright © 2018 Kelly Brown. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedCell.h"

@interface FeedCollectionView : UICollectionView <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>

@property (strong, nonatomic) NSArray *items;

@end
