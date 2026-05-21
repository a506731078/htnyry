package com.lis.common.config;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

import java.io.File;
import java.io.IOException;

public class ExternalConfigLoader {

    private static final String CONFIG_FILE_NAME = "config.json";

    static {
        loadExternalConfig();
    }

    private static void loadExternalConfig() {
        File configFile = findConfigFile();
        if (configFile == null || !configFile.exists()) {
            System.out.println("外部配置文件 config.json 未找到，使用默认配置");
            return;
        }

        try {
            ObjectMapper mapper = new ObjectMapper();
            JsonNode root = mapper.readTree(configFile);

            JsonNode dbName = root.get("数据库名");
            if (dbName != null && !dbName.asText().isEmpty()) {
                System.setProperty("CONFIG_DB_NAME", dbName.asText());
            }

            JsonNode dbUser = root.get("数据库账号");
            if (dbUser != null && !dbUser.asText().isEmpty()) {
                System.setProperty("CONFIG_DB_USER", dbUser.asText());
            }

            JsonNode dbPwd = root.get("数据库密码");
            if (dbPwd != null && !dbPwd.asText().isEmpty()) {
                System.setProperty("CONFIG_DB_PASSWORD", dbPwd.asText());
            }

            JsonNode port = root.get("主页端口");
            if (port != null && !port.asText().isEmpty()) {
                System.setProperty("CONFIG_PORT", port.asText());
            }

            System.out.println("成功加载外部配置文件: " + configFile.getAbsolutePath());
        } catch (IOException e) {
            System.err.println("加载外部配置文件失败: " + e.getMessage());
        }
    }

    private static File findConfigFile() {
        String[] possiblePaths = {
            CONFIG_FILE_NAME,
            "./" + CONFIG_FILE_NAME,
            "../" + CONFIG_FILE_NAME,
            "lis-admin/" + CONFIG_FILE_NAME,
            "../lis-admin/" + CONFIG_FILE_NAME
        };

        for (String path : possiblePaths) {
            File file = new File(path);
            if (file.exists()) {
                return file;
            }
        }

        String jarPath = System.getProperty("user.dir");
        File configInJarDir = new File(jarPath, CONFIG_FILE_NAME);
        if (configInJarDir.exists()) {
            return configInJarDir;
        }

        return null;
    }
}
