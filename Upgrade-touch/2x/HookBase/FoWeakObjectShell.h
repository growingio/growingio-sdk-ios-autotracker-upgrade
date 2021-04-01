//
//  FoWeakObjectShell.h
//
//  Created by Fover0 on 15/8/16.
//

#import <Foundation/Foundation.h>

@interface FoWeakObjectShell : NSObject

+ (FoWeakObjectShell *)weakObject:(id)obj;

@property (nonatomic, weak) id obj;

@end
