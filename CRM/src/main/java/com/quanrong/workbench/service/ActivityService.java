package com.quanrong.workbench.service;

import com.quanrong.settings.domain.User;
import com.quanrong.workbench.domian.Activity;

import java.util.List;
import java.util.Map;

public interface ActivityService {
    List<User> getUserList();
    int saveActivity(Activity activity);
    //List<Activity> pageList(Map map);
}
