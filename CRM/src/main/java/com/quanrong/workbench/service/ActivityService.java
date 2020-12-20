package com.quanrong.workbench.service;

import com.quanrong.Exception.delException;
import com.quanrong.VO.PaginationVO;
import com.quanrong.settings.domain.User;
import com.quanrong.workbench.domian.Activity;

import java.util.List;
import java.util.Map;

public interface ActivityService {
    List<User> getUserList();

    int saveActivity(Activity activity);

    PaginationVO<Activity> pageList(Map map);

    int delActivity(String[] ids);

    Activity getActivity(String id);

    int editActivity(Activity activity);
}
