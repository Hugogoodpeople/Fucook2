//
//  IAPHelper.h
//  Fucook
//
//  Created by Hugo Costa on 27/11/14.
//  Copyright (c) 2014 Hugo Costa. All rights reserved.
//

#import <Foundation/Foundation.h>
// Add to the top of the file
#import <StoreKit/StoreKit.h>




typedef void (^RequestProductsCompletionHandler)(BOOL success, NSArray * products);

@interface IAPHelper : NSObject

- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers;
- (void)requestProductsWithCompletionHandler:(RequestProductsCompletionHandler)completionHandler;

UIKIT_EXTERN NSString *const IAPHelperProductPurchasedNotification;

// Add two new method declarations
- (void)buyProduct:(SKProduct *)product;
- (BOOL)productPurchased:(NSString *)productIdentifier;
- (void)restoreCompletedTransactions;

@property (nonatomic, assign) id delegate;

@end