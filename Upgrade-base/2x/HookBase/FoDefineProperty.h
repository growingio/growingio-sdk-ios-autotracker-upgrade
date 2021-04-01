//
//  FoDefineProperty.h
//
//  Created by Fover0 on 15/9/9.
//

#import <objc/runtime.h>

#ifndef Growing_FoDefineProperty_h
#define Growing_FoDefineProperty_h

#define FoPropertyDefine(theClass,theType,theGetter,theSetter)                              \
        @interface theClass(FoDefineProperty_##theGetter)                                   \
        @property (nonatomic, retain) theType theGetter;                                    \
        @end                                                                                \
        @implementation theClass(FoDefineProperty_##theGetter)                              \
             FoPropertyImplementation(theType,theGetter,theSetter)                          \
        @end                                                                                \

#define FoPropertyImplementation(theType,theGetter,theSetter)                               \
        static char __##theClass##__##theGetter##_key;                                      \
        - (void)theSetter:(theType)value                                                    \
        {                                                                                   \
            objc_setAssociatedObject(self,                                                  \
                                     &__##theClass##__##theGetter##_key,                    \
                                     value,                                                 \
                                     OBJC_ASSOCIATION_RETAIN_NONATOMIC);                    \
        }                                                                                   \
        - (theType)theGetter                                                                \
        {                                                                                   \
            return objc_getAssociatedObject(self,&__##theClass##__##theGetter##_key);       \
        }                                                                                   \


#define FoSafeStringPropertyImplementation(theGetter,theSetter)                             \
        static char __##theClass##__##theGetter##_key;                                      \
        - (void)theSetter:(NSString *)value                                                 \
        {                                                                                   \
            if ([value isKindOfClass:[NSNumber class]])                                     \
            {                                                                               \
                value = [(NSNumber *)value stringValue];                                    \
            }                                                                               \
            if (![value isKindOfClass:[NSString class]])                                    \
            {                                                                               \
                value = nil;                                                                \
            }                                                                               \
            objc_setAssociatedObject(self,                                                  \
                                     &__##theClass##__##theGetter##_key,                    \
                                     value,                                                 \
                                     OBJC_ASSOCIATION_COPY_NONATOMIC);                      \
        }                                                                                   \
        - (NSString *)theGetter                                                             \
        {                                                                                   \
            return objc_getAssociatedObject(self,&__##theClass##__##theGetter##_key);       \
        }                                                                                   \



#endif
