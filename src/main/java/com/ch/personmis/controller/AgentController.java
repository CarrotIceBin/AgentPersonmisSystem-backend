package com.ch.personmis.controller;

import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.RestTemplate;
import java.util.HashMap;
import java.util.Map;

/**
 * AI Agent 接口转发控制器
 * 核心：将前端请求转发到 Python Agent 服务（8000端口）
 */
@RestController
@RequestMapping("/api/hr/agent")  // 与前端请求路径一致
@CrossOrigin(origins = "*")       // 解决跨域（开发环境临时配置）
public class AgentController {

    // Python Agent 服务地址
    private static final String PYTHON_AGENT_URL = "http://localhost:8000/api/hr/agent/query";

    /**
     * 转发前端的聊天请求到 Python Agent 服务
     * @param requestBody 前端传递的参数（user_query + employee_id）
     * @return 封装后的回答结果
     */
    @PostMapping("/query")  // 接口路径：/api/hr/agent/query
    public Map<String, Object> chat(@RequestBody Map<String, String> requestBody) {
        // 1. 校验参数
        String userQuery = requestBody.get("user_query");
        String employeeId = requestBody.get("employee_id");
        if (userQuery == null || userQuery.trim().isEmpty()) {
            Map<String, Object> error = new HashMap<>();
            error.put("success", false);
            error.put("answer", "请输入有效的查询问题");
            return error;
        }

        // 2. 构建转发参数（与 Python 服务要求一致）
        Map<String, String> params = new HashMap<>();
        params.put("user_query", userQuery);
        params.put("employee_id", employeeId == null ? "" : employeeId);

        // 3. 调用 Python Agent 服务
        RestTemplate restTemplate = new RestTemplate();
        try {
            // 关键：使用 POST 方法转发，与 Python 服务接口一致
            Map<String, Object> pythonResponse = restTemplate.postForObject(
                    PYTHON_AGENT_URL,
                    params,
                    Map.class
            );
            // 直接返回 Python 服务的结果（前端已适配该格式）
            return pythonResponse;
        } catch (Exception e) {
            // 异常处理：返回友好提示 + 打印错误日志
            e.printStackTrace();  // 控制台打印错误，方便排查
            Map<String, Object> error = new HashMap<>();
            error.put("success", false);
            error.put("answer", "Agent 服务调用失败：" + e.getMessage());
            return error;
        }
    }
}