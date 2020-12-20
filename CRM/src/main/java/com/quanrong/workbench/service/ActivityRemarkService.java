package com.quanrong.workbench.service;

import com.quanrong.VO.PaginationVO;
import com.quanrong.workbench.domian.ActivityRemark;


public interface ActivityRemarkService {
    int saveRemark(ActivityRemark remark);

    PaginationVO getPageList(String activityId,String pageNo,String pageSize);

    int delRemark(String id);

    int editRemark(ActivityRemark remark);

    ActivityRemark getRemark(String id);
}
