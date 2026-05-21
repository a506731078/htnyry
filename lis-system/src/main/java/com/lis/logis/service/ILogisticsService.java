package com.lis.logis.service;

import java.util.List;

import com.lis.common.core.domain.entity.SysUser;
import com.lis.common.core.text.Convert;
import com.lis.logis.domain.Logistics;

/**
 * 物流Service接口
 *
 * @author czw
 * @date 2023-04-11
 */
public interface ILogisticsService
{
    /**
     * 查询物流
     *
     * @param id 物流主键
     * @return 物流
     */
    public Logistics selectLogisticsById(Long id);

    /**
     * 查询物流列表
     *
     * @param logistics 物流
     * @return 物流集合
     */
    public List<Logistics> selectLogisticsList(Logistics logistics);

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
     * 批量删除物流
     *
     * @param ids 需要删除的物流主键集合
     * @return 结果
     */
    public int deleteLogisticsByIds(String ids);

    /**
     * 查询物流列表
     *
     * @param ids 需要查询的数据订单集合
     * @return 物流集合
     */
    public List<Logistics> selectOrderNumbers(String ids);

    /**
     * 删除物流信息
     *
     * @param id 物流主键
     * @return 结果
     */
    public int deleteLogisticsById(Long id);

    /**
     * 导入用户数据
     *
     * @param logistics 物流数据列表
     * @param isUpdateSupport 是否更新多条，如果已存在，则进行删除更新
     * @return 结果
     */
    public String importLogistics(List<Logistics> logistics, Boolean isUpdateSupport);

}
