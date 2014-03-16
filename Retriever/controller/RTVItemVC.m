//
//  RTVItemVC.m
//  Retriever
//
//  Created by Chris Mitchelmore on 15/03/2014.
//  Copyright (c) 2014 Retriever Company. All rights reserved.
//

#import "RTVItemVC.h"
//Model
#import "RTVSearchResponse.h"
//View
#import "RTVItemCell.h"
//Other
#import "BPArrayDataSource.h"

@interface RTVItemVC ()<UICollectionViewDelegateFlowLayout, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backToSearch;
@property (weak, nonatomic) IBOutlet UIButton *lastButton;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) BPArrayDataSource *arrayDataSource;
@end

@implementation RTVItemVC


- (BPArrayDataSource *)arrayDataSource
{
    if ( !_arrayDataSource ){

        NSMutableArray *extendedItems = [self.searchResponse.items mutableCopy];
        [extendedItems insertObject:[self.searchResponse.items lastObject] atIndex:0];
        [extendedItems addObject:[self.searchResponse.items firstObject]];
        _arrayDataSource = [[BPArrayDataSource alloc] initWithItemView:self.collectionView items:extendedItems cellClass:[RTVItemCell class] registerType:BPCellRegistrationTypeNone configureCellBlock:^(RTVItemCell *cell, RTVItem *item, NSIndexPath *indexPath) {
            cell.item = item;
            
        }];
    }
    return _arrayDataSource;
}
- (IBAction)backButtonTouched:(UIButton *)sender
{
    self.backToSearchTouched();

}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.lastButton.hidden = YES;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.collectionView.dataSource = self.arrayDataSource;
    self.collectionView.delegate = self;
    self.titleLabel.text = self.searchResponse.matchedQuery;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(snap)];
    [self.collectionView addGestureRecognizer:tap];
    UISwipeGestureRecognizer *sl = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(next)];
    sl.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.collectionView addGestureRecognizer:sl];
    UISwipeGestureRecognizer *sr = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(last)];
    sr.direction = UISwipeGestureRecognizerDirectionRight;
    [self.collectionView addGestureRecognizer:sr];
    self.collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged) name:UIDeviceOrientationDidChangeNotification object:nil];
    [self.lastButton addTarget:self action:@selector(last) forControlEvents:UIControlEventTouchUpInside];
}
- (void)orientationChanged
{
    [self.collectionView reloadData];

    [self.collectionView.collectionViewLayout shouldInvalidateLayoutForBoundsChange:self.collectionView.bounds];
    [self.view layoutIfNeeded];
    NSInteger index = (self.collectionView.contentOffset.x /self.collectionView.frame.size.width);
    [self scrollToIndex:index animated:NO];
    
}
- (void)scrollToIndex:(NSInteger)index animated:(BOOL)animated
{
   if ( index >= 0 && index < [self.arrayDataSource.items count] ){
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];

        self.lastButton.hidden = YES;//index == 0;
        
        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:animated];
       if ( !animated ){
           [self scrollViewDidEndScrollingAnimation:self.collectionView];
       }
   }else {
       [self scrollViewDidEndScrollingAnimation:self.collectionView];
   }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{

    NSInteger index = (self.collectionView.contentOffset.x /self.collectionView.frame.size.width);
    if ( index+1 == [self.arrayDataSource.items count] ){
        
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
        
    }else if ( index == 0 ){
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:[self.arrayDataSource.items count]-1 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    }

}
- (void)snap
{
    NSInteger index = (self.collectionView.contentOffset.x /self.collectionView.frame.size.width)+1;
    [self scrollToIndex:index animated:NO];
}
- (void)next
{
    NSInteger index = (self.collectionView.contentOffset.x /self.collectionView.frame.size.width)+1;
    [self scrollToIndex:index animated:YES];
}
- (void)last
{
    NSInteger index = (self.collectionView.contentOffset.x /self.collectionView.frame.size.width)-1;
    [self scrollToIndex:index animated:YES];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{

    
    CGFloat pageWidth = 320.0;
    
    CGFloat x = targetContentOffset->x;

    
    if (velocity.x > 0.1)
        x = ceilf(x / pageWidth) * pageWidth;
    else if (velocity.x < -0.1)
        x = floorf(x / pageWidth) * pageWidth;
    else
        x = roundf(x / pageWidth) * pageWidth;
    targetContentOffset->x = x;

}


- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self.collectionView reloadData];
    [self.collectionView.collectionViewLayout shouldInvalidateLayoutForBoundsChange:self.collectionView.bounds];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.collectionView.frame.size;
}
@end
