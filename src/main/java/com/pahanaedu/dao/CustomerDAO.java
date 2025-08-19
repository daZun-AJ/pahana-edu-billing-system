package com.pahanaedu.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.pahanaedu.model.Customer;

public class CustomerDAO {

	private Connection connection;
	
	public CustomerDAO() {
		this.connection = DBConnectionFactory.getConnection();
	}
	
	
	
	//	ADD CUSTOMER
	public void addCustomer(Customer customer) {
		String query = "INSERT INTO customers (account_number, name, address, phone_number, email) VALUES (?, ?, ?, ?, ?)";
		
		try {
			PreparedStatement statement = connection.prepareStatement(query);
			
			statement.setString(1, customer.getAccountNumber());
			statement.setString(2, customer.getName());
			statement.setString(3, customer.getAddress());
			statement.setString(4, customer.getPhoneNumber());
			statement.setString(5, customer.getEmail());
			statement.executeUpdate();
		} catch (SQLException e) {
			// TODO: handle exception
			e.printStackTrace();
		}
	}
	
	
	
	
	//	GET ALL USERS
	public List<Customer> getAllCustomers() {
		List<Customer> customers = new ArrayList<>();
		String query = "SELECT * FROM customers ORDER BY id DESC";
		
		try {
			Statement statement = connection.createStatement();
			ResultSet resultSet = statement.executeQuery(query);
			
			while (resultSet.next()) {
				Customer customer = new Customer();
				customer.setId(resultSet.getInt("id"));
				customer.setAccountNumber(resultSet.getString("account_number"));
				customer.setName(resultSet.getString("name"));
				customer.setAddress(resultSet.getString("address"));
				customer.setPhoneNumber(resultSet.getString("phone_number"));
				customer.setEmail(resultSet.getString("email"));
				
				customers.add(customer);
			}
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
		return customers;
	}
	
	
	
	
	//	GET CUSTOMER BY ID
	public Customer getCustomerById(int id) {
		String query = "SELECT * FROM customers WHERE id=?";
		
		try {
			PreparedStatement statement = connection.prepareStatement(query);
			statement.setInt(1, id);
			try {
				ResultSet resultSet = statement.executeQuery();
				if (resultSet.next()) {
					Customer customer = new Customer();
					
					customer.setId(resultSet.getInt("id"));
                    customer.setAccountNumber(resultSet.getString("account_number"));
                    customer.setName(resultSet.getString("name"));
                    customer.setAddress(resultSet.getString("address"));
                    customer.setPhoneNumber(resultSet.getString("phone_number"));
                    customer.setEmail(resultSet.getString("email"));
                    return customer;
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	
	
	
	//	UPDATE CUSTOMER
	public void updateCustomer(Customer customer) {
		String query = "UPDATE customers SET account_number=?, name=?, address=?, phone_number=?, email=? WHERE id=?";
		
		try {
			PreparedStatement statement = connection.prepareStatement(query);
			statement.setString(1, customer.getAccountNumber());
            statement.setString(2, customer.getName());
            statement.setString(3, customer.getAddress());
            statement.setString(4, customer.getPhoneNumber());
            statement.setString(5, customer.getEmail());
            statement.setInt(6, customer.getId());
            statement.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	
	
	//	DELETE CUSTOMER
	public void deleteCustomer(int id) {
		String query = "DELETE FROM customers WHERE id=?";
		
		try {
			PreparedStatement statement = connection.prepareStatement(query);
			
			statement.setInt(1, id);
			statement.executeUpdate();
		} catch (SQLException e) {
			// TODO: handle exception
			e.printStackTrace();
		}
	}
	
	
}
