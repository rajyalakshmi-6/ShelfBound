package com.shelfbound.servlet.admin;

import java.io.IOException;
import java.util.List;

import com.shelfbound.dao.OfferDAO;
import com.shelfbound.daoimpl.OfferDAOImpl;
import com.shelfbound.model.Offer;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class AdminOfferServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminId") == null) {
            response.sendRedirect(request.getContextPath() + "/adminLogin");
            return;
        }

        String action = request.getParameter("action");
        OfferDAO dao = new OfferDAOImpl();

        try {
            if ("delete".equalsIgnoreCase(action)) {
                String idStr = request.getParameter("id");
                if (idStr != null && !idStr.trim().isEmpty()) {
                    int offerId = Integer.parseInt(idStr.trim());
                    dao.deleteOffer(offerId);
                    response.sendRedirect(request.getContextPath() + "/adminOffer?success=Offer+deleted+successfully");
                    return;
                }
            }

            // Default: View all offers
            List<Offer> offers = dao.getAllOffers();
            request.setAttribute("offers", offers);
            request.getRequestDispatcher("/admin/manage-offers.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/adminOffer?error=An+error+occurred");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminId") == null) {
            response.sendRedirect(request.getContextPath() + "/adminLogin");
            return;
        }

        String action = request.getParameter("action");
        OfferDAO dao = new OfferDAOImpl();

        try {
            if ("add".equalsIgnoreCase(action)) {
                String couponCode = request.getParameter("couponCode");
                String discountStr = request.getParameter("discountPercentage");
                String description = request.getParameter("description");
                String minOrderStr = request.getParameter("minOrderAmount");
                String status = request.getParameter("status");

                if (couponCode == null || couponCode.trim().isEmpty()) {
                    response.sendRedirect(request.getContextPath() + "/adminOffer?error=Coupon+code+is+required");
                    return;
                }

                couponCode = couponCode.trim().toUpperCase();

                if (dao.isCouponCodeExists(couponCode)) {
                    response.sendRedirect(request.getContextPath() + "/adminOffer?error=Coupon+code+already+exists");
                    return;
                }

                double discount = 0.0;
                try {
                    discount = Double.parseDouble(discountStr);
                } catch (Exception ex) {
                    response.sendRedirect(request.getContextPath() + "/adminOffer?error=Invalid+discount+percentage");
                    return;
                }

                if (discount <= 0 || discount > 100) {
                    response.sendRedirect(request.getContextPath() + "/adminOffer?error=Discount+must+be+between+1+and+100%");
                    return;
                }

                double minOrder = 0.0;
                if (minOrderStr != null && !minOrderStr.trim().isEmpty()) {
                    try {
                        minOrder = Double.parseDouble(minOrderStr);
                    } catch (Exception ex) {
                        minOrder = 0.0;
                    }
                }

                if (status == null || (!status.equalsIgnoreCase("ACTIVE") && !status.equalsIgnoreCase("INACTIVE"))) {
                    status = "ACTIVE";
                }

                Offer newOffer = new Offer(couponCode, discount, description, minOrder, status.toUpperCase());
                boolean added = dao.addOffer(newOffer);

                if (added) {
                    response.sendRedirect(request.getContextPath() + "/adminOffer?success=Offer+" + couponCode + "+created+successfully");
                } else {
                    response.sendRedirect(request.getContextPath() + "/adminOffer?error=Failed+to+create+offer");
                }

            } else if ("edit".equalsIgnoreCase(action)) {
                String idStr = request.getParameter("offerId");
                String couponCode = request.getParameter("couponCode");
                String discountStr = request.getParameter("discountPercentage");
                String description = request.getParameter("description");
                String minOrderStr = request.getParameter("minOrderAmount");
                String status = request.getParameter("status");

                if (idStr == null || idStr.trim().isEmpty()) {
                    response.sendRedirect(request.getContextPath() + "/adminOffer?error=Invalid+offer+ID");
                    return;
                }

                int offerId = Integer.parseInt(idStr.trim());

                if (couponCode == null || couponCode.trim().isEmpty()) {
                    response.sendRedirect(request.getContextPath() + "/adminOffer?error=Coupon+code+is+required");
                    return;
                }

                couponCode = couponCode.trim().toUpperCase();

                if (dao.isCouponCodeExistsForOther(couponCode, offerId)) {
                    response.sendRedirect(request.getContextPath() + "/adminOffer?error=Coupon+code+already+in+use+by+another+offer");
                    return;
                }

                double discount = 0.0;
                try {
                    discount = Double.parseDouble(discountStr);
                } catch (Exception ex) {
                    response.sendRedirect(request.getContextPath() + "/adminOffer?error=Invalid+discount+percentage");
                    return;
                }

                if (discount <= 0 || discount > 100) {
                    response.sendRedirect(request.getContextPath() + "/adminOffer?error=Discount+must+be+between+1+and+100%");
                    return;
                }

                double minOrder = 0.0;
                if (minOrderStr != null && !minOrderStr.trim().isEmpty()) {
                    try {
                        minOrder = Double.parseDouble(minOrderStr);
                    } catch (Exception ex) {
                        minOrder = 0.0;
                    }
                }

                if (status == null || (!status.equalsIgnoreCase("ACTIVE") && !status.equalsIgnoreCase("INACTIVE"))) {
                    status = "ACTIVE";
                }

                Offer offer = new Offer(offerId, couponCode, discount, description, minOrder, status.toUpperCase(), null);
                boolean updated = dao.updateOffer(offer);

                if (updated) {
                    response.sendRedirect(request.getContextPath() + "/adminOffer?success=Offer+" + couponCode + "+updated+successfully");
                } else {
                    response.sendRedirect(request.getContextPath() + "/adminOffer?error=Failed+to+update+offer");
                }

            } else if ("delete".equalsIgnoreCase(action)) {
                String idStr = request.getParameter("offerId");
                if (idStr != null && !idStr.trim().isEmpty()) {
                    int offerId = Integer.parseInt(idStr.trim());
                    dao.deleteOffer(offerId);
                    response.sendRedirect(request.getContextPath() + "/adminOffer?success=Offer+deleted+successfully");
                } else {
                    response.sendRedirect(request.getContextPath() + "/adminOffer?error=Invalid+offer+ID");
                }

            } else if ("toggle".equalsIgnoreCase(action)) {
                String idStr = request.getParameter("offerId");
                String newStatus = request.getParameter("status");
                if (idStr != null && !idStr.trim().isEmpty() && newStatus != null) {
                    int offerId = Integer.parseInt(idStr.trim());
                    dao.updateOfferStatus(offerId, newStatus.trim().toUpperCase());
                    response.sendRedirect(request.getContextPath() + "/adminOffer?success=Offer+status+updated+to+" + newStatus);
                } else {
                    response.sendRedirect(request.getContextPath() + "/adminOffer?error=Unable+to+update+status");
                }
            } else {
                response.sendRedirect(request.getContextPath() + "/adminOffer");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/adminOffer?error=Operation+failed");
        }
    }
}