// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to HistoryItem.h instead.

#import <CoreData/CoreData.h>


extern const struct HistoryItemAttributes {
	__unsafe_unretained NSString *displayName;
} HistoryItemAttributes;

extern const struct HistoryItemRelationships {
	__unsafe_unretained NSString *response;
} HistoryItemRelationships;

extern const struct HistoryItemFetchedProperties {
} HistoryItemFetchedProperties;

@class HistoryResponse;



@interface HistoryItemID : NSManagedObjectID {}
@end

@interface _HistoryItem : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (HistoryItemID*)objectID;





@property (nonatomic, strong) NSString* displayName;



//- (BOOL)validateDisplayName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) HistoryResponse *response;

//- (BOOL)validateResponse:(id*)value_ error:(NSError**)error_;





@end

@interface _HistoryItem (CoreDataGeneratedAccessors)

@end

@interface _HistoryItem (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveDisplayName;
- (void)setPrimitiveDisplayName:(NSString*)value;





- (HistoryResponse*)primitiveResponse;
- (void)setPrimitiveResponse:(HistoryResponse*)value;


@end
