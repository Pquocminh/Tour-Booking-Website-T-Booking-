package service;

import dao.AccountDAO;
import model.Account;
import utils.PasswordUtils;
import java.util.UUID;

public class AccountService {
    private final AccountDAO accountDAO = new AccountDAO();

    public Account login(String username, String password) {
        String md5Hash = PasswordUtils.hashMD5(password);
        Account acc = accountDAO.checkLogin(username, md5Hash);
        if (acc != null && "Active".equalsIgnoreCase(acc.getStatus())) {
            return acc;
        }
        return null;
    }

    public Account loginOrCreateGoogleAccount(String email, String fullName) {
        // 1. Check if email already exists
        Account acc = accountDAO.getAccountByEmail(email);
        if (acc != null) {
            if ("Active".equalsIgnoreCase(acc.getStatus())) {
                return acc;
            }
            return null; // Account suspended
        }

        // 2. Register new account if not exists
        Account newAcc = new Account();
        
        // Generate unique username based on email prefix
        String baseUsername = email.split("@")[0];
        String username = baseUsername;
        int count = 1;
        while (accountDAO.checkUsernameExists(username)) {
            username = baseUsername + (int)(Math.random() * 1000);
        }
        
        newAcc.setUsername(username);
        // Generate a random secure password hash for google account
        String randomPassword = UUID.randomUUID().toString();
        newAcc.setPasswordHash(PasswordUtils.hashMD5(randomPassword));
        newAcc.setEmail(email);
        newAcc.setFullName(fullName);
        newAcc.setPhone("");
        newAcc.setRole("Customer");
        newAcc.setStatus("Active");

        boolean inserted = accountDAO.insertAccount(newAcc);
        if (inserted) {
            return accountDAO.getAccountByEmail(email);
        }
        return null;
    }

    public String register(Account acc, String confirmPassword) {
        if (acc.getPasswordHash() == null || acc.getPasswordHash().trim().isEmpty()) {
            return "Password is required!";
        }
        if (!acc.getPasswordHash().equals(confirmPassword)) {
            return "Passwords do not match!";
        }
        if (accountDAO.checkUsernameExists(acc.getUsername())) {
            return "Username is already taken!";
        }
        if (accountDAO.getAccountByEmail(acc.getEmail()) != null) {
            return "Email is already registered!";
        }

        // Hash password before saving (since acc.getPasswordHash() contains the plain text password right now)
        String plainPassword = acc.getPasswordHash();
        acc.setPasswordHash(PasswordUtils.hashMD5(plainPassword));
        acc.setRole("Customer");
        acc.setStatus("Active");

        boolean inserted = accountDAO.insertAccount(acc);
        if (inserted) {
            return "success";
        }
        return "Registration failed. Please try again.";
    }
}
