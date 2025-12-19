package com.example.team.pojo.DTO;

import lombok.Data;

import java.util.List;

@Data
public class MenuAddDTO {
    // 用户ID（对应前端user_id）
    private Integer userId;
    // 菜谱标题（对应前端title）
    private String title;
    // 菜谱头像（对应前端avatar）
    private String avatar;
    // 关联的食材ID列表（对应前端food数组）
    private List<Integer> food;
    // 菜谱描述（对应前端description）
    private String description;
    private String comment;
}
