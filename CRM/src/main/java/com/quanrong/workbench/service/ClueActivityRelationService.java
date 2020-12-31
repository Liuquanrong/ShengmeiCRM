package com.quanrong.workbench.service;


import com.quanrong.VO.PaginationVO;
import com.quanrong.workbench.domian.Activity;

import java.util.List;
import java.util.Map;

public interface ClueActivityRelationService {
    int addRelation(String[] ActivityIds,String clueId);

    int delActivityBund(String id);

    List<Activity> getBundActivity(String clueId);

    PaginationVO<Activity> getPageList(Map<String, String> map);
}
