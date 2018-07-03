//
//  DBService.h
//  XMPP
//
//  Created by Nguyen Kim Ngoc on 7/3/18.
//  Copyright © 2018 Nguyen Kim Ngoc. All rights reserved.
//

#import <Foundation/Foundation.h>

@import CoreData;

@interface DBService : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (id) sharedInstance;

- (void) test;
- (void) testQuery;
@end
