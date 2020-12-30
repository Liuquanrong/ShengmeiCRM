package com.quanrong.workbench.dao;


import java.util.Map;

public interface ClueActivityRelationDao {


    void addRelation(Map<String,String> map);

    int delRelation(String id);
}
