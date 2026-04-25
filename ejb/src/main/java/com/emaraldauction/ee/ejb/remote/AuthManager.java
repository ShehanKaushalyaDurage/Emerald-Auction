package com.emaraldauction.ee.ejb.remote;

import com.emaraldauction.ee.core.entity.User;
import jakarta.ejb.Remote;

@Remote
public interface AuthManager {

    User login(String email, String password);

}
