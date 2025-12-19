package com.example.team.pojo.VO;

import lombok.Data;

@Data
public class IngredientVO {
    private Integer id;

    private String ingredient_name;

    private String expiration_period;
    // 备注
    private String comment;
    // 数量
    private Integer number;
    // 头像
    private String avatar;
    // 分类
    private String category;

    private String addTime;

    public String getName(){
        return this.ingredient_name;
    }

}
