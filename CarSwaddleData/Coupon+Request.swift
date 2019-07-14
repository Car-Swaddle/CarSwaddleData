//
//  Coupon+Request.swift
//  CarSwaddleData
//
//  Created by Kyle Kendall on 7/14/19.
//  Copyright © 2019 CarSwaddle. All rights reserved.
//

import Store
import CarSwaddleNetworkRequest
import CoreData

final public class CouponNetwork: Network {
    
    private var couponService: CouponService
    
    override public init(serviceRequest: Request) {
        self.couponService = CouponService(serviceRequest: serviceRequest)
        super.init(serviceRequest: serviceRequest)
    }
    
    @discardableResult
    public func getCoupons(limit: Int? = nil, offset: Int? = nil, in context: NSManagedObjectContext, completion: @escaping (_ couponObjectIDs: [NSManagedObjectID], _ error: Error?) -> Void) -> URLSessionDataTask? {
        return couponService.getCoupons(limit: limit, offset: offset) { json, error in
            context.performOnImportQueue {
                var couponObjectIDs: [NSManagedObjectID] = []
                defer {
                    DispatchQueue.global().async {
                        completion(couponObjectIDs, error)
                    }
                }
                for couponJSON in (json?["coupons"] as? [JSONObject]) ?? [] {
                    guard let coupon = Coupon.fetchOrCreate(json: couponJSON, context: context) else { continue }
                    if coupon.objectID.isTemporaryID == true {
                        try? context.obtainPermanentIDs(for: [coupon])
                    }
                    couponObjectIDs.append(coupon.objectID)
                }
                context.persist()
            }
        }
    }
    
    @discardableResult
    public func createCoupon(id: String, amountOff: Int?, percentOff: Int?, maxRedemptions: Int?, name: String, redeemBy: Date, discountBookingFee: Bool, isCorporate: Bool, in context: NSManagedObjectContext, completion: @escaping (_ couponObjectID: NSManagedObjectID?, _ error: Error?) -> Void) -> URLSessionDataTask? {
        return couponService.createCoupon(id: id, amountOff: amountOff, percentOff: percentOff, maxRedemptions: maxRedemptions, name: name, redeemBy: redeemBy, discountBookingFee: discountBookingFee, isCorporate: isCorporate) { json, error in
            context.performOnImportQueue {
                var couponObjectID: NSManagedObjectID?
                defer {
                    DispatchQueue.global().async {
                        completion(couponObjectID, error)
                    }
                }
                guard let json = json,
                    let coupon = Coupon.fetchOrCreate(json: json, context: context) else { return }
                context.persist()
                couponObjectID = coupon.objectID
            }
        }
    }
    
    @discardableResult
    public func deleteCoupon(id: String, in context: NSManagedObjectContext, completion: @escaping (_ error: Error?) -> Void) -> URLSessionDataTask? {
        return couponService.deleteCoupon(couponID: id) { json, error in
            context.performOnImportQueue {
                defer {
                    DispatchQueue.global().async {
                        completion(error)
                    }
                }
                if let couponToDelete = Coupon.fetch(with: id, in: context) {
                    context.delete(couponToDelete)
                }
            }
        }
    }
    
}
