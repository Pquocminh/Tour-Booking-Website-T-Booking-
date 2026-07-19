package model;

import java.sql.Timestamp;

public class Customer extends Account {

    public Customer() {
        super();
        this.setRole("Customer");
    }

    public Customer(int accountId, String username, String passwordHash, String email, 
                   String fullName, String phone, String address, String status, Timestamp createdAt) {
        super(accountId, username, passwordHash, email, fullName, phone, address, "Customer", status, createdAt);
    }
}
