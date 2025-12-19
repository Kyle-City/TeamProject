package com.example.team.pojo.VO;

import com.alibaba.fastjson.annotation.JSONField;
import lombok.Data;

import java.util.List;

@Data
public class Recipe {
    @JSONField(name = "recipe name")
    private String recipeName;

    // 映射"required ingredients"
    @JSONField(name = "required ingredients")
    private List<String> requiredIngredients;

    // 制作步骤
    private List<String> steps;

    // 第三方返回的成功状态（内部校验用，无需返回给前端）
    @JSONField(name = "success")
    private Boolean thirdPartySuccess;
}
