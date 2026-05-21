package com.lis.web.controller.logis.task;

import com.lis.common.utils.DateUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

/**
 * 定时任务调度测试
 *
 * @author ruoyi
 */
@Component("UserTask")
public class UserTask {

    private static final Logger log = LoggerFactory.getLogger(UserTask.class);

    public void ryNoParams() {
        log.info("--------------------【用户禁用定时任务开始，{}】--------------------", DateUtils.getNowDate());



        log.info("********************【用户禁用定时任务结束，{}】********************", DateUtils.getNowDate());
    }
}
