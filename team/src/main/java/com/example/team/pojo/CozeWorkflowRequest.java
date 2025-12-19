package com.example.team.pojo;

import lombok.Data;

/**
 * Coze 工作流调用请求参数
 */
@Data
public class CozeWorkflowRequest {
    // Coze 工作流ID
    private String workflow_id;
    // 工作流入参（对应前端传的 userneed/existfood/likedrecipes）
    private Parameters parameters;

    /**
     * 嵌套参数类
     */
    @Data
    public static class Parameters {
        private String userneed;    // 用户需求
        private String existfood;   // 现有食材
        private String likedrecipes;// 喜欢的菜谱
    }
}