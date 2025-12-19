package com.example.team.pojo;

import lombok.Data;

/**
 * Coze API 响应结果
 */
@Data
public class CozeWorkflowResponse {
    private Integer code;          // 响应码
    private String message;        // 响应信息
    private Object data;           // 核心数据（可能是字符串/对象）
    private String output;         // 菜谱结果（按需扩展）
    private String result;         // 备选结果字段
    // 其他字段可根据 Coze 实际响应补充
}