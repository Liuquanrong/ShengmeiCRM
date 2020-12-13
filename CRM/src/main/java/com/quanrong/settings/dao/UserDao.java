package com.quanrong.settings.dao;

import com.quanrong.settings.domain.User;

import java.util.Map;

public interface UserDao {
    User login(Map<String,String> user);
}
