package com.quanrong.workbench.dao;


import com.quanrong.workbench.domian.Activity;
import com.quanrong.workbench.domian.Clue;

import java.util.List;
import java.util.Map;

public interface ClueDao {

    int addClue(Clue clue);

    List<Clue> getClueList(Map<String, String> map);

    int delClues(String[] ids);

    Clue getClue(String id);

    int updateClue(Clue clue);
}
