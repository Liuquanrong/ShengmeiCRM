package com.quanrong.workbench.service.Impl;

import com.quanrong.utils.DateUtil;
import com.quanrong.utils.UUIDUtil;
import com.quanrong.workbench.dao.ActivityRemarkDao;
import com.quanrong.workbench.domian.ActivityRemark;
import com.quanrong.workbench.service.ActivityRemarkService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;

@Service
public class ActivityRemarkServiceImpl implements ActivityRemarkService {
    @Resource
    ActivityRemarkDao dao;

    @Override
    public int saveRemark(ActivityRemark remark) {
        String createTime = DateUtil.getSystemTime();
        String id = UUIDUtil.getUUID();
        remark.setId(id);
        remark.setCreateTime(createTime);
        int result = dao.saveRemark(remark);
        return result;
    }
}
