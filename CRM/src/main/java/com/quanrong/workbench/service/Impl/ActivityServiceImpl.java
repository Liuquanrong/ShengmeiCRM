package com.quanrong.workbench.service.Impl;

import com.github.pagehelper.Page;
import com.github.pagehelper.PageHelper;
import com.quanrong.VO.PaginationVO;
import com.quanrong.settings.domain.User;
import com.quanrong.utils.DateUtil;
import com.quanrong.utils.UUIDUtil;
import com.quanrong.workbench.dao.ActivityDao;
import com.quanrong.workbench.dao.ActivityRemarkDao;
import com.quanrong.workbench.domian.Activity;
import com.quanrong.workbench.service.ActivityService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;

@Service
public class ActivityServiceImpl implements ActivityService {
    @Resource
    ActivityDao activityDao;
    @Resource
    ActivityRemarkDao remarkDao;
    @Override
    public List<User> getUserList() {
        List<User> userList = activityDao.getUserList();
        return userList;
    }

    @Override
    public int saveActivity(Activity activity) {
        activity.setId(UUIDUtil.getUUID());
        activity.setCreateTime(DateUtil.getSystemTime());
        int result = activityDao.saveActivity(activity);
        return result;
    }

    @Override
    public PaginationVO<Activity> pageList(Map map) {
        //使用PageHelper插件进行分页操作
        Page page = PageHelper.startPage((Integer)map.get("pageNo"),(Integer)map.get("pageSize"));
        List<Activity> dataList = activityDao.getActivityList(map);
        PaginationVO<Activity> vo = new PaginationVO<>();
        //Page对象的getTotal方法获取查询出来的总条数
        vo.setTotal((int) page.getTotal());
        vo.setDataList(dataList);
        return vo;
    }

    @Override
    public int delActivity(String[] ids){
        int result = activityDao.delActivity(ids);
        remarkDao.delRemarks(ids);
        return result;
    }

    @Override
    public Activity getActivity(String id) {
        Activity activity = activityDao.getActivity(id);
        return activity;
    }

    @Override
    public int editActivity(Activity activity) {
        String editTime = DateUtil.getSystemTime();
        activity.setEditTime(editTime);
        int result = activityDao.editActivity(activity);
        return result;
    }
}
