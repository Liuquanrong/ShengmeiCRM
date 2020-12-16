package com.quanrong.workbench.dao;

import com.quanrong.settings.domain.User;
import com.quanrong.workbench.domian.Activity;

import java.util.List;
import java.util.Map;

public interface ActivityDao {
    List<User> getUserList();

    int saveActivity(Activity activity);

    List<Activity> getActivityList(Map map);

    int delActivity(String[] ids);

    Activity getActivity(String id);
}
