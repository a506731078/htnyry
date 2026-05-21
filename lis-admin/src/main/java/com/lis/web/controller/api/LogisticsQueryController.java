package com.lis.web.controller.api;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;

import com.lis.common.core.controller.BaseController;
import com.lis.common.core.domain.AjaxResult;

/**
 * 物流查询API控制器
 * 
 * @author lis
 */
@RestController
@RequestMapping("/api.php")
public class LogisticsQueryController extends BaseController {
    
    @Value("${ruoyi.logistics.api.url}")
    private String apiUrl;
    
    private final RestTemplate restTemplate = new RestTemplate();
    
    /**
     * 查询物流信息
     * 
     * @param dh 物流单号，多个单号用逗号分隔
     * @return 查询结果
     */
    @GetMapping
    public AjaxResult query(@RequestParam(value = "dh", required = false) String dh) {
        if (dh == null || dh.isEmpty()) {
            return AjaxResult.error("请提供物流单号");
        }
        
        String[] numbersArray = dh.split(",");
        List<String> validNumbers = new ArrayList<>();
        
        for (String number : numbersArray) {
            String trimmed = number.trim();
            if (!trimmed.isEmpty()) {
                validNumbers.add(trimmed);
            }
        }
        
        if (validNumbers.isEmpty()) {
            return AjaxResult.error("无效的物流单号格式");
        }
        
        List<Map<String, Object>> results = new ArrayList<>();
        
        for (String number : validNumbers) {
            try {
                HttpHeaders headers = new HttpHeaders();
                headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);
                
                MultiValueMap<String, String> basicInfoParams = new LinkedMultiValueMap<>();
                basicInfoParams.add("orderNumber", number);
                
                HttpEntity<MultiValueMap<String, String>> basicInfoRequest = new HttpEntity<>(basicInfoParams, headers);
                ResponseEntity<Map> basicInfoResponse = restTemplate.postForEntity(
                        apiUrl + "/logis/location/list", 
                        basicInfoRequest, 
                        Map.class);
                
                Map<String, Object> basicInfo = basicInfoResponse.getBody();
                
                if (basicInfo != null && basicInfo.containsKey("rows") && ((List<?>) basicInfo.get("rows")).size() > 0) {
                    List<Map<String, Object>> rows = (List<Map<String, Object>>) basicInfo.get("rows");
                    Map<String, Object> firstRow = rows.get(0);
                    Object logisticsId = firstRow.get("id");
                    
                    MultiValueMap<String, String> locationParams = new LinkedMultiValueMap<>();
                    locationParams.add("logisticsId", logisticsId.toString());
                    
                    HttpEntity<MultiValueMap<String, String>> locationRequest = new HttpEntity<>(locationParams, headers);
                    ResponseEntity<Map> locationResponse = restTemplate.postForEntity(
                            apiUrl + "/logis/location/listLocation", 
                            locationRequest, 
                            Map.class);
                    
                    Map<String, Object> locationInfo = locationResponse.getBody();
                    
                    Map<String, Object> result = new HashMap<>();
                    result.put("orderNumber", number);
                    result.put("basic_info", firstRow);
                    result.put("location_details", locationInfo);
                    
                    results.add(result);
                } else {
                    Map<String, Object> result = new HashMap<>();
                    result.put("orderNumber", number);
                    result.put("basic_info", null);
                    result.put("location_details", null);
                    result.put("error", "未找到该单号信息");
                    
                    results.add(result);
                }
            } catch (Exception e) {
                Map<String, Object> result = new HashMap<>();
                result.put("orderNumber", number);
                result.put("basic_info", null);
                result.put("location_details", null);
                result.put("error", "查询异常: " + e.getMessage());
                
                results.add(result);
            }
        }
        
        Map<String, Object> data = new HashMap<>();
        data.put("code", 0);
        data.put("msg", "查询成功");
        data.put("data", results);
        
        return AjaxResult.success(data);
    }
}
