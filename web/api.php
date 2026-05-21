<?php
// 自定义JSON格式化函数（兼容所有PHP版本）
function json_format($data, $indent = 0) {
    $space = str_repeat('    ', $indent);
    $result = '';
    
    if (is_array($data)) {
        $is_list = array_keys($data) === range(0, count($data) - 1);
        
        if ($is_list) {
            $result .= "[\n";
            foreach ($data as $value) {
                $result .= $space . '    ' . json_format($value, $indent + 1) . ",\n";
            }
            $result = rtrim($result, ",\n") . "\n" . $space . "]";
        } else {
            $result .= "{\n";
            foreach ($data as $key => $value) {
                $key_str = is_string($key) ? '"' . addcslashes($key, '"\\') . '"' : $key;
                $result .= $space . '    ' . $key_str . ": " . json_format($value, $indent + 1) . ",\n";
            }
            $result = rtrim($result, ",\n") . "\n" . $space . "}";
        }
    } elseif (is_string($data)) {
        $result = '"' . addcslashes($data, '"\\') . '"';
    } elseif (is_bool($data)) {
        $result = $data ? 'true' : 'false';
    } elseif (is_null($data)) {
        $result = 'null';
    } else {
        $result = (string)$data;
    }
    
    return $result;
}

// 获取查询参数
$tracking_numbers = isset($_GET['dh']) ? $_GET['dh'] : '';

// 如果没有提供单号，返回错误信息
if (empty($tracking_numbers)) {
    header('Content-Type: application/json; charset=utf-8');
    header('Access-Control-Allow-Origin: *');
    echo json_format([
        '状态码' => 1,
        '消息' => '请提供物流单号，格式为: api.php?dh=物流单号',
        '数据' => null
    ]);
    exit;
}

// 将单号字符串分割成数组
$numbers_array = array_filter(explode(',', $tracking_numbers));

// 如果没有有效的单号，返回错误信息
if (empty($numbers_array)) {
    header('Content-Type: application/json; charset=utf-8');
    header('Access-Control-Allow-Origin: *');
    echo json_format([
        '状态码' => 1,
        '消息' => '无效的物流单号格式',
        '数据' => null
    ]);
    exit;
}

$api_url = '192.168.10.203:8808';
$results = [];

// 遍历每个单号进行查询
foreach ($numbers_array as $number) {
    $number = trim($number);
    
    // 调用第一个API获取物流基本信息
    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, "http://{$api_url}/logis/location/list");
    curl_setopt($ch, CURLOPT_POST, 1);
    curl_setopt($ch, CURLOPT_POSTFIELDS, "orderNumber={$number}");
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_TIMEOUT, 10);
    
    $response = curl_exec($ch);
    $basic_info = json_decode($response, true);
    curl_close($ch);
    
    if ($basic_info && isset($basic_info['rows']) && !empty($basic_info['rows'])) {
        $logistics_id = $basic_info['rows'][0]['id'];
        
        // 调用第二个API获取物流位置详情
        $ch = curl_init();
        curl_setopt($ch, CURLOPT_URL, "http://{$api_url}/logis/location/listLocation");
        curl_setopt($ch, CURLOPT_POST, 1);
        curl_setopt($ch, CURLOPT_POSTFIELDS, "logisticsId={$logistics_id}");
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_TIMEOUT, 10);
        
        $location_response = curl_exec($ch);
        $location_info = json_decode($location_response, true);
        curl_close($ch);
        
        // 整理基本信息（只保留有用的字段）
        $basic_data = $basic_info['rows'][0];
        $simplified_basic = [
            '物流ID' => $basic_data['id'],
            '订单编号' => $basic_data['orderNumber'],
            '收货人姓名' => $basic_data['onsignee'] ?: '-',
            '手机号码' => $basic_data['phoneNumber'] ?: '-',
            '目的地' => $basic_data['shippingAddress'] ?: '-',
            '订单商品' => $basic_data['orderGoods'] ?: '-',
            '订单金额' => $basic_data['orderAmount'] ?: '-',
            '发货时间' => $basic_data['shippingTime'] ?: '-',
            '收货时间' => $basic_data['receiveTime'] ?: '-',
            '创建时间' => $basic_data['createTime'] ?: '-',
            '状态' => getStatusText($basic_data['orderStatus'])
        ];
        
        // 整理位置详情
        $locations = [];
        if ($location_info && isset($location_info['rows']) && !empty($location_info['rows'])) {
            foreach ($location_info['rows'] as $loc) {
                $locations[] = [
                    '时间' => $loc['currentsTime'] ?: $loc['createTime'] ?: '-',
                    '状态' => getStatusText($loc['orderStatus']),
                    '当前位置' => $loc['currentLocation'] ?: '-',
                    '备注' => $loc['remark'] ?: '-'
                ];
            }
            // 按时间排序（最新的在前）
            usort($locations, function($a, $b) {
                return strcmp($b['时间'], $a['时间']);
            });
        }
        
        // 合并结果
        $results[] = [
            '订单编号' => $number,
            '基本信息' => $simplified_basic,
            '物流轨迹' => $locations
        ];
    } else {
        $results[] = [
            '订单编号' => $number,
            '基本信息' => null,
            '物流轨迹' => [],
            '错误信息' => '未找到该单号信息'
        ];
    }
}

// 构建最终结果
$final_result = [
    '状态码' => 0,
    '消息' => '查询成功',
    '查询时间' => date('Y-m-d H:i:s'),
    '数据' => $results
];

// 输出格式化的JSON
header('Content-Type: application/json; charset=utf-8');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET');
header('X-Content-Type-Options: nosniff');
header('Content-Length: ' . mb_strlen(json_format($final_result), 'UTF-8'));
echo json_format($final_result);

/**
 * 获取状态文本描述
 */
function getStatusText($status) {
    $status_map = [
        '0' => '待发货',
        '1' => '已发货',
        '2' => '运输中',
        '3' => '派送中',
        '4' => '已签收',
        '5' => '拒收',
        'shipped' => '已发货',
        'in_transit' => '运输中',
        'delivering' => '派送中',
        'signed' => '已签收',
        'rejected' => '拒收'
    ];
    return isset($status_map[$status]) ? $status_map[$status] : $status;
}
