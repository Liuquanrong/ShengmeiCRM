package com.quanrong.workbench.dao;

import com.quanrong.settings.domain.User;
import com.quanrong.workbench.domian.Activity;

import java.util.List;

public interface ActivityDao {
    List<User> getUserList();
    int saveActivity(Activity activity);
}
