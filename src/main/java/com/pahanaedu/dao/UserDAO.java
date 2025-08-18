package com.pahanaedu.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.pahanaedu.model.User;

public class UserDAO {

	//	ADD USER
	public void addUser(User user) {
		String query = "INSERT INTO users (username, password, role, isLogin) VALUES (?, ?, ?, FALSE)";
		
		try {
			Connection connection = DBConnectionFactory.getConnection();
			PreparedStatement statement = connection.prepareStatement(query);
			
			statement.setString(1, user.getUsername());
			statement.setString(2, user.getPassword());
			statement.setString(3, user.getRole());
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	
	
	
	//	GET ALL USERS
	public List<User> getAllUsers() {
		List<User> users = new ArrayList<User>();
		String query = "SELECT * FROM users";
		
		try {
			Connection connection = DBConnectionFactory.getConnection();
			PreparedStatement statement = connection.prepareStatement(query);
			ResultSet resultSet = statement.executeQuery();
			
			while (resultSet.next()) {
				int id = resultSet.getInt("id");
				String username = resultSet.getString("username");
				String password = resultSet.getString("password");
				String irole = resultSet.getString("role");
				boolean isLogin = resultSet.getBoolean("isLogin");
				
				users.add(new User(id, username, password, irole, isLogin));
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return users;
	}

	
	
	//	UPDATE USER
	public void updateUser(User user) {
		String query = "UPDATE users SET username=?, password=?, role=? WHERE id=?";
		
		try {
			Connection connection = DBConnectionFactory.getConnection();
			PreparedStatement statement = connection.prepareStatement(query);
			
			statement.setString(1, user.getUsername());
			statement.setString(2, user.getPassword());
			statement.setString(3, user.getRole());
			statement.setInt(4, user.getId());
			
			statement.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	
	
	
	//	DELETE USER
	public void deleteUser(int id) {
		String query = "DELETE FROM users WHERE id=?";
		
		try {
			Connection connection = DBConnectionFactory.getConnection();
			PreparedStatement statement = connection.prepareStatement(query);
			
			statement.setInt(1, id);
			statement.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	
	
	
	//	LOGIN USER
	public User login(String username, String password) {
		String query = "SELECT * FROM users WHERE username=? AND password=?";
		
		try {
			Connection connection = DBConnectionFactory.getConnection();
			PreparedStatement statement = connection.prepareStatement(query);
			
			statement.setString(1, username);
			statement.setString(2, password);
			
			ResultSet resultSet = statement.executeQuery();
			
			if (resultSet.next()) {
				User user = new User(
					resultSet.getInt("id"),
					resultSet.getString("username"),
					resultSet.getString("password"),
					resultSet.getString("role"),
					resultSet.getBoolean("isLogin")
				);
				
				
				//	SET isLogin = TRUE AFTER LOGIN
				String statusQuery = "UPDATE users SET isLogin=TRUE WHERE id=?";
				
				try {
					PreparedStatement updateStatement = connection.prepareStatement(statusQuery);
					updateStatement.setInt(1, user.getId());
					updateStatement.executeUpdate();
				} catch (Exception e) {
					// TODO: handle exception
				}
				
				return user;
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		return null;
	}
}
