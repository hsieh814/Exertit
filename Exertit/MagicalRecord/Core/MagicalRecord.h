//
//  MagicalRecord.h
//
//  Created by Saul Mora on 3/11/10.
//  Copyright 2010 Magical Panda Software, LLC All rights reserved.
//

#if TARGET_OS_IPHONE == 0
#define MAC_PLATFORM_ONLY YES
#endif

// enable to use caches for the fetchedResultsControllers (iOS only)
// #define STORE_USE_CACHE

#ifndef MR_ENABLE_ACTIVE_RECORD_LOGGING
    #ifdef DEBUG
        #define MR_ENABLE_ACTIVE_RECORD_LOGGING 0
    #else
        #define MR_ENABLE_ACTIVE_RECORD_LOGGING 0
    #endif
#endif

#if MR_ENABLE_ACTIVE_RECORD_LOGGING != 0
      // First, check if we can use Cocoalumberjack for logging
    #if defined(LOG_VERBOSE) || defined(COCOAPODS_POD_AVAILABLE_CocoaLumberjack)
        #import "DDLog.h"
        extern int ddLogLevel;
        #ifdef MR_LOG_CONTEXT
            // Log to CocoaLumberjack with custom context
            #define MRLog(frmt, ...)  ASYNC_LOG_OBJC_MAYBE(ddLogLevel, LOG_FLAG_VERBOSE, MR_LOG_CONTEXT, frmt, ##__VA_ARGS__)
        #else
            #define MRLog(...)  DDLogVerbose(__VA_ARGS__)
        #endif
    #else
        #define MRLog(...) NSLog(@"%s(%p) %@", __PRETTY_FUNCTION__, self, [NSString stringWithFormat:__VA_ARGS__])
    #endif
#else
    #define MRLog(...) ((void)0)
#endif

#ifdef NS_BLOCKS_AVAILABLE

extern NSString * const kMagicalRecordCleanedUpNotification;

@class NSManagedObjectContext;
typedef void (^CoreDataBlock)(NSManagedObjectContext *context);

#endif

@interface MagicalRecord : NSObject

+ (NSInteger)version;
+ (NSString *)displayVersion;
+ (NSString *)build;

+ (NSString *) currentStack;

+ (void) cleanUp;

+ (void) setDefaultModelFromClass:(Class)klass;
+ (void) setDefaultModelNamed:(NSString *)modelName;
+ (NSString *) defaultStoreName;

@end
