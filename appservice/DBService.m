//
//  DBService.m
//  demogithub
//
//  Created by Nguyen Kim Ngoc on 7/3/18.
//  Copyright © 2018 Nguyen Kim Ngoc. All rights reserved.
//

#import "DBService.h"

@implementation DBService

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

+ (id) sharedInstance
{
    static DBService *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator =
    [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's
// model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"AppDB"
                                              withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc]
                           initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory]
                       URLByAppendingPathComponent:@"AppDB.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc]
                                   initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator
          addPersistentStoreWithType:NSSQLiteStoreType
          configuration:nil
          URL:storeURL
          options:nil
          error:&error]) {
        /*
         Replace this implementation with code to handle the error
         appropriately.
         
         abort() causes the application to generate a crash log and terminate.
         You should not use this function in a shipping application, although it
         may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current
         managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something
         wrong with the file path. Often, a file URL is pointing into the
         application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you
         can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following
         dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES,
         NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema
         changes; consult "Core Data Model Versioning and Data Migration
         Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (void) test
{
    NSManagedObjectContext *context = self.managedObjectContext;
    
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"PhoneContact"
                                   inManagedObjectContext:context];
    
    NSManagedObject *newManagedObject =
    [NSEntityDescription insertNewObjectForEntityForName:[entity name]
                                  inManagedObjectContext:context];
    
    // If appropriate, configure the new managed object.
    [newManagedObject setValue: [NSNumber numberWithInteger:1] forKey:@"recordID"];
    [newManagedObject setValue:@"0988084022" forKey:@"phone"];
    [newManagedObject setValue:@"Test" forKey:@"name"];
    
    // Save the context.
    NSError *error = nil;
    if (![context save:&error]) {
        /*
         Replace this implementation with code to handle the error
         appropriately.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

- (void) testQuery
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"PhoneContact" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"(name contains[cd] '%@')", @"est"]];
    
    [fetchRequest setPredicate:predicate];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"recordID" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSError *error;
    NSArray *rs = [[self managedObjectContext] executeFetchRequest:fetchRequest error: &error];
    if (rs)
    {
        for (id obj in rs)
        {
            NSLog(@"Name: %@", [obj valueForKey:@"name"]);
            NSLog(@"Phone: %@", [obj valueForKey:@"phone"]);
        }
    }
}
@end
