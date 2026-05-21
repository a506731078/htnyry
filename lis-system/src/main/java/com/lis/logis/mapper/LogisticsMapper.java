package com.lis.logis.mapper;

import java.util.List;
import com.lis.logis.domain.Logistics;
import com.lis.logis.domain.LogisticsLocation;

/**
 * 物流Mapper接口
 *
 * @author czw
 * @date 2023-04-11
 */
public interface LogisticsMapper
{
    /**
     * 查询物流
     *
     * @param id 物流主键
     * @return 物流
     */
    public Logistics selectLogisticsById(Long id);

    /**
     * 查询物流单号
     *
     * @param number 订单号
     * @return 物流集合
     */
    public Logistics selectLogisticsNumber(String number);

    /**
     * 查询物流列表
     *
     * @param logistics 物流
     * @return 物流集合
     */
    public List<Logistics> selectLogisticsList(Logistics logistics);

    /**
     * 查询物流列表
     *
     * @param ids 需要查询的数据订单集合
     * @return 物流集合
     */
    public List<Logistics> selectOrderNumbers(String[] ids);

    /**
     * 新增物流
     *
     * @param logistics 物流
     * @return 结果
     */
    public int insertLogistics(Logistics logistics);

    /**
     * 修改物流
     *
     * @param logistics 物流
     * @return 结果
     */
    public int updateLogistics(Logistics logistics);

    /**
     * 删除物流
     *
     * @param id 物流主键
     * @return 结果
     */
    public int deleteLogisticsById(Long id);

    /**
     * 批量删除物流
     *
     * @param ids 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteLogisticsByIds(String[] ids);

    /**
     * 批量删除物流位置
     *
     * @param ids 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteLogisticsLocationByLogisticsIds(String[] ids);

    /**
     * 批量新增物流位置
     *
     * @param logisticsLocationList 物流位置列表
     * @return 结果
     */
    public int batchLogisticsLocation(List<LogisticsLocation> logisticsLocationList);


    /**
     * 通过物流主键删除物流位置信息
     *
     * @param id 物流ID
     * @return 结果
     */
    public int deleteLogisticsLocationByLogisticsId(Long id);
}
