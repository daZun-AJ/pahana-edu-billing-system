package com.pahanaedu.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

import com.pahanaedu.dao.ProductDAO;
import com.pahanaedu.model.Product;

/**
 * Servlet implementation class ProductController
 */
@WebServlet("/ProductController")
public class ProductController extends HttpServlet {
	private static final long serialVersionUID = 1L;
    
	private ProductDAO productDAO;
	
	public void init() {
		productDAO = new ProductDAO();
	}
	
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ProductController() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		String action = request.getParameter("action");
		
		if (action == null) {
			action = "";
		}
		
		switch (action) {
		case "list":
			listProducts(request, response);
			break;
			
		case "new":
			request.getRequestDispatcher("views/add-product.jsp").forward(request, response);
			break;
		
		case "edit":
            showEditForm(request, response);
            break;
            
        case "delete":
            deleteProduct(request, response);
            break;
			
		default:
			listProducts(request, response);
		}
		
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
            addProduct(request, response);
            break;
            
        case "update":
            updateProduct(request, response);
            break;
            
        default:
            response.sendRedirect("ProductController?action=list");
    }
	}
	
	
	
	
	//	Methods
	private void listProducts(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Product> products = productDAO.getAllProducts();
        request.setAttribute("products", products);
        request.getRequestDispatcher("views/product-list.jsp").forward(request, response);
    }
	
	
	private void addProduct(HttpServletRequest request, HttpServletResponse response) throws IOException {
        Product product = new Product();
        product.setName(request.getParameter("name"));
        product.setPrice(Double.parseDouble(request.getParameter("price")));
        product.setQuantity(Integer.parseInt(request.getParameter("quantity")));
        product.setCategory(request.getParameter("category"));
        product.setImage(request.getParameter("image")); // Handle file upload separately if needed
        productDAO.addProduct(product);
        response.sendRedirect("ProductController?action=list&msg=Product Added");
    }
	
	
	private void showEditForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Product product = productDAO.getProductById(id);
        request.setAttribute("product", product);
        request.getRequestDispatcher("views/edit-product.jsp").forward(request, response);
    }
	
	
	private void updateProduct(HttpServletRequest request, HttpServletResponse response) throws IOException {
        Product product = new Product();
        product.setId(Integer.parseInt(request.getParameter("id")));
        product.setName(request.getParameter("name"));
        product.setPrice(Double.parseDouble(request.getParameter("price")));
        product.setQuantity(Integer.parseInt(request.getParameter("quantity")));
        product.setCategory(request.getParameter("category"));
        product.setImage(request.getParameter("image"));
        productDAO.updateProduct(product);
        response.sendRedirect("ProductController?action=list&msg=Product Updated");
    }
	
	
	private void deleteProduct(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        productDAO.deleteProduct(id);
        response.sendRedirect("ProductController?action=list&msg=Product Deleted");
    }
	
}
