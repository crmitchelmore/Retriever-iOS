// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to HistoryResponse.m instead.

#import "_HistoryResponse.h"

const struct HistoryResponseAttributes HistoryResponseAttributes = {
	.date = @"date",
	.matchedQuery = @"matchedQuery",
	.originalQuery = @"originalQuery",
	.responseType = @"responseType",
	.totalItems = @"totalItems",
};

const struct HistoryResponseRelationships HistoryResponseRelationships = {
	.items = @"items",
};

const struct HistoryResponseFetchedProperties HistoryResponseFetchedProperties = {
};

@implementation HistoryResponseID
@end

@implementation _HistoryResponse

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"HistoryResponse" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"HistoryResponse";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"HistoryResponse" inManagedObjectContext:moc_];
}

- (HistoryResponseID*)objectID {
	return (HistoryResponseID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"totalItemsValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"totalItems"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic date;






@dynamic matchedQuery;






@dynamic originalQuery;






@dynamic responseType;






@dynamic totalItems;



- (int32_t)totalItemsValue {
	NSNumber *result = [self totalItems];
	return [result intValue];
}

- (void)setTotalItemsValue:(int32_t)value_ {
	[self setTotalItems:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveTotalItemsValue {
	NSNumber *result = [self primitiveTotalItems];
	return [result intValue];
}

- (void)setPrimitiveTotalItemsValue:(int32_t)value_ {
	[self setPrimitiveTotalItems:[NSNumber numberWithInt:value_]];
}





@dynamic items;

	
- (NSMutableSet*)itemsSet {
	[self willAccessValueForKey:@"items"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"items"];
  
	[self didAccessValueForKey:@"items"];
	return result;
}
	






@end
