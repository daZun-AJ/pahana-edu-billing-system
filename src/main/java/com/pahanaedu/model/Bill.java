package com.pahanaedu.model;


import java.util.Date;
import java.util.List;

public class Bill {

	private int id;
    private String billNumber;
    private Customer customer;
    private User staff;
    private Date billDate;
    private double totalAmount;
    private List<BillItem> items;
    
    
    public Bill() {}

    public Bill(int id, String billNumber, Customer customer, User staff, Date billDate, double totalAmount, List<BillItem> items) {
        this.id = id;
        this.billNumber = billNumber;
        this.customer = customer;
        this.staff = staff;
        this.billDate = billDate;
        this.totalAmount = totalAmount;
        this.items = items;
    }

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getBillNumber() {
		return billNumber;
	}

	public void setBillNumber(String billNumber) {
		this.billNumber = billNumber;
	}

	public Customer getCustomer() {
		return customer;
	}

	public void setCustomer(Customer customer) {
		this.customer = customer;
	}

	public User getStaff() {
		return staff;
	}

	public void setStaff(User staff) {
		this.staff = staff;
	}

	public Date getBillDate() {
		return billDate;
	}

	public void setBillDate(Date billDate) {
		this.billDate = billDate;
	}

	public double getTotalAmount() {
		return totalAmount;
	}

	public void setTotalAmount(double totalAmount) {
		this.totalAmount = totalAmount;
	}

	public List<BillItem> getItems() {
		return items;
	}

	public void setItems(List<BillItem> items) {
		this.items = items;
	}
    
    
    
    
	
}
