package com.quanrong.workbench.service.Impl;

import com.quanrong.settings.domain.User;
import com.quanrong.utils.DateUtil;
import com.quanrong.utils.UUIDUtil;
import com.quanrong.workbench.dao.ActivityDao;
import com.quanrong.workbench.domian.Activity;
import com.quanrong.workbench.service.ActivityService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;

@Service
public class ActivityServiceImpl implements ActivityService {
    @Resource
    ActivityDao dao;
    @Override
    public List<User> getUserList() {
        List<User> userList = dao.getUserList();
        return userList;
    }

    @Override
    public int saveActivity(Activity activity) {
        activity.setId(UUIDUtil.getUUID());
        activity.setCreateTime(DateUtil.getSystemTime());
        int result = dao.saveActivity(activity);
        return result;
    }

//    @Override
//    public List<Activity> pageList(Map map) {
//        List<Activity> dataList = dao.pageList(map);
//        map.put("total",)
//        return null;
//    }
}
