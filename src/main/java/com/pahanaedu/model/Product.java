package com.pahanaedu.model;

public class Product {
	
	private int id;
	private String productCode;
    private String name;
    private double price;
    private int quantity;
    private String category;
	
    public Product() {}
    
    public Product(int id, String productCode, String name, double price, int quantity, String category) {
		this.id = id;
		this.productCode = productCode;
		this.name = name;
		this.price = price;
		this.quantity = quantity;
		this.category = category;
		
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}
	
	public String getProductCode() {
		return productCode;
	}

	public void setProductCode(String productCode) {
		this.productCode = productCode;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public double getPrice() {
		return price;
	}

	public void setPrice(double price) {
		this.price = price;
	}

	public int getQuantity() {
		return quantity;
	}

	public void setQuantity(int quantity) {
		this.quantity = quantity;
	}

	public String getCategory() {
		return category;
	}

	public void setCategory(String category) {
		this.category = category;
	}
}
