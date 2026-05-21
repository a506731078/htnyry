package com.lis.web.controller.logis;

import java.util.List;

import com.lis.logis.domain.LogisticsLocation;
import com.lis.logis.service.ILogisticsLocationService;
import org.apache.shiro.authz.annotation.Logical;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.apache.shiro.authz.annotation.RequiresRoles;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import com.lis.common.annotation.Log;
import com.lis.common.enums.BusinessType;
import com.lis.logis.domain.Logistics;
import com.lis.logis.service.ILogisticsService;
import com.lis.common.core.controller.BaseController;
import com.lis.common.core.domain.AjaxResult;
import com.lis.common.utils.poi.ExcelUtil;
import com.lis.common.core.page.TableDataInfo;
import org.springframework.web.multipart.MultipartFile;

/**
 * 物流Controller
 *
 * @author czw
 * @date 2023-04-11
 */
@Controller
@RequestMapping("/logis/logistics")
public class LogisticsController extends BaseController {
    private String prefix = "logis/logistics";

    @Autowired
    private ILogisticsService logisticsService;
    @Autowired
    private ILogisticsLocationService logisticsLocationService;

    @RequiresPermissions("logis:logistics:view")
    @GetMapping()
    public String logistics() {
        return prefix + "/logistics";
    }


    /**
     * 查询物流列表
     */
    @RequiresPermissions("logis:logistics:list")
    @PostMapping("/list")
    @ResponseBody
    public TableDataInfo list(Logistics logistics) {
        startPage();
        List<Logistics> list = logisticsService.selectLogisticsList(logistics);
        return getDataTable(list);
    }

    /**
     * 导入物流订单
     */
    @RequiresPermissions("logis:logistics:import")
    @Log(title = "导入物流订单", businessType = BusinessType.IMPORT)
    @PostMapping("/importData")
    @ResponseBody
    public AjaxResult importData(MultipartFile file, boolean updateSupport) throws Exception {
        ExcelUtil<Logistics> util = new ExcelUtil<>(Logistics.class);
        List<Logistics> logistics = util.importExcel(file.getInputStream());
        String message = logisticsService.importLogistics(logistics, updateSupport);
        return AjaxResult.success(message);
    }

    /**
     * 下载模板物流数据
     */
    @GetMapping("/importTemplate")
    @ResponseBody
    public AjaxResult importTemplate() {
        ExcelUtil<Logistics> util = new ExcelUtil<>(Logistics.class);
        return util.importTemplateExcel("物流信息");
    }

    /**
     * 导入物流信息
     */
    @RequiresPermissions("logis:logisticsLocation:import")
    @Log(title = "导入物流信息", businessType = BusinessType.IMPORT)
    @PostMapping("/importData2")
    @ResponseBody
    public AjaxResult importData2(MultipartFile file2, boolean updateSupport2) throws Exception {
        ExcelUtil<LogisticsLocation> util = new ExcelUtil<>(LogisticsLocation.class);
        List<LogisticsLocation> logisticsLocation = util.importExcel(file2.getInputStream());
        String message = logisticsLocationService.importLogisticsLocation(logisticsLocation, updateSupport2);
        return AjaxResult.success(message);
    }

    /**
     * 下载模板物流信息
     */
    @GetMapping("/importTemplate2")
    @ResponseBody
    public AjaxResult importTemplate2() {
        ExcelUtil<LogisticsLocation> util = new ExcelUtil<>(LogisticsLocation.class);
        return util.importTemplateExcel("物流详情");
    }

    /**
     * 导出物流列表
     */
    @RequiresPermissions("logis:logistics:export")
    @Log(title = "导出物流", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    @ResponseBody
    public AjaxResult export(Logistics logistics) {
        List<Logistics> list = logisticsService.selectLogisticsList(logistics);
        ExcelUtil<Logistics> util = new ExcelUtil<>(Logistics.class);
        return util.exportExcel(list, "物流数据");
    }

    /**
     * 新增物流
     */
    @GetMapping("/add")
    public String add() {
        return prefix + "/add";
    }

    /**
     * 新增保存物流
     */
    @RequiresPermissions("logis:logistics:add")
    @Log(title = "新增物流", businessType = BusinessType.INSERT)
    @PostMapping("/add")
    @ResponseBody
    public AjaxResult addSave(Logistics logistics) {
        logistics.setUserId(getSysUser().getUserId());
        logistics.setDeptId(getSysUser().getDeptId());
        return toAjax(logisticsService.insertLogistics(logistics));
    }

    /**
     * 修改物流
     */
    @RequiresPermissions("logis:logistics:edit")
    @GetMapping("/edit/{id}")
    public String edit(@PathVariable("id") Long id, ModelMap mmap) {
        Logistics logistics = logisticsService.selectLogisticsById(id);
        mmap.put("logistics", logistics);
        return prefix + "/edit";
    }

    /**
     * 多订单添加物流位置
     */
    @RequiresPermissions("logis:logisticsLocation:multilocate")
    @GetMapping("/locationadds/{id}")
    public String locationadds(@PathVariable("id") String id, ModelMap mmap) {
        mmap.put("id", id);
        return prefix + "/locationadds";
    }

    /**
     * 修改保存物流
     */
    @RequiresPermissions("logis:logistics:edit")
    @Log(title = "修改物流", businessType = BusinessType.UPDATE)
    @PostMapping("/edit")
    @ResponseBody
    public AjaxResult editSave(Logistics logistics) {
        return toAjax(logisticsService.updateLogistics(logistics));
    }

    /**
     * 删除物流
     */
    @RequiresPermissions("logis:logistics:remove")
    @Log(title = "删除物流", businessType = BusinessType.DELETE)
    @PostMapping("/remove")
    @ResponseBody
    public AjaxResult remove(String ids) {
        return toAjax(logisticsService.deleteLogisticsByIds(ids));
    }

}
