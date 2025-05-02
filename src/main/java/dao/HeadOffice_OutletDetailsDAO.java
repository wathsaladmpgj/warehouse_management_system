package dao;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import model.HeadOffice_OutletDetails;

public class HeadOffice_OutletDetailsDAO {
    
    public HeadOffice_OutletDetails getHighestPerformingOutlet() {
    String sql = "SELECT * FROM outlet_details ORDER BY total_registered_items DESC LIMIT 1";
    
    try (Connection conn = DBConnection.getConnection();
         Statement stmt = conn.createStatement();
         ResultSet rs = stmt.executeQuery(sql)) {
        
        if (rs.next()) {
            HeadOffice_OutletDetails outlet = new HeadOffice_OutletDetails();
            outlet.setId(rs.getInt("id"));
            outlet.setOutletName(rs.getString("outlet_name"));
            outlet.setTotalRegisteredItems(rs.getInt("total_registered_items"));
            outlet.setTotalReturnedItems(rs.getInt("total_returned_items"));
            outlet.setRemainingReturnedItems(rs.getInt("remaining_returned_items"));
            outlet.setAvailableNewItems(rs.getInt("available_new_items"));
            return outlet;
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return null;
}

 ////////////////////////////////////////////////////////////////////////////////////

    public List<HeadOffice_OutletDetails> getAllOutletDetails() {
        List<HeadOffice_OutletDetails> headOffice_OutletDetails = new ArrayList<>();

        String sql = "SELECT * FROM outlet_details";

        try (
                Connection conn = DBConnection.getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql);) {
            while (rs.next()) {
                HeadOffice_OutletDetails headOffice_OutletDetailsTemp = new HeadOffice_OutletDetails();
                headOffice_OutletDetailsTemp.setId(rs.getInt("id"));
                headOffice_OutletDetailsTemp.setOutletName(rs.getString("outlet_name"));
                headOffice_OutletDetailsTemp.setTotalRegisteredItems(rs.getInt("total_registered_items"));
                headOffice_OutletDetailsTemp.setTotalReturnedItems(rs.getInt("total_returned_items"));
                headOffice_OutletDetailsTemp.setRemainingReturnedItems(rs.getInt("remaining_returned_items"));
                headOffice_OutletDetailsTemp.setAvailableNewItems(rs.getInt("available_new_items"));
                headOffice_OutletDetails.add(headOffice_OutletDetailsTemp);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return headOffice_OutletDetails;
    }
}
