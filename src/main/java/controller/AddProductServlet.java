import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.UUID;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/AddProductServlet")
public class AddProductServlet extends HttpServlet {
    private static final String DB_URL = "jdbc:mysql://localhost:3306/warehouse_management";
    private static final String DB_USER = "root";
    private static final String DB_PASS = "";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        
        // Get form parameters
        String senderName = request.getParameter("senderName");
        String receiverName = request.getParameter("receiverName");
        String postalCode = request.getParameter("postalCode");
        String receiverLocation = request.getParameter("receiverLocation");
        String productWeightStr = request.getParameter("productWeight");
        String date = request.getParameter("date");
        
        String adminLocation = request.getParameter("fromLocation");
        if (adminLocation == null || adminLocation.isEmpty()) {
            request.setAttribute("errorMessage", "Admin location not set in session. Please login again.");
            request.getRequestDispatcher("/pages/addProduct.jsp").forward(request, response);
            return;
        }

        // Generate a unique product key
        String productKey = UUID.randomUUID().toString().replace("-", "").substring(0, 12);
        
        Connection conn = null;
        PreparedStatement productStmt = null;
        PreparedStatement trackingStmt = null;
        PreparedStatement pricingStmt = null;
        PreparedStatement outletUpdateStmt = null;
        PreparedStatement countItemsStmt = null;
        PreparedStatement postalLookupStmt = null;
        PreparedStatement distancePriceStmt = null;
        PreparedStatement weightPriceStmt = null;
        PreparedStatement countReturnedItemsStmt = null;
        PreparedStatement countNewItemsStmt = null;
        ResultSet postalRs = null;
        ResultSet distancePriceRs = null;
        ResultSet weightPriceRs = null;
        ResultSet countItemsRs = null;
        ResultSet countReturnedItemsRs = null;
        ResultSet countNewItemsRs = null;

        try {
            double productWeight = Double.parseDouble(productWeightStr);

            // JDBC connection
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
            
            // Start transaction
            conn.setAutoCommit(false);

            // 1. Lookup warehouse location based on postal code
            String toLocation = null;
            String postalLookupSql = "SELECT location FROM warehouse_postal_codes WHERE postal_code = ?";
            postalLookupStmt = conn.prepareStatement(postalLookupSql);
            postalLookupStmt.setString(1, postalCode);
            postalRs = postalLookupStmt.executeQuery();
            
            if (postalRs.next()) {
                toLocation = postalRs.getString("location");
            } else {
                conn.rollback();
                request.setAttribute("errorMessage", "No warehouse found for postal code: " + postalCode);
                request.getRequestDispatcher("/pages/addProduct.jsp").forward(request, response);
                return;
            }

            // 2. Insert into product_details table
            String productSql = "INSERT INTO product_details " +
                     "(sender_name, receiver_name, postal_code, receiver_location, product_key, product_weight, from_location, to_location, added_date) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

            productStmt = conn.prepareStatement(productSql);
            productStmt.setString(1, senderName);
            productStmt.setString(2, receiverName);
            productStmt.setString(3, postalCode);
            productStmt.setString(4, receiverLocation);
            productStmt.setString(5, productKey);
            productStmt.setDouble(6, productWeight);
            productStmt.setString(7, adminLocation);
            productStmt.setString(8, toLocation);
            productStmt.setString(9, date);

            int productResult = productStmt.executeUpdate();

            if (productResult <= 0) {
                conn.rollback();
                request.setAttribute("errorMessage", "Failed to add product.");
                request.getRequestDispatcher("/pages/addProduct.jsp").forward(request, response);
                return;
            }

            // 3. Insert into location_tracking table
            String trackingSql = "INSERT INTO location_tracking " +
                               "(product_key, from_location, to_location, tracking_date, tracking_update) " +
                               "VALUES (?, ?, ?, ?, ?)";
            
            trackingStmt = conn.prepareStatement(trackingSql);
            trackingStmt.setString(1, productKey);
            trackingStmt.setString(2, adminLocation);
            trackingStmt.setString(3, toLocation);
            trackingStmt.setString(4, date);
            trackingStmt.setString(5, adminLocation);
            
            int trackingResult = trackingStmt.executeUpdate();
            
            if (trackingResult <= 0) {
                conn.rollback();
                request.setAttribute("errorMessage", "Product added but tracking update failed.");
                request.getRequestDispatcher("/pages/addProduct.jsp").forward(request, response);
                return;
            }

            // 4. Calculate and insert product pricing
            // 4a. Get distance-based price
            double distancePrice = 0;
            String distancePriceSql = "SELECT price FROM distance_pricing WHERE " +
                                    "(from_location = ? AND to_location = ?) OR " +
                                    "(from_location = ? AND to_location = ?)";
            distancePriceStmt = conn.prepareStatement(distancePriceSql);
            distancePriceStmt.setString(1, adminLocation);
            distancePriceStmt.setString(2, toLocation);
            distancePriceStmt.setString(3, toLocation);
            distancePriceStmt.setString(4, adminLocation);
            distancePriceRs = distancePriceStmt.executeQuery();
            
            if (distancePriceRs.next()) {
                distancePrice = distancePriceRs.getDouble("price");
            } else {
                conn.rollback();
                request.setAttribute("errorMessage", "No pricing found for route: " + adminLocation + " to " + toLocation);
                request.getRequestDispatcher("/pages/addProduct.jsp").forward(request, response);
                return;
            }

            // 4b. Get weight-based price
            double weightPrice = 0;
            String weightPriceSql = "SELECT price FROM weight_pricing WHERE ? BETWEEN " +
                                  "SUBSTRING_INDEX(weight_range, '-', 1) AND " +
                                  "SUBSTRING_INDEX(weight_range, '-', -1)";
            weightPriceStmt = conn.prepareStatement(weightPriceSql);
            weightPriceStmt.setDouble(1, productWeight);
            weightPriceRs = weightPriceStmt.executeQuery();
            
            if (weightPriceRs.next()) {
                weightPrice = weightPriceRs.getDouble("price");
            } else {
                conn.rollback();
                request.setAttribute("errorMessage", "No pricing found for weight: " + productWeight + "g");
                request.getRequestDispatcher("/pages/addProduct.jsp").forward(request, response);
                return;
            }

            // 4c. Calculate total price
            double totalPrice = distancePrice + weightPrice;

            // 4d. Insert into product_pricing table
            String pricingSql = "INSERT INTO product_pricing " +
                              "(product_key, item_price, price_date, admin_location) " +
                              "VALUES (?, ?, ?, ?)";
            
            pricingStmt = conn.prepareStatement(pricingSql);
            pricingStmt.setString(1, productKey);
            pricingStmt.setDouble(2, totalPrice);
            pricingStmt.setString(3, date);
            pricingStmt.setString(4, adminLocation);
            
            int pricingResult = pricingStmt.executeUpdate();
            
            if (pricingResult <= 0) {
                conn.rollback();
                request.setAttribute("errorMessage", "Product added but pricing update failed.");
                request.getRequestDispatcher("/pages/addProduct.jsp").forward(request, response);
                return;
            }

            // 5. Update outlet_details table
            // 5a. Count all items for this outlet
            String countItemsSql = "SELECT COUNT(*) AS item_count FROM product_details WHERE from_location = ?";
            countItemsStmt = conn.prepareStatement(countItemsSql);
            countItemsStmt.setString(1, adminLocation);
            countItemsRs = countItemsStmt.executeQuery();
            
            int itemCount = 0;
            if (countItemsRs.next()) {
                itemCount = countItemsRs.getInt("item_count");
            }

            // 5b. Count returned items for this outlet
            String countReturnedItemsSql = "SELECT COUNT(*) AS returned_count FROM location_tracking " +
                                         "WHERE tracking_update = 'Return_' + ?";
            countReturnedItemsStmt = conn.prepareStatement(countReturnedItemsSql);
            countReturnedItemsStmt.setString(1, adminLocation);
            countReturnedItemsRs = countReturnedItemsStmt.executeQuery();
            
            int returnedCount = 0;
            if (countReturnedItemsRs.next()) {
                returnedCount = countReturnedItemsRs.getInt("returned_count");
            }

            // 5c. Count new items for this outlet
            String countNewItemsSql = "SELECT COUNT(*) AS new_count FROM location_tracking " +
                                    "WHERE from_location = ? AND tracking_update = ?";
            countNewItemsStmt = conn.prepareStatement(countNewItemsSql);
            countNewItemsStmt.setString(1, adminLocation);
            countNewItemsStmt.setString(2, adminLocation);
            countNewItemsRs = countNewItemsStmt.executeQuery();
            
            int newCount = 0;
            if (countNewItemsRs.next()) {
                newCount = countNewItemsRs.getInt("new_count");
            }

            // 5d. Update outlet_details with all counts
            String outletUpdateSql = "UPDATE outlet_details SET " +
                                    "total_registered_items = ?, " +
                                    "remaining_returned_items = ?, " +
                                    "available_new_items = ? " +
                                    "WHERE outlet_name = ?";
            outletUpdateStmt = conn.prepareStatement(outletUpdateSql);
            outletUpdateStmt.setInt(1, itemCount);
            outletUpdateStmt.setInt(2, returnedCount);
            outletUpdateStmt.setInt(3, newCount);
            outletUpdateStmt.setString(4, adminLocation);
            
            int outletUpdateResult = outletUpdateStmt.executeUpdate();
            
            if (outletUpdateResult <= 0) {
                conn.rollback();
                request.setAttribute("errorMessage", "Product added but outlet update failed.");
                request.getRequestDispatcher("/pages/addProduct.jsp").forward(request, response);
                return;
            }

            // Commit transaction if all operations succeeded
            conn.commit();
            request.setAttribute("successMessage", 
                "Product added successfully! Tracking ID: " + productKey + 
                ", Total Price: Rs." + String.format("%.2f", totalPrice));

        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid product weight format.");
        } catch (ClassNotFoundException e) {
            request.setAttribute("errorMessage", "Database driver not found.");
            e.printStackTrace();
        } catch (SQLException e) {
            try {
                if (conn != null) conn.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            request.setAttribute("errorMessage", "Database error: " + e.getMessage());
            e.printStackTrace();
        } finally {
            // Close all resources
            try {
                if (postalRs != null) postalRs.close();
                if (distancePriceRs != null) distancePriceRs.close();
                if (weightPriceRs != null) weightPriceRs.close();
                if (countItemsRs != null) countItemsRs.close();
                if (countReturnedItemsRs != null) countReturnedItemsRs.close();
                if (countNewItemsRs != null) countNewItemsRs.close();
                if (postalLookupStmt != null) postalLookupStmt.close();
                if (distancePriceStmt != null) distancePriceStmt.close();
                if (weightPriceStmt != null) weightPriceStmt.close();
                if (countItemsStmt != null) countItemsStmt.close();
                if (countReturnedItemsStmt != null) countReturnedItemsStmt.close();
                if (countNewItemsStmt != null) countNewItemsStmt.close();
                if (outletUpdateStmt != null) outletUpdateStmt.close();
                if (productStmt != null) productStmt.close();
                if (trackingStmt != null) trackingStmt.close();
                if (pricingStmt != null) pricingStmt.close();
                if (conn != null) {
                    conn.setAutoCommit(true);
                    conn.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        request.getRequestDispatcher("/pages/addProduct.jsp").forward(request, response);
    }
}