package com.quanrong.workbench.dao;


import com.quanrong.workbench.domian.Activity;

import java.util.List;
import java.util.Map;

public interface ClueActivityRelationDao {


    void addRelation(Map<String,String> map);

    int delRelation(String id);

    List<Activity> getBundActivity(String clueId);

    List<Activity> getActivityList(Map<String, String> map);
}
