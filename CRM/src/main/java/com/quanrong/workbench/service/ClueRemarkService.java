package com.quanrong.workbench.service;

import com.quanrong.VO.PaginationVO;
import com.quanrong.workbench.domian.ClueRemark;

import java.util.Map;

public interface ClueRemarkService {
    PaginationVO<ClueRemark> getPageList(Map<String,String> map);

    int addRemark(ClueRemark remark);
}
