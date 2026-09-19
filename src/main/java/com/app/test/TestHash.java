package com.app.test;

import org.mindrot.jbcrypt.BCrypt;
import java.sql.Connection;
import java.sql.PreparedStatement;
import com.app.utility.DBConnection;

public class TestHash {
    public static void main(String[] args) throws Exception {
        String newHash = BCrypt.hashpw("password123", BCrypt.gensalt(12));
        System.out.println("Generated Hash for 'password123': " + newHash);
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement("UPDATE users SET password = ? WHERE username = 'admin'")) {
            stmt.setString(1, newHash);
            int rows = stmt.executeUpdate();
            System.out.println("✅ Database updated successfully! Rows affected: " + rows);
        }
    }
}
