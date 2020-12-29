package com.quanrong.workbench.dao;

import com.quanrong.workbench.domian.ClueRemark;

import java.util.List;

public interface ClueRemarkDao {

    List<ClueRemark> getRemarks(String clueId);

    int addRemark(ClueRemark remark);
}
