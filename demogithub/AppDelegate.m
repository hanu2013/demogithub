//
//  AppDelegate.m
//  XMPP
//
//  Created by Nguyen Kim Ngoc on 5/31/18.
//  Copyright © 2018 Nguyen Kim Ngoc. All rights reserved.
//

#import "AppDelegate.h"
#import "DBService.h"

@import CocoaLumberjack;
@import XMPPFramework;

//static const int ddLogLevel = LOG_LEVEL_VERBOSE;
static const DDLogLevel ddLogLevel = DDLogLevelVerbose;

@interface AppDelegate () 

@end

@implementation AppDelegate



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [DDLog addLogger:[DDASLLogger sharedInstance]];
    
    
   
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *baseDir = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    NSString *logsDirectory = [baseDir stringByAppendingPathComponent:@"Logs"];
    
    DDLogFileManagerDefault *defaultLogFileManager = [[DDLogFileManagerDefault alloc] initWithLogsDirectory: logsDirectory];
    
    self.ddFileLogger = [[DDFileLogger alloc] initWithLogFileManager:defaultLogFileManager]; // File Logger
    self.ddFileLogger.rollingFrequency = 60 * 60 * 24; // 24 hour rolling
    self.ddFileLogger.logFileManager.maximumNumberOfLogFiles = 7;
    
    [DDLog addLogger:self.ddFileLogger];
    
    DDLogVerbose(@"DID FINISH LAUNCHING");
    
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    DDLogVerbose(@"APP RESIGN ACTIVE");
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    DDLogVerbose(@"APP DID ENTER BACKGROUND");
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    DDLogVerbose(@"APP DID ENTER FOREGROUND");
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    DDLogVerbose(@"APP WILL TERMINATE");
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = [[DBService sharedInstance] managedObjectContext];
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
