package dao;

import model.Product;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProductDAO {

    private static final String SELECT_ALL_PRODUCTS = "SELECT * FROM product_details";
    private static final String SELECT_BY_TO_LOCATION = "SELECT * FROM product_details WHERE to_location = ?";
    private static final String SELECT_BY_FROM_LOCATION = "SELECT * FROM product_details WHERE from_location = ?";

    public List<Product> selectAllProducts() {
        List<Product> products = new ArrayList<>();
        try (Connection connection = DBConnection.getConnection();
                PreparedStatement preparedStatement = connection.prepareStatement(SELECT_ALL_PRODUCTS)) {

            ResultSet rs = preparedStatement.executeQuery();

            while (rs.next()) {
                int id = rs.getInt("id");
                String senderName = rs.getString("sender_name");
                String receiverName = rs.getString("receiver_name");
                String postalCode = rs.getString("postal_code");
                String receiverLocation = rs.getString("receiver_location");
                String productKey = rs.getString("product_key");
                double productWeight = rs.getDouble("product_weight");
                String fromLocation = rs.getString("from_location");
                String toLocation = rs.getString("to_location");
                Date addedDate = rs.getDate("added_date");

                products.add(new Product(id, senderName, receiverName, postalCode, receiverLocation,
                        productKey, productWeight, fromLocation, toLocation, addedDate));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return products;
    }

    public List<Product> selectProductsByToLocation(String location) {
        List<Product> products = new ArrayList<>();
        
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(SELECT_BY_TO_LOCATION)) {
            
            preparedStatement.setString(1, location);
            ResultSet rs = preparedStatement.executeQuery();
            
            while (rs.next()) {
                int id = rs.getInt("id");
                String senderName = rs.getString("sender_name");
                String receiverName = rs.getString("receiver_name");
                String postalCode = rs.getString("postal_code");
                String receiverLocation = rs.getString("receiver_location");
                String productKey = rs.getString("product_key");
                double productWeight = rs.getDouble("product_weight");
                String fromLocation = rs.getString("from_location");
                String toLocation = rs.getString("to_location");
                Date addedDate = rs.getDate("added_date");
                
                products.add(new Product(id, senderName, receiverName, postalCode, 
                                      receiverLocation, productKey, productWeight, 
                                      fromLocation, toLocation, addedDate));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return products;
    }
    
    // New method to select products by from_location
    public List<Product> selectProductsByFromLocation(String location) {
        List<Product> products = new ArrayList<>();
        
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(SELECT_BY_FROM_LOCATION)) {
            
            preparedStatement.setString(1, location);
            ResultSet rs = preparedStatement.executeQuery();
            
            while (rs.next()) {
                int id = rs.getInt("id");
                String senderName = rs.getString("sender_name");
                String receiverName = rs.getString("receiver_name");
                String postalCode = rs.getString("postal_code");
                String receiverLocation = rs.getString("receiver_location");
                String productKey = rs.getString("product_key");
                double productWeight = rs.getDouble("product_weight");
                String fromLocation = rs.getString("from_location");
                String toLocation = rs.getString("to_location");
                Date addedDate = rs.getDate("added_date");
                
                products.add(new Product(id, senderName, receiverName, postalCode, 
                                      receiverLocation, productKey, productWeight, 
                                      fromLocation, toLocation, addedDate));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return products;
    }
}
