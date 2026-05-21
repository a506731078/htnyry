package com.lis.logis.mapper;

import java.util.List;
import com.lis.logis.domain.LogisticsLocation;
import org.apache.ibatis.annotations.Param;

/**
 * 物流位置Mapper接口
 * 
 * @author czw
 * @date 2023-04-11
 */
public interface LogisticsLocationMapper 
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
     * 删除物流位置
     * 
     * @param id 物流位置主键
     * @return 结果
     */
    public int deleteLogisticsLocationById(Long id);

    /**
     * 批量删除物流位置
     *
     * @param ids 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteLogisticsLocationByIds(String[] ids);

    /**
     * 根据物流单号查询物流位置id
     *
     * @param ids 物流单号
     * @return 结果
     */
    List<LogisticsLocation> selectLogisticsLocationListId(String[] ids);
}
