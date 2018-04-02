//
//  LPFileManager.m
//  JamGo
//
//  Created by Lipeng on 2017/6/22.
//  Copyright © 2017年 JIQI. All rights reserved.
//

#import "LPFileManager.h"

static const NSInteger kDefaultCacheMaxCacheAge = 60 * 60 * 24 * 30; // 1 week

@interface LPFileManager()
@property(nonatomic,strong) NSFileManager *fileManager;
@property(nonatomic,copy) NSString *diskCachePath;
@property(nonatomic,assign) NSInteger maxCacheAge;
@property(nonatomic,strong) dispatch_queue_t ioQueue;
@end

@implementation LPFileManager
LP_SingleInstanceImpl(LPFileManager)

//- (instancetype)init
//{
//    return [self initWithNamespace:@"lipeng"];
//}
//
//- (id)initWithNamespace:(NSString *)ns
//{
//    NSString *path = [self makeDiskCachePath:ns];
//    return [self initWithNamespace:ns diskCacheDirectory:path];
//}
//
//- (id)initWithNamespace:(NSString *)ns diskCacheDirectory:(NSString *)directory
//{
//    if ((self = [super init])) {
//        NSString *fullNamespace=[@"com.crazy.lipeng." stringByAppendingString:ns];
//        _maxCacheAge=kDefaultCacheMaxCacheAge;
//        _ioQueue=dispatch_queue_create("com.crazy.lipeng", DISPATCH_QUEUE_SERIAL);
//        if (directory != nil) {
//            _diskCachePath = [directory stringByAppendingPathComponent:fullNamespace];
//        } else {
//            NSString *path = [self makeDiskCachePath:ns];
//            _diskCachePath = path;
//        }
//        dispatch_sync(_ioQueue, ^{
//            _fileManager = [NSFileManager new];
//        });
//        LP_AddObserver(UIApplicationWillTerminateNotification,self,@selector(cleanDisk));
//        LP_AddObserver(UIApplicationDidEnterBackgroundNotification,self,@selector(backgroundCleanDisk));
//    }
//    return self;
//}
//- (void)cleanDisk
//{
//    [self cleanDiskWithCompletionBlock:nil];
//}
//- (void)backgroundCleanDisk
//{
//    Class UIApplicationClass = NSClassFromString(@"UIApplication");
//    if(!UIApplicationClass || ![UIApplicationClass respondsToSelector:@selector(sharedApplication)]) {
//        return;
//    }
//    UIApplication *application = [UIApplication performSelector:@selector(sharedApplication)];
//    __block UIBackgroundTaskIdentifier bgTask = [application beginBackgroundTaskWithExpirationHandler:^{
//        [application endBackgroundTask:bgTask];
//        bgTask = UIBackgroundTaskInvalid;
//    }];
//
//    [self cleanDiskWithCompletionBlock:^{
//        [application endBackgroundTask:bgTask];
//        bgTask = UIBackgroundTaskInvalid;
//    }];
//}
//- (void)cleanDiskWithCompletionBlock:(SDWebImageNoParamsBlock)completionBlock
//{
//    dispatch_async(self.ioQueue, ^{
//        NSURL *diskCacheURL = [NSURL fileURLWithPath:self.diskCachePath isDirectory:YES];
//        NSArray *resourceKeys = @[NSURLIsDirectoryKey, NSURLContentModificationDateKey, NSURLTotalFileAllocatedSizeKey];
//
//        NSDirectoryEnumerator *fileEnumerator = [_fileManager enumeratorAtURL:diskCacheURL
//                                                   includingPropertiesForKeys:resourceKeys
//                                                                      options:NSDirectoryEnumerationSkipsHiddenFiles
//                                                                 errorHandler:NULL];
//
//        NSDate *expirationDate = [NSDate dateWithTimeIntervalSinceNow:-self.maxCacheAge];
//        NSMutableDictionary *cacheFiles = [NSMutableDictionary dictionary];
//        NSUInteger currentCacheSize = 0;
//
//        NSMutableArray *urlsToDelete = [[NSMutableArray alloc] init];
//        for (NSURL *fileURL in fileEnumerator) {
//            NSDictionary *resourceValues = [fileURL resourceValuesForKeys:resourceKeys error:NULL];
//
//            if ([resourceValues[NSURLIsDirectoryKey] boolValue]) {
//                continue;
//            }
//
//            NSDate *modificationDate = resourceValues[NSURLContentModificationDateKey];
//            if ([[modificationDate laterDate:expirationDate] isEqualToDate:expirationDate]) {
//                [urlsToDelete addObject:fileURL];
//                continue;
//            }
//
//            NSNumber *totalAllocatedSize = resourceValues[NSURLTotalFileAllocatedSizeKey];
//            currentCacheSize += [totalAllocatedSize unsignedIntegerValue];
//            [cacheFiles setObject:resourceValues forKey:fileURL];
//        }
//
//        for (NSURL *fileURL in urlsToDelete) {
//            [_fileManager removeItemAtURL:fileURL error:nil];
//        }
//
//        if (completionBlock) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                completionBlock();
//            });
//        }
//    });
//}
//- (NSString *)makeDiskCachePath:(NSString*)fullNamespace
//{
//    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
//    return [paths[0] stringByAppendingPathComponent:fullNamespace];
//}
//- (NSString *)cachedFileNameForKey:(NSString *)key
//{
//    return [key MD5String:NSUTF8StringEncoding];
//}
//- (NSString *)cachePathForKey:(NSString *)key inPath:(NSString *)path
//{
//    NSString *filename = [self cachedFileNameForKey:key];
//    return [path stringByAppendingPathComponent:filename];
//}
//
//- (NSString *)defaultCachePathForKey:(NSString *)key
//{
//    return [self cachePathForKey:key inPath:self.diskCachePath];
//}
//
//- (BOOL)diskFileExistForKey:(NSString *)key
//{
//    BOOL exist=[[NSFileManager defaultManager] fileExistsAtPath:[self defaultCachePathForKey:key]];
//    if (!exist) {
//        exist=[[NSFileManager defaultManager] fileExistsAtPath:[[self defaultCachePathForKey:key] stringByDeletingPathExtension]];
//    }
//    return exist;
//}
//
//- (NSData *)dataForKey:(NSString *)key
//{
//    return [NSData dataWithContentsOfFile:[self defaultCachePathForKey:key]];
//}
//
//- (void)storeData:(NSData *)data forKey:(NSString *)key block:(file_store_block)block
//{
//    dispatch_async(_ioQueue, ^{
//        if (![_fileManager fileExistsAtPath:_diskCachePath]){
//            [_fileManager createDirectoryAtPath:_diskCachePath withIntermediateDirectories:YES attributes:nil error:NULL];
//        }
//        NSString *cachePathForKey = [self defaultCachePathForKey:key];
//
//        [_fileManager createFileAtPath:cachePathForKey contents:data attributes:nil];
//        if (nil!=block){
//            dispatch_async(dispatch_get_main_queue(), ^{
//                block(key);
//            });
//        }
//        NSURL *fileURL = [NSURL fileURLWithPath:cachePathForKey];
//        [fileURL setResourceValue:[NSNumber numberWithBool:YES] forKey:NSURLIsExcludedFromBackupKey error:nil];
//    });
//}
//
//- (void)removeFileAtPath:(NSString *)path
//{
//    NSString *ip=[path copy];
//    dispatch_async(_ioQueue, ^{
//        [_fileManager removeItemAtPath:ip error:nil];
//    });
//}
@end
