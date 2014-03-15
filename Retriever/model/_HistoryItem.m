// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to HistoryItem.m instead.

#import "_HistoryItem.h"

const struct HistoryItemAttributes HistoryItemAttributes = {
	.displayName = @"displayName",
};

const struct HistoryItemRelationships HistoryItemRelationships = {
	.response = @"response",
};

const struct HistoryItemFetchedProperties HistoryItemFetchedProperties = {
};

@implementation HistoryItemID
@end

@implementation _HistoryItem

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"HistoryItem" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"HistoryItem";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"HistoryItem" inManagedObjectContext:moc_];
}

- (HistoryItemID*)objectID {
	return (HistoryItemID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic displayName;






@dynamic response;

	






@end
