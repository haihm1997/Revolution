//
//  ProfileViewModel.swift
//  Revolution
//
//  Created by Hoang Hai on 21/07/2021.
//  Copyright © 2021 TonyHoang. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

class ProfileViewModel: BaseViewModel {
    
    let isPremium = BehaviorRelay<Bool>(value: false)
    let inPurchasePremium = PublishRelay<Void>()
    let inRestoreProduct = PublishRelay<Void>()
    
    let outError: Observable<RevolutionError>
    let outActivity: Observable<Bool>
    let outPurchaseSuccess = PublishRelay<Bool>()
    let outDidRestoreProduct = PublishRelay<Bool>()
    
    override init() {
        let errorTracker = ErrorTracker()
        let activityTracker = ActivityTracker<String>()
        let profileUseCase = ProfileUseCase()
        
        outError = errorTracker.asDomain()
        outActivity = activityTracker.status(for: LOADING_KEY)
        super.init()
        
        inPurchasePremium
            .flatMap { profileUseCase.executePurchase()
                .asObservable()
                .trackActivity(LOADING_KEY, with: activityTracker)
                .trackError(with: errorTracker)
            }
            .bind(to: outPurchaseSuccess)
            .disposed(by: rx.disposeBag)
        
        inRestoreProduct
            .flatMap {  profileUseCase.restorePremium()
                .asObservable()
                .trackActivity(LOADING_KEY, with: activityTracker)
                .trackError(with: errorTracker)
            }
            .bind(to: outDidRestoreProduct)
            .disposed(by: rx.disposeBag)
    }
    
}

class ProfileUseCase {
    
    func executePurchase() -> Single<Bool> {
        return Single.create { single in
            guard let premiumProduct = IAPManager.shared.premiumProducts.first else {
                single(.error(RevolutionError.premiumRegisterFailed))
                return Disposables.create()
            }
            IAPManager.shared.buy(product: premiumProduct) { result in
                switch result {
                case .success(let success):
                    let userDefault = UserDefaults.standard
                    userDefault.setValue(success, forKey: "isPurchased")
                    single(.success(true))
                case .failure:
                    single(.error(RevolutionError.premiumRegisterFailed))
                }
            }
            return Disposables.create()
        }
    }
    
    func restorePremium() -> Single<Bool> {
        return Single.create { single in
            IAPManager.shared.restorePurchases { restoredProducts in
                single(.success(restoredProducts > 0))
            }
            return Disposables.create()
        }
    }
    
    func fetchProducts() -> Single<Void> {
        return Single.create { single in
            IAPManager.shared.getProducts { result in
                switch result {
                case .success:
                    single(.success(()))
                case .failure(let error):
                    single(.error(error))
                }
            }
            return Disposables.create()
        }
    }
    
}


