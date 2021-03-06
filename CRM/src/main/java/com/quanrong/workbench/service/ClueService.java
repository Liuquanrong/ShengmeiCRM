package com.quanrong.workbench.service;

import com.quanrong.VO.PaginationVO;
import com.quanrong.workbench.domian.Activity;
import com.quanrong.workbench.domian.Clue;

import java.util.List;
import java.util.Map;

public interface ClueService {
    int addClue(Clue clue);

    PaginationVO<Clue> getPageList(Map<String, String> map);

    int delClues(String[] ids);

    Clue getClue(String id);

    int updateClue(Clue clue);
}
