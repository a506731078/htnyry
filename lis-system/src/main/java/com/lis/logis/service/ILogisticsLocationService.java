package com.lis.logis.service;

import java.util.List;

import com.lis.logis.domain.LogisticsLocation;

/**
 * 物流位置Service接口
 * 
 * @author czw
 * @date 2023-04-11
 */
public interface ILogisticsLocationService 
{
    /**
     * 查询物流位置
     * 
     * @param id 物流位置主键
     * @return 物流位置
     */
    public LogisticsLocation selectLogisticsLocationById(Long id);

    /**
     * 查询物流位置列表
     * 
     * @param logisticsLocation 物流位置
     * @return 物流位置集合
     */
    public List<LogisticsLocation> selectLogisticsLocationList(LogisticsLocation logisticsLocation);

    /**
     * 新增物流位置
     * 
     * @param logisticsLocation 物流位置
     * @return 结果
     */
    public int insertLogisticsLocation(LogisticsLocation logisticsLocation);

    /**
     * 修改物流位置
     * 
     * @param logisticsLocation 物流位置
     * @return 结果
     */
    public int updateLogisticsLocation(LogisticsLocation logisticsLocation);

    /**
     * 批量删除物流位置
     * 
     * @param ids 需要删除的物流位置主键集合
     * @return 结果
     */
    public int deleteLogisticsLocationByIds(String ids);

    /**
     * 删除物流位置信息
     * 
     * @param id 物流位置主键
     * @return 结果
     */
    public int deleteLogisticsLocationById(Long id);


    /**
     * 导入用户数据
     *
     * @param logisticsLocationList 物流数据列表
     * @param isUpdateSupport 是否更新支持，如果已存在，则进行更新数据
     * @return 结果
     */
    public String importLogisticsLocation(List<LogisticsLocation> logisticsLocationList, Boolean isUpdateSupport);
}
