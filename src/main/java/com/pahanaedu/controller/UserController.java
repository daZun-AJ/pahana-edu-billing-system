package com.pahanaedu.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

import com.pahanaedu.dao.UserDAO;
import com.pahanaedu.model.User;

/**
 * Servlet implementation class UserController
 */
@WebServlet("/UserController")
public class UserController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private UserDAO userDAO;
	
	public void init() {
		userDAO = new UserDAO();
	}
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public UserController() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.getWriter().append("Served at: ").append(request.getContextPath());
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		String action = request.getParameter("action");
		
		if (action == null) {
			action = "";
		}
		
		switch (action) {
			case "add":
				addUser(request, response);
				break;
				
			case "login":
				login(request, response);
				break;
				
			case "logout":
			    HttpSession s = request.getSession(false);
			    if (s != null) s.invalidate();
			    response.sendRedirect("views/login.jsp");
			    break;
				
			case "list":
				listUsers(request, response);
				break;
			
			case "edit":
				editUser(request, response);
				break;
			
			case "delete":
				deleteUser(request, response);
				break;
				
			default:
				response.sendRedirect("views/login.jsp");
				break;
		}
		
	}
	
	
	
	
	//	ADD USER
	private void addUser(HttpServletRequest request, HttpServletResponse response) throws IOException {
		String username = request.getParameter("username");
        String password = request.getParameter("password");
        String role = request.getParameter("role");
        
        User user = new User();
        user.setUsername(username);
        user.setPassword(password);
        user.setRole(role);
        
        userDAO.addUser(user);
        response.sendRedirect("views/admin-dashboard.jsp?msg=User Added");
	}
	
	
	
	//	GET ALL USERS
	private void listUsers(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	    List<User> users = userDAO.getAllUsers();
	    request.setAttribute("users", users);

	    // forward to JSP to display users
	    request.getRequestDispatcher("views/user-list.jsp").forward(request, response);
	}

	
	
	
	//	EDIT USER
	private void editUser(HttpServletRequest request, HttpServletResponse response) throws IOException {
		int id = Integer.parseInt(request.getParameter("id"));
		String username = request.getParameter("username");
        String password = request.getParameter("password");
        String role = request.getParameter("role");
        
        User user = new User(id, username, password, role, false);
        userDAO.updateUser(user);
        
        response.sendRedirect("views/admin-dashboard.jsp?msg=User Updated");
	}
	
	
	
	//	DELETE USER
	private void deleteUser(HttpServletRequest request, HttpServletResponse response) throws IOException {
		int id = Integer.parseInt(request.getParameter("id"));
        userDAO.deleteUser(id);        
        response.sendRedirect("views/admin-dashboard.jsp?msg=User Updated");
	}
	
	
	
	//	LOGIN
	private void login(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String username = request.getParameter("username");
		String password = request.getParameter("password");
		
		User user = userDAO.login(username, password);
		
		if (user != null) {
			HttpSession session = request.getSession();
			session.setAttribute("user", user);
			
			if ("admin".equals(user.getRole())) {
				response.sendRedirect("views/admin-dashboard.jsp");
			} else {
				response.sendRedirect("views/staff-dashboard.jsp");
			}
		} else {
			request.setAttribute("errorMessage", "Invalid username or password");
			request.getRequestDispatcher("views/login.jsp").forward(request, response);
		}
	}
	
	
	
	

}
