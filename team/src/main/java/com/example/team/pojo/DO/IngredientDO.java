package com.example.team.pojo.DO;

import lombok.Data;

@Data
public class IngredientDO {
    private String ingredientName;

    private String expirationPeriod;
    // 备注
    private String comment;
    // 数量
    private Integer number;
    // 头像
    private String avatar;
    // 分类
    private String category;
}
