//
//  BPArrayDataSource.h
//  BarPass
//
//  Created by Chris Mitchelmore on 21/06/2013.
//  Copyright (c) 2013 Bar Pass. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, BPCellRegistrationType) {
    BPCellRegistrationTypeNone, //Cell prototype
    BPCellRegistrationTypeNib,
    BPCellRegistrationTypeClass
};

@interface BPArrayDataSource : NSObject <UITableViewDataSource, UICollectionViewDataSource>

typedef void (^BPCellConfigurationBlock)(id cell, id item, NSIndexPath *indexPath);

@property (strong, readonly) NSArray *items;


/**
 *  Inits a datasource with the given params. Will return nil if the view is nil. Dynamically registers the cells for the view given the type. 
 
 NOTE: ***The cells identifier and nib name must be the same as the class name.***
 *
 *  @param view                   The view to be a datasource for
 *  @param items                  An array of items to be placed in cells. If nill then @[] is used
 *  @param aClass                 The cells class
 *  @param cellType               The type of cells being used by the tableview
 *  @param cellConfigurationBlock A block that configures the cell
 *
 *  @return the configured datasource or nil if view==nil
 */
- (instancetype)initWithItemView:(id)view
                            items:(NSArray *)items
                        cellClass:(Class)aClass
                registerType:(BPCellRegistrationType)cellType
                configureCellBlock:(BPCellConfigurationBlock)cellConfigurationBlock;


/**
 *	Animates removal of item. Note only for tableview at this point.
 *
 *	@param	item	the item to remove
 */
- (void)removeItem:(id)item;

- (void)setItemsAndReload:(NSArray *)items;


@end
