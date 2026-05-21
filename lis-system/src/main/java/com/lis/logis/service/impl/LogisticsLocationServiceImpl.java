package com.lis.logis.service.impl;

import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

import com.lis.common.exception.ServiceException;
import com.lis.common.utils.DateUtils;
import com.lis.common.utils.StringUtils;
import com.lis.common.utils.bean.BeanValidators;
import com.lis.logis.domain.Logistics;
import com.lis.logis.mapper.LogisticsMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.lis.logis.mapper.LogisticsLocationMapper;
import com.lis.logis.domain.LogisticsLocation;
import com.lis.logis.service.ILogisticsLocationService;
import com.lis.common.core.text.Convert;

import javax.validation.Validator;

/**
 * 物流位置Service业务层处理
 * 
 * @author czw
 * @date 2023-04-11
 */
@Service
public class LogisticsLocationServiceImpl implements ILogisticsLocationService 
{
    private static final Logger log = LoggerFactory.getLogger(LogisticsServiceImpl.class);

    @Autowired
    protected Validator validator;
    @Autowired
    private LogisticsLocationMapper logisticsLocationMapper;
    @Autowired
    private LogisticsMapper logisticsMapper;

    /**
     * 查询物流位置
     * 
     * @param id 物流位置主键
     * @return 物流位置
     */
    @Override
    public LogisticsLocation selectLogisticsLocationById(Long id)
    {
        return logisticsLocationMapper.selectLogisticsLocationById(id);
    }

    /**
     * 查询物流位置列表
     * 
     * @param logisticsLocation 物流位置
     * @return 物流位置
     */
    @Override
    public List<LogisticsLocation> selectLogisticsLocationList(LogisticsLocation logisticsLocation)
    {
        return logisticsLocationMapper.selectLogisticsLocationList(logisticsLocation);
    }

    /**
     * 新增物流位置
     * 
     * @param logisticsLocation 物流位置
     * @return 结果
     */
    @Override
    public int insertLogisticsLocation(LogisticsLocation logisticsLocation)
    {
        logisticsLocation.setCreateTime(DateUtils.getNowDate());
        return logisticsLocationMapper.insertLogisticsLocation(logisticsLocation);
    }

    /**
     * 修改物流位置
     * 
     * @param logisticsLocation 物流位置
     * @return 结果
     */
    @Override
    public int updateLogisticsLocation(LogisticsLocation logisticsLocation)
    {
        logisticsLocation.setUpdateTime(DateUtils.getNowDate());
        return logisticsLocationMapper.updateLogisticsLocation(logisticsLocation);
    }

    /**
     * 批量删除物流位置
     * 
     * @param ids 需要删除的物流位置主键
     * @return 结果
     */
    @Override
    public int deleteLogisticsLocationByIds(String ids)
    {
        return logisticsLocationMapper.deleteLogisticsLocationByIds(Convert.toStrArray(ids));
    }

    /**
     * 删除物流位置信息
     * 
     * @param id 物流位置主键
     * @return 结果
     */
    @Override
    public int deleteLogisticsLocationById(Long id)
    {
        return logisticsLocationMapper.deleteLogisticsLocationById(id);
    }

    /**
     * 根据物流单号查询物流位置id
     *
     * @param ids 物流单号
     * @return 结果
     */
    public List<LogisticsLocation> selectLogisticsLocationListId(String ids)
    {
        return logisticsLocationMapper.selectLogisticsLocationListId(Convert.toStrArray(ids));
    }

    /**
     * 导入用户数据
     *
     * @param list       物流数据列表
     * @param isUpdateSupport 是否更新支持，如果已存在，则进行更新数据
     * @return 结果
     */
    @Override
    public String importLogisticsLocation(List<LogisticsLocation> list, Boolean isUpdateSupport) {
        if (StringUtils.isNull(list) || list.size() == 0 || StringUtils.isNull(list.get(0))) {
            throw new ServiceException("导入物流详情数据不能为空！");
        }
        int successNum = 0;
        int failureNum = 0;
        StringBuilder successMsg = new StringBuilder();
        StringBuilder failureMsg = new StringBuilder();
        List<LogisticsLocation> logisticsLocations = null;
        if(isUpdateSupport){
            //获取list里所有的物流id
            String localIdStrings = list.stream()
                    .map(logisticsLocation -> String.valueOf(logisticsLocation.getOrderNumber()))
                    .distinct()
                    .collect(Collectors.joining(","));


            //根据物流信息的id查询物流位置的id
            logisticsLocations = selectLogisticsLocationListId(localIdStrings);
        }

        for (LogisticsLocation l : list) {
            try {
                //验证订单号是否存在
                Logistics logistics1 = logisticsMapper.selectLogisticsNumber(l.getOrderNumber());
                if (StringUtils.isNotNull(logistics1)) {

                    if (StringUtils.isEmpty(l.getOrderStatus())) {
                        failureNum++;
                        failureMsg.append("<br/>" + failureNum + "、订单 " + l.getOrderNumber() + " 导入失败，物流状态为空！");
                        continue;
                    }
                    if (StringUtils.isEmpty(l.getCurrentLocation())) {
                        failureNum++;
                        failureMsg.append("<br/>" + failureNum + "、订单 " + l.getOrderNumber() + " 导入失败，目的地为空！");
                        continue;
                    }

                    BeanValidators.validateWithException(validator, l);
                    l.setLogisticsId(logistics1.getId());
                    logisticsLocationMapper.insertLogisticsLocation(l);
                    successNum++;
                    successMsg.append("<br/>" + successNum + "、订单编号 " + l.getOrderNumber() + " 导入成功一条物流位置信息！");

                } else {
                    failureNum++;
                    failureMsg.append("<br/>" + failureNum + "、订单信息 " + l.getOrderNumber() + " 不存在");
                }
            } catch (Exception e) {
                failureNum++;
                String msg = "<br/>" + failureNum + "、物流信息 " + l.getOrderNumber() + " 导入失败：";
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

        if(isUpdateSupport){
            //删除
            String ids = logisticsLocations.stream()
                    .map(logisticsLocation -> String.valueOf(logisticsLocation.getId()))
                    .collect(Collectors.joining(","));

            deleteLogisticsLocationByIds(ids);

        }

        return successMsg.toString();
    }
}
