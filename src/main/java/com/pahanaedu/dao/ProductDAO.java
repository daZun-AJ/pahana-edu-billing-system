package com.pahanaedu.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.pahanaedu.model.Product;

public class ProductDAO {

	private Connection connection;
	
	
	public ProductDAO() {
		this.connection = DBConnectionFactory.getConnection();
	}
	
	
	//	ADD PRODUCT
	public void addProduct(Product product) {
		String query = "INSERT INTO products (product_code, name, price, quantity, category) VALUES (?, ?, ?, ?, ?)";
		
		try {
			PreparedStatement statement = connection.prepareStatement(query);
			
			statement.setString(1, product.getProductCode());
			statement.setString(2, product.getName());
			statement.setDouble(3, product.getPrice());
            statement.setInt(4, product.getQuantity());
            statement.setString(5, product.getCategory());
            
            statement.executeUpdate();
		} catch (SQLException e) {
			// TODO: handle exception
			e.printStackTrace();
		}
	}
	
	
	//	GET ALL PRODUCTS
	public List<Product> getAllProducts() {
		List<Product> products = new ArrayList<>();
		String query = "SELECT * FROM products";
		
		try {
			Statement statement = connection.createStatement();
			ResultSet resultSet = statement.executeQuery(query);
			
			while (resultSet.next()) {
				Product product = new Product(
						resultSet.getInt("id"),
						resultSet.getString("product_code"),
                        resultSet.getString("name"),
                        resultSet.getDouble("price"),
                        resultSet.getInt("quantity"),
                        resultSet.getString("category")
				);
				
				products.add(product);
			}
		} catch (SQLException e) {
			// TODO: handle exception
			e.printStackTrace();
		}
		
		return products;
	}
	
	
	
	//	GET PRODUCT BY ID
	public Product getProductById(int id) {
		Product product = null;
		String query = "SELECT * FROM products WHERE id=?";
		
		try {
			PreparedStatement statement = connection.prepareStatement(query);
			statement.setInt(1, id);
			ResultSet resultSet = statement.executeQuery();
			
			if (resultSet.next()) {
				product = new Product(
						resultSet.getInt("id"),
						resultSet.getString("product_code"),
                        resultSet.getString("name"),
                        resultSet.getDouble("price"),
                        resultSet.getInt("quantity"),
                        resultSet.getString("category")
				);
			}
		} catch (SQLException e) {
			// TODO: handle exception
			e.printStackTrace();
		}
		
		return product;
	}
	
	
	
	//	UPDATE PRODUCT
	public void updateProduct(Product product) {
		String query = "UPDATE products SET product_code=?, name=?, price=?, quantity=?, category=? WHERE id=?";
		
		try {
			PreparedStatement statement = connection.prepareStatement(query);
			statement.setString(1, product.getProductCode());
			statement.setString(2, product.getName());
            statement.setDouble(3, product.getPrice());
            statement.setInt(4, product.getQuantity());
            statement.setString(5, product.getCategory());
            statement.setInt(6, product.getId());
            statement.executeUpdate();
		} catch (SQLException e) {
			// TODO: handle exception
			e.printStackTrace();
		}
	}
	
	
	
	//	DELETE PRODUCT
	public void deleteProduct(int id) {
		String query = "DELETE FROM products WHERE id=?";
		
		try {
			PreparedStatement statement = connection.prepareStatement(query);
			statement.setInt(1, id);
			statement.executeUpdate();
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
	}
	
}
