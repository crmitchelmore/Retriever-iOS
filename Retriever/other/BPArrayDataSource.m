//
//  BPArrayDataSource.m
//  BarPass
//
//  Created by Chris Mitchelmore on 21/06/2013.
//  Copyright (c) 2013 Bar Pass. All rights reserved.
//

#import "BPArrayDataSource.h"

@interface BPArrayDataSource()

@property (nonatomic, strong) NSString *cellIdentifier;
@property (nonatomic, strong) BPCellConfigurationBlock cellConfigurationBlock;
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) id itemView;
@end
@implementation BPArrayDataSource


/////////////////////////////////////////////////////////////////////////
#pragma mark - Life Cycle
/////////////////////////////////////////////////////////////////////////


- (instancetype)initWithItemView:(id)view
                           items:(NSArray *)items
                  cellIdentifier:(NSString *)cellIdentifier
              configureCellBlock:(BPCellConfigurationBlock)cellConfigurationBlock
{
    self = [super init];
    if (self) {
        self.itemView = view;
        self.items = items ? items : @[]; // Make sure items are not nil!
        self.cellIdentifier = cellIdentifier;
        self.cellConfigurationBlock = cellConfigurationBlock;
    }
    return self;
    
}
- (instancetype)initWithItemView:(id)view
                           items:(NSArray *)items
                       cellClass:(Class)aClass
                    registerType:(BPCellRegistrationType)cellType
              configureCellBlock:(BPCellConfigurationBlock)cellConfigurationBlock
{
    
    self = [super init];
    if (!view)return nil;
    if (self) {
        NSString *classString = NSStringFromClass(aClass);
        self.itemView = view;
        self.items = items ? items : @[]; // Make sure items are not nil!
        self.cellIdentifier = classString;
        self.cellConfigurationBlock = cellConfigurationBlock;
    
        switch (cellType) {
            case BPCellRegistrationTypeNib:{
                UINib *nib = [UINib nibWithNibName:classString bundle:nil];
                if ( [view respondsToSelector:@selector(registerNib:forCellReuseIdentifier:)] ){
                    //Tableview
                    [view registerNib:nib forCellReuseIdentifier:classString];
                }else if ( [view respondsToSelector:@selector(registerNib:forCellWithReuseIdentifier:)] ){
                    //CollectionView
                    [view registerNib:nib forCellWithReuseIdentifier:classString];
                }
            }
                break;
            case BPCellRegistrationTypeClass:{
                if ( [view respondsToSelector:@selector(registerClass: forCellReuseIdentifier:)] ){
                    //Tableview
                    [view registerClass:aClass forCellReuseIdentifier:classString];
                }else if ( [view respondsToSelector:@selector(registerClass: forCellWithReuseIdentifier:)] ){
                    //CollectionView
                    [view registerClass:aClass forCellWithReuseIdentifier:classString];
                }
            }
                break;
            case BPCellRegistrationTypeNone:
                //Do nothing
                break;
        }
        
    }
    return self;
}

//---------------------------------------------------------------------

- (id)init
{
    [NSException raise:NSInternalInconsistencyException format:@"Use designated initializer."];
    return nil;
}


/////////////////////////////////////////////////////////////////////////
#pragma mark - Public API
/////////////////////////////////////////////////////////////////////////


- (void)setItemsAndReload:(NSArray *)items
{
    self.items = items ? items : @[]; // Make sure items not nil
    [self.itemView reloadData];
}

//---------------------------------------------------------------------

- (void)removeItem:(id)item
{
    if ( ![self.itemView isKindOfClass:[UITableView class]] ){return;}
    NSMutableArray *newItems = [self.items mutableCopy];
    [newItems removeObject:item];
    NSIndexPath *indexPath = [self _indexPathForItem:item];
    self.items = newItems;
    [self.itemView beginUpdates];
    [self.itemView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self.itemView endUpdates];
}


/////////////////////////////////////////////////////////////////////////
#pragma mark - Tableview DataSource
/////////////////////////////////////////////////////////////////////////


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//---------------------------------------------------------------------

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}

//---------------------------------------------------------------------

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    id cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier
                                              forIndexPath:indexPath];
    id item  = [self _itemAtIndexPath:indexPath];
    self.cellConfigurationBlock(cell,item,indexPath);
    return cell;
}


/////////////////////////////////////////////////////////////////////////
#pragma mark - CollectionView DataSource
/////////////////////////////////////////////////////////////////////////


- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return self.items.count;
}

//---------------------------------------------------------------------

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}

//---------------------------------------------------------------------

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    id cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.cellIdentifier forIndexPath:indexPath];
    if(!cell)NSLog(@"CV Cell nill");
    id item = [self _itemAtIndexPath:indexPath];
    self.cellConfigurationBlock(cell,item,indexPath);
    //((UICollectionViewCell *)cell).backgroundColor = [UIColor blueColor];
    return cell;
}


/////////////////////////////////////////////////////////////////////////
#pragma mark - Private API
/////////////////////////////////////////////////////////////////////////


- (NSIndexPath *)_indexPathForItem:(id)item
{
    NSUInteger index = [self.items indexOfObject:item];
    if ( index == NSNotFound )return nil;
    return [NSIndexPath indexPathForRow:index inSection:0];
}

//---------------------------------------------------------------------

- (id)_itemAtIndexPath:(NSIndexPath*)indexPath
{
    return self.items[(NSUInteger)indexPath.row];
}

@end
