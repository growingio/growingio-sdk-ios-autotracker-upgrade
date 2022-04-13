//
//  FoAspect.h
//
//  Created by Fover0 on 16/5/7.
//

#import <UIKit/UIKit.h>
#import "Upgrade-base/2x/HookBase/FoAspectPrivate.h"

@protocol FoAspectToken <NSObject>
- (void)remove;
@end

@interface foAspectIMPItem : NSObject

@property(nullable) IMP oldIMP;
@property(copy, nonatomic) NSString * _Nullable selName;

@end

@interface NSObject(foAspect)

- (_Nullable id<FoAspectToken>)foAspectAfterSeletorNoAddMethod;
- (_Nullable id<FoAspectToken>)foAspectAfterSeletor;
- (_Nullable id<FoAspectToken>)foAspectBeforeSeletorNoAddMethod;
- (_Nullable id<FoAspectToken>)foAspectBeforeSeletor;

+ (_Nullable id<FoAspectToken>)foAspectAfterSeletorNoAddMethod;
+ (_Nullable id<FoAspectToken>)foAspectAfterSeletor;
+ (_Nullable id<FoAspectToken>)foAspectBeforeSeletorNoAddMethod;
+ (_Nullable id<FoAspectToken>)foAspectBeforeSeletor;

@end

