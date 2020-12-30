package com.quanrong.workbench.service;


public interface ClueActivityRelationService {
    int addRelation(String[] ActivityIds,String clueId);

    int delActivityBund(String id);
}
