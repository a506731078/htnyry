package com.lis.logis.service.impl;

import java.util.List;

import com.lis.common.annotation.DataScope;
import com.lis.common.exception.GlobalException;
import com.lis.common.exception.ServiceException;
import com.lis.common.utils.DateUtils;
import com.lis.common.utils.bean.BeanValidators;
import com.lis.system.service.impl.SysUserServiceImpl;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Map;

import com.lis.common.utils.StringUtils;
import org.springframework.transaction.annotation.Transactional;
import com.lis.logis.domain.LogisticsLocation;
import com.lis.logis.mapper.LogisticsMapper;
import com.lis.logis.domain.Logistics;
import com.lis.logis.service.ILogisticsService;
import com.lis.common.core.text.Convert;

import javax.annotation.Resource;
import javax.validation.ConstraintViolationException;
import javax.validation.Validator;

import static com.lis.common.utils.ShiroUtils.getSysUser;

/**
 * 物流Service业务层处理
 *
 * @author czw
 * @date 2023-04-11
 */
@Service
public class LogisticsServiceImpl implements ILogisticsService {

    private static final Logger log = LoggerFactory.getLogger(LogisticsServiceImpl.class);

    @Resource
    private LogisticsMapper logisticsMapper;
    @Autowired
    protected Validator validator;

    /**
     * 查询物流
     *
     * @param id 物流主键
     * @return 物流
     */
    @Override
    public Logistics selectLogisticsById(Long id) {
        return logisticsMapper.selectLogisticsById(id);
    }

    /**
     * 查询物流列表
     *
     * @param logistics 物流
     * @return 物流
     */
    @Override
    @DataScope(deptAlias = "l", userAlias = "l")
    public List<Logistics> selectLogisticsList(Logistics logistics) {
        return logisticsMapper.selectLogisticsList(logistics);
    }

    /**
     * 新增物流
     *
     * @param logistics 物流
     * @return 结果
     */
    @Transactional
    @Override
    public int insertLogistics(Logistics logistics) {
        //判断系统里是否有订单号
        Logistics logistics1 = logisticsMapper.selectLogisticsNumber(logistics.getOrderNumber());
        if (StringUtils.isNotNull(logistics1)) {
            throw new GlobalException("订单号重复！");
        }
        int rows = logisticsMapper.insertLogistics(logistics);
        insertLogisticsLocation(logistics);
        return rows;
    }

    /**
     * 修改物流
     *
     * @param logistics 物流
     * @return 结果
     */
    @Transactional
    @Override
    public int updateLogistics(Logistics logistics) {
        logisticsMapper.deleteLogisticsLocationByLogisticsId(logistics.getId());
        logistics.setUpdateTime(DateUtils.getNowDate());
        insertLogisticsLocation(logistics);
        return logisticsMapper.updateLogistics(logistics);
    }

    /**
     * 批量删除物流
     *
     * @param ids 需要删除的物流主键
     * @return 结果
     */
    @Transactional
    @Override
    public int deleteLogisticsByIds(String ids) {
        logisticsMapper.deleteLogisticsLocationByLogisticsIds(Convert.toStrArray(ids));
        return logisticsMapper.deleteLogisticsByIds(Convert.toStrArray(ids));
    }

    /**
     * 查询物流列表
     *
     * @param ids 需要查询的数据订单集合
     * @return 物流集合
     */
    @Override
    public List<Logistics> selectOrderNumbers(String ids) {
        return logisticsMapper.selectOrderNumbers(Convert.toStrArray(ids));
    }

    /**
     * 删除物流信息
     *
     * @param id 物流主键
     * @return 结果
     */
    @Transactional
    @Override
    public int deleteLogisticsById(Long id) {
        logisticsMapper.deleteLogisticsLocationByLogisticsId(id);
        return logisticsMapper.deleteLogisticsById(id);
    }

    /**
     * 新增物流位置信息
     *
     * @param logistics 物流对象
     */
    public void insertLogisticsLocation(Logistics logistics) {
        List<LogisticsLocation> logisticsLocationList = logistics.getLogisticsLocationList();
        if (StringUtils.isNotNull(logisticsLocationList)) {
            List<LogisticsLocation> list = new ArrayList<>();
            for (LogisticsLocation logisticsLocation : logisticsLocationList) {
                logisticsLocation.setCreateTime(DateUtils.getNowDate());
                logisticsLocation.setUpdateTime(DateUtils.getNowDate());
                logisticsLocation.setLogisticsId(logistics.getId());
                list.add(logisticsLocation);
            }
            if (list.size() > 0) {
                logisticsMapper.batchLogisticsLocation(list);
            }
        }
    }

    /**
     * 导入用户数据
     *
     * @param logistics       物流数据列表
     * @param isUpdateSupport 是否更新多条，如果已存在，则进行删除更新
     * @return 结果
     */
    @Override
    public String importLogistics(List<Logistics> logistics, Boolean isUpdateSupport) {
        if (StringUtils.isNull(logistics) || logistics.size() == 0 || StringUtils.isNull(logistics.get(0))) {
            throw new ServiceException("导入物流数据不能为空！");
        }
        int successNum = 0;
        int failureNum = 0;
        StringBuilder successMsg = new StringBuilder();
        StringBuilder failureMsg = new StringBuilder();
        for (Logistics l : logistics) {
            try {
                //验证系统是否存在订单号
                Logistics logistics1 = logisticsMapper.selectLogisticsNumber(l.getOrderNumber());
                if (StringUtils.isNull(logistics1)) {

                    if(StringUtils.isEmpty(l.getOrderNumber())){
                        failureNum++;
                        failureMsg.append("<br/>" + failureNum + "、订单 " + l.getOrderNumber() + " 导入失败，订单号为空！");
                        continue;
                    }
                    if(StringUtils.isEmpty(l.getPhoneNumber())){
                        failureNum++;
                        failureMsg.append("<br/>" + failureNum + "、订单 " + l.getOrderNumber() + " 导入失败，收货人电话为空！");
                        continue;
                    }
                    if(StringUtils.isEmpty(l.getOnsignee())){
                        failureNum++;
                        failureMsg.append("<br/>" + failureNum + "、订单 " + l.getOrderNumber() + " 导入失败，收货人姓名为空！");
                        continue;
                    }
                    if(StringUtils.isEmpty(l.getShippingAddress())){
                        failureNum++;
                        failureMsg.append("<br/>" + failureNum + "、订单 " + l.getOrderNumber() + " 导入失败，目的国家：为空！");
                        continue;
                    }

                    BeanValidators.validateWithException(validator, l);
                    l.setUserId(getSysUser().getUserId());
                    l.setDeptId(getSysUser().getDeptId());
                    logisticsMapper.insertLogistics(l);
                    successNum++;
                    successMsg.append("<br/>" + successNum + "、订单 " + l.getOrderNumber() + " 导入成功");
                } else if (isUpdateSupport) {
                    BeanValidators.validateWithException(validator, l);
                    l.setId(logistics1.getId());
                    l.setUserId(getSysUser().getUserId());
                    l.setDeptId(getSysUser().getDeptId());
                    logisticsMapper.updateLogistics(l);
                    successNum++;
                    successMsg.append("<br/>" + successNum + "、订单 " + l.getOrderNumber() + " 更新成功");
                } else {
                    failureNum++;
                    failureMsg.append("<br/>" + failureNum + "、订单 " + l.getOrderNumber() + " 已存在");
                }
            } catch (Exception e) {
                failureNum++;
                String msg = "<br/>" + failureNum + "、订单 " + l.getOrderNumber() + " 导入失败：";
                failureMsg.append(msg + e.getMessage());
                log.error(msg, e);
            }
        }
        if (failureNum > 0) {
            failureMsg.insert(0, "很抱歉，导入失败！共 " + failureNum + " 条数据格式不正确，共 " + successNum + " 条导入成功，错误如下：");
            throw new ServiceException(failureMsg.toString());
        } else {
            successMsg.insert(0, "恭喜您，数据已全部导入成功！共 " + successNum + " 条，数据如下：");
        }
        return successMsg.toString();
    }

}
