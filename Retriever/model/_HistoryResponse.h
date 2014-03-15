// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to HistoryResponse.h instead.

#import <CoreData/CoreData.h>


extern const struct HistoryResponseAttributes {
	__unsafe_unretained NSString *date;
	__unsafe_unretained NSString *matchedQuery;
	__unsafe_unretained NSString *originalQuery;
	__unsafe_unretained NSString *responseType;
	__unsafe_unretained NSString *totalItems;
} HistoryResponseAttributes;

extern const struct HistoryResponseRelationships {
	__unsafe_unretained NSString *items;
} HistoryResponseRelationships;

extern const struct HistoryResponseFetchedProperties {
} HistoryResponseFetchedProperties;

@class HistoryItem;







@interface HistoryResponseID : NSManagedObjectID {}
@end

@interface _HistoryResponse : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (HistoryResponseID*)objectID;





@property (nonatomic, strong) NSDate* date;



//- (BOOL)validateDate:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* matchedQuery;



//- (BOOL)validateMatchedQuery:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* originalQuery;



//- (BOOL)validateOriginalQuery:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* responseType;



//- (BOOL)validateResponseType:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* totalItems;



@property int32_t totalItemsValue;
- (int32_t)totalItemsValue;
- (void)setTotalItemsValue:(int32_t)value_;

//- (BOOL)validateTotalItems:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet *items;

- (NSMutableSet*)itemsSet;





@end

@interface _HistoryResponse (CoreDataGeneratedAccessors)

- (void)addItems:(NSSet*)value_;
- (void)removeItems:(NSSet*)value_;
- (void)addItemsObject:(HistoryItem*)value_;
- (void)removeItemsObject:(HistoryItem*)value_;

@end

@interface _HistoryResponse (CoreDataGeneratedPrimitiveAccessors)


- (NSDate*)primitiveDate;
- (void)setPrimitiveDate:(NSDate*)value;




- (NSString*)primitiveMatchedQuery;
- (void)setPrimitiveMatchedQuery:(NSString*)value;




- (NSString*)primitiveOriginalQuery;
- (void)setPrimitiveOriginalQuery:(NSString*)value;




- (NSString*)primitiveResponseType;
- (void)setPrimitiveResponseType:(NSString*)value;




- (NSNumber*)primitiveTotalItems;
- (void)setPrimitiveTotalItems:(NSNumber*)value;

- (int32_t)primitiveTotalItemsValue;
- (void)setPrimitiveTotalItemsValue:(int32_t)value_;





- (NSMutableSet*)primitiveItems;
- (void)setPrimitiveItems:(NSMutableSet*)value;


@end
