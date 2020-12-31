package com.quanrong.workbench.dao;

import com.quanrong.workbench.domian.ClueRemark;

import java.util.List;

public interface ClueRemarkDao {

    List<ClueRemark> getRemarks(String clueId);

    int addRemark(ClueRemark remark);

    int delRemark(String id);

    ClueRemark getRemark(String id);

    int updateRemark(ClueRemark remark);

    void delRemarks(String[] ids);
}
