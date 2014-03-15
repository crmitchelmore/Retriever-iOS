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

@interface RTVItemVC ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backToSearch;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.collectionView.dataSource = self.arrayDataSource;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Search" style:UIBarButtonItemStylePlain target:self action:@selector(rtv_back)];
}

- (void)rtv_back
{
    self.backToSearchTouched();
}


@end
