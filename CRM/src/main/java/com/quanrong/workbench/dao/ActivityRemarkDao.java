package com.quanrong.workbench.dao;

import com.quanrong.workbench.domian.ActivityRemark;

import java.util.List;

public interface ActivityRemarkDao {
    int saveRemark(ActivityRemark remark);

    List<ActivityRemark> getActivityRemarkList(String activityId);

    int delRemarks(String[] ids);

    int delRemark(String id);

    int editRemark(ActivityRemark remark);

    ActivityRemark getRemark(String id);
}
