package com.emaraldauction.ee.ejb.bean;

import com.emaraldauction.ee.core.database.Database;
import com.emaraldauction.ee.core.entity.User;
import com.emaraldauction.ee.ejb.remote.AuthManager;
import jakarta.ejb.Stateless;

@Stateless
public class AuthManagerBean implements AuthManager {

    @Override
    public User login(String email, String password) {
        if (email == null || password == null) {
            return null;
        }
        return Database.USERS_LIST.stream().filter(user -> email.equals(user.getEmail()) && password.equals(user.getPassword())).findFirst().orElse(null);
    }

}