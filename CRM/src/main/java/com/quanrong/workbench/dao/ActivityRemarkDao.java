package com.quanrong.workbench.dao;

import com.quanrong.workbench.domian.ActivityRemark;

import java.util.List;

public interface ActivityRemarkDao {
    int saveRemark(ActivityRemark remark);

    List<ActivityRemark> getActivityRemarkList();
}
