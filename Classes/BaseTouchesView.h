
#import <UIKit/UIKit.h>

@protocol BaseTouchesViewDelegate <NSObject>

- (void)theTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)theTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)theTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;

@end

@interface BaseTouchesView : UIView

@property (nonatomic, weak) id <BaseTouchesViewDelegate> delegate;

@end
