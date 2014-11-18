//
//  DataResourceHandler.h
//  LSATMax
//
//  Created by Jason Loewy on 6/11/12.
//  Copyright (c) 2012 Jason Loewy. All rights reserved.
//

@interface DataResourceHandler : NSObject

+ (void) checkOrCopyFile:(NSString *)fileName toDirectory:(NSInteger)directory ofType:(NSString *)fileType forceCopy:(BOOL) forceCopy;

+ (NSString*) getPathToFile:(NSString*) fileName inDirectory:(NSInteger) directoryName;

+ (BOOL) deleteImageName:(NSString*) imageName;

@end
