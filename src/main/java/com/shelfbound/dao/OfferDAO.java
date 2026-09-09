package com.shelfbound.dao;

import java.util.List;
import com.shelfbound.model.Offer;

public interface OfferDAO {
    List<Offer> getAllOffers();
    List<Offer> getActiveOffers();
    Offer getOfferById(int offerId);
    Offer getOfferByCode(String couponCode);
    boolean addOffer(Offer offer);
    boolean deleteOffer(int offerId);
    boolean updateOfferStatus(int offerId, String status);
    boolean updateOffer(Offer offer);
    boolean isCouponCodeExists(String couponCode);
    boolean isCouponCodeExistsForOther(String couponCode, int offerId);
}
