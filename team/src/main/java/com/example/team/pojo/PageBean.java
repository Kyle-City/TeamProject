package com.example.team.pojo;

import lombok.AllArgsConstructor;
import lombok.Data;

import java.util.List;
@AllArgsConstructor
@Data
public class PageBean {
    private Long total;
    private List items;
}
