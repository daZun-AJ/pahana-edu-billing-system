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

    public UserController() {
        super();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) action = "";

        switch (action) {
            case "list":
                listUsers(request, response);
                break;

            case "logout":
                HttpSession s = request.getSession(false);
                if (s != null) s.invalidate();
                response.sendRedirect("views/login.jsp");
                break;

            default:
                response.sendRedirect("views/login.jsp");
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) action = "";

        switch (action) {
            case "add":
                addUser(request, response);
                break;

            case "login":
                login(request, response);
                break;

            case "logout":
                logout(request, response);  // Call the logout method here
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

            case "update":
                updateUser(request, response);
                break;

            default:
                response.sendRedirect("views/login.jsp");
                break;
        }
    }

    // ADD USER
    private void addUser(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String role = request.getParameter("role");

        User user = new User();
        user.setUsername(username);
        user.setPassword(password);
        user.setRole(role);

        userDAO.addUser(user);
        response.sendRedirect(request.getContextPath() + "/UserController?action=list&msg=User Added Successfully");
    }

    // GET ALL USERS
    private void listUsers(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<User> users = userDAO.getAllUsers();
        request.setAttribute("users", users);

        request.getRequestDispatcher("views/user-list.jsp").forward(request, response);
    }

    // EDIT USER
    private void editUser(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        User editUser = userDAO.getUserById(id);
        request.setAttribute("editUser", editUser);
        request.getRequestDispatcher("views/edit-user.jsp").forward(request, response);
    }

    // UPDATE USER
    private void updateUser(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String role = request.getParameter("role");

        // If password is left blank - keep old password
        User existingUser = userDAO.getUserById(id);
        if (password == null || password.trim().isEmpty()) {
            password = existingUser.getPassword();
        }

        User user = new User();
        user.setId(id);
        user.setUsername(username);
        user.setPassword(password);
        user.setRole(role);

        userDAO.updateUser(user);

        // Redirect back to user list with toast message
        response.sendRedirect(request.getContextPath() + "/UserController?action=list&msg=User Updated Successfully");
    }

    // DELETE USER
    private void deleteUser(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        userDAO.deleteUser(id);
        response.sendRedirect(request.getContextPath() + "/UserController?action=list&msg=User Deleted Successfully");
    }

    // LOGIN
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
    
    
    
    // Corrected Logout Method
    private void logout(HttpServletRequest request, HttpServletResponse response) throws IOException {
        User user = (User) request.getSession().getAttribute("user");

        if (user != null) {
            // Set user status as offline
            userDAO.setUserOffline(user.getId());

            // Invalidate session after updating the status
            HttpSession session = request.getSession(false);
            if (session != null) session.invalidate();
        }

        // Redirect to login page after logout
        response.sendRedirect("views/login.jsp");
    }



}
