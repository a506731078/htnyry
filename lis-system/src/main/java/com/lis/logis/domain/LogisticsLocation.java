package com.lis.logis.domain;

import com.fasterxml.jackson.annotation.JsonFormat;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.lis.common.annotation.Excel;
import com.lis.common.core.domain.BaseEntity;
import org.springframework.format.annotation.DateTimeFormat;

import java.util.Date;

/**
 * 物流位置对象 logistics_location
 *
 * @author ruoyi
 * @date 2023-04-12
 */
public class LogisticsLocation extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    private String logisticsIds;

    /** 物流位置ID */
    private Long id;

    /** 物流ID */
//    @Excel(name = "物流ID")
    private Long logisticsId;

    /** 物流状态 */
    @Excel(name = "物流状态", dictType = "order_status", readConverterExp = "0=已签入,1=操作中,2=已出库,3=运输中,4=清关中,5=派送中,6=已签收", combo = "已签入,操作中,已出库,运输中,清关中,派送中,已签收")
    private String orderStatus;

    /** 当前位置 */
    @Excel(name = "当前位置")
    private String currentLocation;

    @JsonFormat(pattern="yyyy-MM-dd HH:mm:ss", timezone = "Asia/Shanghai")
    @Excel(name = "当前时间(yyyy-MM-dd HH:mm:ss)", width = 30, dateFormat = "yyyy-MM-dd HH:mm:ss")
    private Date currentsTime;

    @Excel(name = "订单编号(必须跟物流编号一致)", width = 30)
    private String orderNumber;

    /** 备注 */
    @Excel(name = "备注信息", width = 30)
    private String remark;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getLogisticsId() {
        return logisticsId;
    }

    public void setLogisticsId(Long logisticsId) {
        this.logisticsId = logisticsId;
    }

    public String getOrderStatus() {
        return orderStatus;
    }

    public void setOrderStatus(String orderStatus) {
        this.orderStatus = orderStatus;
    }

    public String getCurrentLocation() {
        return currentLocation;
    }

    public void setCurrentLocation(String currentLocation) {
        this.currentLocation = currentLocation;
    }

    public Date getCurrentsTime() {
        return currentsTime;
    }

    public void setCurrentsTime(Date currentsTime) {
        this.currentsTime = currentsTime;
    }

    public String getOrderNumber() {
        return orderNumber;
    }

    public void setOrderNumber(String orderNumber) {
        this.orderNumber = orderNumber;
    }

    @Override
    public String getRemark() {
        return remark;
    }

    @Override
    public void setRemark(String remark) {
        this.remark = remark;
    }

    public String getLogisticsIds() {
        return logisticsIds;
    }

    public void setLogisticsIds(String logisticsIds) {
        this.logisticsIds = logisticsIds;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this,ToStringStyle.MULTI_LINE_STYLE)
                .append("id", getId())
                .append("logisticsId", getLogisticsId())
                .append("orderStatus", getOrderStatus())
                .append("currentLocation", getCurrentLocation())
                .append("currentsTime", getCurrentsTime())
                .append("createTime", getCreateTime())
                .append("updateTime", getUpdateTime())
                .append("remark", getRemark())
                .toString();
    }



}
