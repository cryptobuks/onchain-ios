//
//  AppDelegate.h
//  OnChain
//
//  Created by Cool on 1/26/15.
//  Copyright (c) 2015 IT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

- (void)showWaitingScreen:(NSString *)strText bShowText:(BOOL)bShowText withSize : (CGSize) size;
- (void)hideWaitingScreen;

 
+(AppDelegate *) sharedAppDelegate;

@end

