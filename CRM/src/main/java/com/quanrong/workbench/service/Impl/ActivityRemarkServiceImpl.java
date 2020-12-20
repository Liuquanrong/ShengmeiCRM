package com.quanrong.workbench.service.Impl;

import com.github.pagehelper.Page;
import com.github.pagehelper.PageHelper;
import com.quanrong.VO.PaginationVO;
import com.quanrong.utils.DateUtil;
import com.quanrong.utils.UUIDUtil;
import com.quanrong.workbench.dao.ActivityRemarkDao;
import com.quanrong.workbench.domian.ActivityRemark;
import com.quanrong.workbench.service.ActivityRemarkService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

@Service
public class ActivityRemarkServiceImpl implements ActivityRemarkService {
    @Resource
    ActivityRemarkDao remarkDao;

    @Override
    public int saveRemark(ActivityRemark remark) {
        String createTime = DateUtil.getSystemTime();
        String id = UUIDUtil.getUUID();
        remark.setId(id);
        remark.setCreateTime(createTime);
        int result = remarkDao.saveRemark(remark);
        return result;
    }

    @Override
    public PaginationVO getPageList(String activityId, String pageNo, String pageSize) {
        PaginationVO vo = new PaginationVO();
        Page page = PageHelper.startPage(Integer.valueOf(pageNo),Integer.valueOf(pageSize));
        List<ActivityRemark> dataList = remarkDao.getActivityRemarkList(activityId);
        int total = (int) page.getTotal();
        vo.setDataList(dataList);
        vo.setTotal(total);
        return vo;
    }

    @Override
    public int delRemark(String id) {
        int result = remarkDao.delRemark(id);
        return result;
    }

    @Override
    public int editRemark(ActivityRemark remark) {
        remark.setEditTime(DateUtil.getSystemTime());
        int result = remarkDao.editRemark(remark);
        return result;
    }

    @Override
    public ActivityRemark getRemark(String id) {
        ActivityRemark remark =  remarkDao.getRemark(id);
        return remark;
    }

}
