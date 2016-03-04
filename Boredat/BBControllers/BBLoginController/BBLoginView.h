//
//  BBLoginView.h
//  Boredat
//

@class BBLoginView;
@class BBLoginButton;

@protocol BBLoginViewDelegate <NSObject>

- (void)loginViewDidClickOnLogin:(BBLoginView *)loginView;
- (void)loginViewDidClickOnRegister:(BBLoginView *)loginView;
- (void)loginViewDidClickOnAbout:(BBLoginView *)loginView;

@optional

- (void)loginViewDidBeginEdit:(BBLoginView *)loginView;
- (void)pasteCredentials;

@end

@interface BBLoginView : UIView

@property (weak, nonatomic, readwrite) id<BBLoginViewDelegate> delegate;

@property (copy, nonatomic, readwrite) NSString *login;
@property (copy, nonatomic, readwrite) NSString *password;

@property (strong, nonatomic, readwrite) BBLoginButton *loginButton;
@property (strong, nonatomic, readwrite) UIButton *registerButton;

@property (strong, nonatomic, readwrite) UIButton *aboutButton;


- (void)reset;
- (BOOL)filled;
- (void)hideKeyboard;

@end