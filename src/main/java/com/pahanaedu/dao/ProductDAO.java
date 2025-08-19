package com.pahanaedu.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import com.pahanaedu.model.Product;

public class ProductDAO {

	private Connection connection;
	
	
	public ProductDAO() {
		this.connection = DBConnectionFactory.getConnection();
	}
	
	
	//	ADD PRODUCT
	public void addProduct(Product product) {
		String query = "INSERT INTO products (name, price, quantity, category, image) VALUES (?, ?, ?, ?, ?)";
		
		try {
			PreparedStatement statement = connection.prepareStatement(query);
			
			statement.setString(1, product.getName());
			statement.setDouble(2, product.getPrice());
            statement.setInt(3, product.getQuantity());
            statement.setString(4, product.getCategory());
            statement.setString(5, product.getImage());
            statement.executeUpdate();
		} catch (SQLException e) {
			// TODO: handle exception
			e.printStackTrace();
		}
	}
	
}
