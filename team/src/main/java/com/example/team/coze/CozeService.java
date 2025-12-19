package com.example.team.coze;

import com.example.team.pojo.CozeWorkflowRequest;
import com.example.team.pojo.CozeWorkflowResponse;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.annotation.Resource;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.RestTemplate;



@Slf4j
@Service
public class CozeService {

    // 从配置文件读取参数
    @Value("${coze.base-url}")
    private String cozeBaseUrl;
    @Value("${coze.workflow-id}")
    private String workflowId;
    @Value("${coze.pat}")
    private String cozePat;

    @Resource
    private RestTemplate restTemplate;
    @Resource
    private ObjectMapper objectMapper; // Spring 内置的 JSON 解析器

    /**
     * 调用 Coze 工作流 API
     * @param userneed 用户需求
     * @param existfood 现有食材
     * @param likedrecipes 喜欢的菜谱
     * @return 解析后的菜谱结果
     */
    public String callCozeWorkflow(String userneed, String existfood, String likedrecipes) {
        // 1. 校验配置
        if (cozePat == null || cozePat.isEmpty() || workflowId == null || workflowId.isEmpty()) {
            log.error("Coze 配置缺失：PAT={}, WorkflowId={}", cozePat, workflowId);
            return "服务器未配置 Coze 密钥或工作流ID，无法生成菜谱";
        }

        // 2. 构造请求参数
        CozeWorkflowRequest request = new CozeWorkflowRequest();
        request.setWorkflow_id(workflowId);
        CozeWorkflowRequest.Parameters params = new CozeWorkflowRequest.Parameters();
        params.setUserneed(userneed);
        params.setExistfood(existfood);
        params.setLikedrecipes(likedrecipes);
        request.setParameters(params);

        // 3. 构造请求头（鉴权 + Content-Type）
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        headers.set("Authorization", "Bearer " + cozePat);
        HttpEntity<CozeWorkflowRequest> httpEntity = new HttpEntity<>(request, headers);

        // 4. 调用 Coze API
        String apiUrl = cozeBaseUrl + "/v1/workflow/run";
        try {
            // 发起 POST 请求
            ResponseEntity<CozeWorkflowResponse> response = restTemplate.exchange(
                    apiUrl,
                    HttpMethod.POST,
                    httpEntity,
                    CozeWorkflowResponse.class
            );

            // 5. 解析响应结果
            return parseCozeResponse(response.getBody());

        } catch (HttpClientErrorException e) {
            // 处理 4xx/5xx 错误
            log.error("Coze API 调用失败：状态码={}, 响应体={}", e.getStatusCode(), e.getResponseBodyAsString());
            return "调用 Coze 失败：" + e.getStatusText() + "，详情：" + e.getResponseBodyAsString();
        } catch (Exception e) {
            log.error("Coze API 调用异常", e);
            return "服务器内部错误，无法生成菜谱";
        }
    }

    /**
     * 解析 Coze 响应结果（兼容多格式）
     */
    private String parseCozeResponse(CozeWorkflowResponse response) {
        if (response == null) {
            return "未获取到菜谱建议";
        }

        // 优先级解析：data → output → result → message → 兜底
        Object coreData = response.getData();
        String recipe = null;

        // 处理 data 字段（可能是 JSON 字符串）
        if (coreData != null) {
            if (coreData instanceof String) {
                // 尝试解析字符串为 JSON 对象
                try {
                    Object dataObj = objectMapper.readValue((String) coreData, Object.class);
                    // 若 data 是对象，提取 output 字段
                    if (dataObj instanceof java.util.Map) {
                        recipe = (String) ((java.util.Map<?, ?>) dataObj).get("output");
                    }
                } catch (JsonProcessingException e) {
                    // 解析失败，直接用字符串
                    recipe = (String) coreData;
                }
            } else {
                // data 是对象，直接提取 output
                if (coreData instanceof java.util.Map) {
                    recipe = (String) ((java.util.Map<?, ?>) coreData).get("output");
                }
            }
        }

        // 兜底解析
        if (recipe == null || recipe.isEmpty()) {
            recipe = response.getOutput();
        }
        if (recipe == null || recipe.isEmpty()) {
            recipe = response.getResult();
        }
        if (recipe == null || recipe.isEmpty()) {
            recipe = response.getMessage();
        }
        if (recipe == null || recipe.isEmpty()) {
            recipe = "暂无可用菜谱建议";
        }

        return recipe;
    }
}