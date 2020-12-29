package com.quanrong.workbench.service.Impl;

import com.github.pagehelper.Page;
import com.github.pagehelper.PageHelper;
import com.quanrong.VO.PaginationVO;
import com.quanrong.utils.DateUtil;
import com.quanrong.utils.UUIDUtil;
import com.quanrong.workbench.dao.ClueRemarkDao;
import com.quanrong.workbench.domian.ClueRemark;
import com.quanrong.workbench.service.ClueRemarkService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;

@Service
public class ClueRemarkServiceImpl implements ClueRemarkService {
    @Resource
    ClueRemarkDao remarkDao;

    @Override
    public int addRemark(ClueRemark remark) {
        remark.setId(UUIDUtil.getUUID());
        remark.setCreateTime(DateUtil.getSystemTime());
        int result = remarkDao.addRemark(remark);
        return result;
    }

    @Override
    public int delRemark(String id) {
        int result = remarkDao.delRemark(id);
        return result;
    }

    @Override
    public ClueRemark getRemark(String id) {
        ClueRemark remark = remarkDao.getRemark(id);
        return remark;
    }

    @Override
    public int editRemark(ClueRemark remark) {
        remark.setEditTime(DateUtil.getSystemTime());
        int result = remarkDao.updateRemark(remark);
        return result;
    }

    @Override
    public PaginationVO<ClueRemark> getPageList(Map<String,String> map) {
        PaginationVO<ClueRemark> vo = new PaginationVO<>();
        Page page = PageHelper.startPage(Integer.valueOf(map.get("pageNo")),Integer.valueOf(map.get("pageSize")));
        List<ClueRemark> clueRemarkList = remarkDao.getRemarks(map.get("clueId"));
        vo.setTotal((int) page.getTotal());
        vo.setDataList(clueRemarkList);
        return vo;
    }
}
