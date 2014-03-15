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
        _arrayDataSource = [[BPArrayDataSource alloc] initWithItemView:self.collectionView items:self.searchResponse.items cellClass:[RTVItemCell class] registerType:BPCellRegistrationTypeNone configureCellBlock:^(RTVItemCell *cell, RTVItem *item, NSIndexPath *indexPath) {
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
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(next)];
    [self.collectionView addGestureRecognizer:tap];
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
    [self scrollToIndex:index];
    
}
- (void)scrollToIndex:(NSInteger)index
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];

    self.lastButton.hidden = index == 0;

    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}
- (void)next
{
    NSInteger index = (self.collectionView.contentOffset.x /self.collectionView.frame.size.width)+1;
    [self scrollToIndex:index];
}
- (void)last
{
    NSInteger index = (self.collectionView.contentOffset.x /self.collectionView.frame.size.width)-1;
    [self scrollToIndex:index];
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
