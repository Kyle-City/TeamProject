package com.example.team.pojo.DTO;

import lombok.Data;

@Data
public class IngredientDTO {
    // 食材名称
    private String ingredientName;
    // 过期时间段（前端传 expiration_period）
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
