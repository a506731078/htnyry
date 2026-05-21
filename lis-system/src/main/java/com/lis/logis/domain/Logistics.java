package com.lis.logis.domain;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.lis.common.annotation.Excel;
import com.lis.common.core.domain.BaseEntity;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import java.util.Date;
import java.util.List;

/**
 * 物流对象 logistics
 *
 * @author czw
 * @date 2023-04-12
 */
public class Logistics extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 物流ID */
    private Long id;

    /** 订单编号 */
    @Excel(name = "订单编号")
    private String orderNumber;

    /** 收货人手机号码 */
    @Excel(name = "收货人手机号码")
    private String phoneNumber;

    /** 收货人姓名 */
    @Excel(name = "收货人姓名")
    private String onsignee;

    /** 目的地 */
    @Excel(name = "目的地")
    private String shippingAddress;

    /** 订单发货时间 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @Excel(name = "订单发货时间", width = 30, dateFormat = "yyyy-MM-dd HH:mm:ss")
    private Date shippingTime;

    /** 订单收货时间 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @Excel(name = "订单收货时间", width = 30, dateFormat = "yyyy-MM-dd HH:mm:ss")
    private Date receiveTime;

    /** 订单商品 */
    @Excel(name = "订单商品", width = 30)
    private String orderGoods;

    /** 订单金额 */
    @Excel(name = "订单金额")
    private String orderAmount;

    /** 备注 */
    @Excel(name = "备注", width = 30)
    private String remark;

    private Long deptId;
    private Long userId;

    /** 用于接收其他参数使用 */
    private String other;
    /** 用于接收其他参数使用 */
    private String other2;
    /** 用于接收其他参数使用 */
    private String other3;

    /** 物流位置信息 */
    private List<LogisticsLocation> logisticsLocationList;

    public void setId(Long id)
    {
        this.id = id;
    }

    public Long getId()
    {
        return id;
    }
    public void setOrderNumber(String orderNumber)
    {
        this.orderNumber = orderNumber;
    }

    public String getOrderNumber()
    {
        return orderNumber;
    }
    public void setPhoneNumber(String phoneNumber)
    {
        this.phoneNumber = phoneNumber;
    }

    public String getPhoneNumber()
    {
        return phoneNumber;
    }
    public void setOnsignee(String onsignee)
    {
        this.onsignee = onsignee;
    }

    public String getOnsignee()
    {
        return onsignee;
    }
    public void setShippingAddress(String shippingAddress)
    {
        this.shippingAddress = shippingAddress;
    }

    public String getShippingAddress()
    {
        return shippingAddress;
    }
    public void setShippingTime(Date shippingTime)
    {
        this.shippingTime = shippingTime;
    }

    public Date getShippingTime()
    {
        return shippingTime;
    }
    public void setReceiveTime(Date receiveTime)
    {
        this.receiveTime = receiveTime;
    }

    public Date getReceiveTime()
    {
        return receiveTime;
    }
    public void setOrderGoods(String orderGoods)
    {
        this.orderGoods = orderGoods;
    }

    public String getOrderGoods()
    {
        return orderGoods;
    }

    public List<LogisticsLocation> getLogisticsLocationList()
    {
        return logisticsLocationList;
    }

    public void setLogisticsLocationList(List<LogisticsLocation> logisticsLocationList)
    {
        this.logisticsLocationList = logisticsLocationList;
    }

    public String getOrderAmount() {
        return orderAmount;
    }

    public void setOrderAmount(String orderAmount) {
        this.orderAmount = orderAmount;
    }

    public String getOther() {
        return other;
    }

    public void setOther(String other) {
        this.other = other;
    }

    public String getOther2() {
        return other2;
    }

    public void setOther2(String other2) {
        this.other2 = other2;
    }
    public String getOther3() {
        return other3;
    }

    public void setOther3(String other3) {
        this.other3 = other3;
    }

    public Long getDeptId() {
        return deptId;
    }

    public void setDeptId(Long deptId) {
        this.deptId = deptId;
    }

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    @Override
    public String getRemark() {
        return remark;
    }

    @Override
    public void setRemark(String remark) {
        this.remark = remark;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this,ToStringStyle.MULTI_LINE_STYLE)
                .append("id", getId())
                .append("orderNumber", getOrderNumber())
                .append("phoneNumber", getPhoneNumber())
                .append("onsignee", getOnsignee())
                .append("shippingAddress", getShippingAddress())
                .append("shippingTime", getShippingTime())
                .append("receiveTime", getReceiveTime())
                .append("orderGoods", getOrderGoods())
                .append("orderAmount", getOrderAmount())
                .append("createTime", getCreateTime())
                .append("updateTime", getUpdateTime())
                .append("remark", getRemark())
                .append("logisticsLocationList", getLogisticsLocationList())
                .append("remark", getRemark())
                .toString();
    }
}
