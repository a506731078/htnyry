package com.lis.web.controller.logis;

import com.lis.common.annotation.Log;
import com.lis.common.annotation.RepeatSubmit;
import com.lis.common.core.controller.BaseController;
import com.lis.common.core.domain.AjaxResult;
import com.lis.common.core.page.TableDataInfo;
import com.lis.common.enums.BusinessType;
import com.lis.common.exception.ServiceException;
import com.lis.common.utils.StringUtils;
import com.lis.common.utils.poi.ExcelUtil;
import com.lis.logis.domain.Logistics;
import com.lis.logis.domain.LogisticsLocation;
import com.lis.logis.service.ILogisticsLocationService;
import com.lis.logis.service.ILogisticsService;
import net.bytebuddy.implementation.bytecode.Throw;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.*;

import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

/**
 * 物流Controller
 *
 * @author czw
 * @date 2023-04-11
 */
@Controller
@RequestMapping("/logis/location")
public class LocationController extends BaseController
{
    private String prefix = "logis/logistics";

    @Autowired
    private ILogisticsService logisticsService;
    @Autowired
    private ILogisticsLocationService locationService;

    @GetMapping()
    public String location()
    {
        return prefix + "/location";
    }


    /**
     * 查询物流列表
     */
    @PostMapping("/list")
    @ResponseBody
    public TableDataInfo list(Logistics logistics)
    {
        if(StringUtils.isBlank(logistics.getOrderNumber())){
            throw new ServiceException("请输入订单号！");
        }
        startPage();
        List<Logistics> list = logisticsService.selectOrderNumbers(logistics.getOrderNumber());
        return getDataTable(list);
    }

    /**
     * 查询物流位置列表
     */
    @PostMapping("/listLocation")
    @ResponseBody
    public TableDataInfo listLocation(LogisticsLocation location)
    {
        startPage();
        List<LogisticsLocation> list = locationService.selectLogisticsLocationList(location);
        return getDataTable(list);
    }

    /**
     * 新增保存物流位置
     */
    @RequiresPermissions("logis:logistics:add")
    @Log(title = "新增物流位置", businessType = BusinessType.INSERT)
    @PostMapping("/add")
    @ResponseBody
    public AjaxResult addSave(Logistics logistics) {
        logistics.setUserId(getSysUser().getUserId());
        logistics.setDeptId(getSysUser().getDeptId());
        return toAjax(logisticsService.insertLogistics(logistics));
    }


    @Log(title = "新增物流位置", businessType = BusinessType.INSERT)
    @PostMapping("/locationaddsSave")
    @ResponseBody
    public AjaxResult locationaddsSave(LogisticsLocation logisticsLocation) {
        List<Long> idsList = Arrays.stream(logisticsLocation.getLogisticsIds().split(","))
                .map(Long::parseLong)
                .collect(Collectors.toList());

        for (Long id : idsList) {
            logisticsLocation.setLogisticsId(id);  // 假设 LogisticsLocation 有一个 setId 方法
            int i = locationService.insertLogisticsLocation(logisticsLocation);
        }

        return AjaxResult.success();
    }


}
