package com.lis;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.jdbc.DataSourceAutoConfiguration;

import javax.annotation.PostConstruct;
import java.io.File;
import java.io.IOException;
import java.util.TimeZone;

@SpringBootApplication(exclude = { DataSourceAutoConfiguration.class })
public class RuoYiApplication
{
    public static void main(String[] args)
    {
        loadExternalConfig();
        
        SpringApplication.run(RuoYiApplication.class, args);
        System.out.println("(♥◠‿◠)ﾉﾞ  系统启动成功   ლ(´ڡ`ლ)价  \n" +
                " .-------.       ____     __        \n" +
                " |  _ _   \\      \\   \\   /  /    \n" +
                " | ( ' )  |       \\  _. /  '       \n" +
                " |(_ o _) /        _( )_ .'         \n" +
                " | (_,_).' __  ___(_ o _)'          \n" +
                " |  |\\ \\  |  ||   |(_,_)'         \n" +
                " |  | \\ `'   /|   `-'  /           \n" +
                " |  |  \\    /  \\      /           \n" +
                " ''-'   `'-'    `-..-'              ");
    }

    private static void loadExternalConfig() {
        System.out.println("========== 开始查找外部配置文件 ==========");
        
        File configFile = findConfigFile();
        if (configFile == null || !configFile.exists()) {
            System.out.println("外部配置文件 config.json 未找到，使用环境变量或默认配置");
            System.out.println("==========================================");
            return;
        }

        try {
            ObjectMapper mapper = new ObjectMapper();
            JsonNode root = mapper.readTree(configFile);

            JsonNode dbName = root.get("数据库名");
            if (dbName != null && !dbName.asText().isEmpty() && System.getenv("CONFIG_DB_NAME") == null) {
                System.setProperty("CONFIG_DB_NAME", dbName.asText());
                System.out.println("  数据库名: " + dbName.asText());
            } else if (System.getenv("CONFIG_DB_NAME") != null) {
                System.out.println("  数据库名: " + System.getenv("CONFIG_DB_NAME") + " (环境变量)");
            }

            JsonNode dbUser = root.get("数据库账号");
            if (dbUser != null && !dbUser.asText().isEmpty() && System.getenv("CONFIG_DB_USER") == null) {
                System.setProperty("CONFIG_DB_USER", dbUser.asText());
                System.out.println("  数据库账号: " + dbUser.asText());
            } else if (System.getenv("CONFIG_DB_USER") != null) {
                System.out.println("  数据库账号: " + System.getenv("CONFIG_DB_USER") + " (环境变量)");
            }

            JsonNode dbPwd = root.get("数据库密码");
            if (dbPwd != null && !dbPwd.asText().isEmpty() && System.getenv("CONFIG_DB_PASSWORD") == null) {
                System.setProperty("CONFIG_DB_PASSWORD", dbPwd.asText());
                System.out.println("  数据库密码: ******");
            } else if (System.getenv("CONFIG_DB_PASSWORD") != null) {
                System.out.println("  数据库密码: ****** (环境变量)");
            }

            JsonNode port = root.get("主页端口");
            if (port != null && !port.asText().isEmpty() && System.getenv("CONFIG_PORT") == null) {
                System.setProperty("CONFIG_PORT", port.asText());
                System.out.println("  主页端口: " + port.asText());
            } else if (System.getenv("CONFIG_PORT") != null) {
                System.out.println("  主页端口: " + System.getenv("CONFIG_PORT") + " (环境变量)");
            }

            JsonNode address = root.get("主页地址");
            if (address != null && !address.asText().isEmpty() && System.getenv("CONFIG_ADDRESS") == null) {
                System.setProperty("CONFIG_ADDRESS", address.asText());
                System.out.println("  主页地址: " + address.asText());
            } else if (System.getenv("CONFIG_ADDRESS") != null) {
                System.out.println("  主页地址: " + System.getenv("CONFIG_ADDRESS") + " (环境变量)");
            }

            System.out.println("成功加载外部配置文件: " + configFile.getAbsolutePath());
            System.out.println("==========================================");
        } catch (IOException e) {
            System.err.println("加载外部配置文件失败: " + e.getMessage());
            System.out.println("==========================================");
        }
    }

    private static File findConfigFile() {
        System.out.println("1. 尝试从 jar 包位置查找...");
        try {
            java.net.URL jarUrl = RuoYiApplication.class.getProtectionDomain().getCodeSource().getLocation();
            String jarPath = jarUrl.getPath();
            System.out.println("   jar URL: " + jarUrl);
            System.out.println("   jar Path (原始): " + jarPath);
            
            jarPath = java.net.URLDecoder.decode(jarPath, "UTF-8");
            System.out.println("   jar Path (解码后): " + jarPath);
            
            if (jarPath.startsWith("/") && jarPath.length() > 2 && jarPath.charAt(2) == ':') {
                jarPath = jarPath.substring(1);
                System.out.println("   jar Path (修正后): " + jarPath);
            }
            
            File jarFile = new File(jarPath);
            System.out.println("   jar文件存在: " + jarFile.exists());
            File jarDir = jarFile.getParentFile();
            
            if (jarDir != null) {
                System.out.println("   jar目录: " + jarDir.getAbsolutePath());
                File configFile = new File(jarDir, "config.json");
                System.out.println("   检查配置文件: " + configFile.getAbsolutePath());
                System.out.println("   配置文件存在: " + configFile.exists());
                if (configFile.exists()) {
                    System.out.println("   ✓ 找到配置文件（jar目录）");
                    return configFile;
                }
            }
        } catch (Exception e) {
            System.err.println("   ✗ 从jar路径查找失败: " + e.getMessage());
        }

        System.out.println("2. 尝试从工作目录查找...");
        String userDir = System.getProperty("user.dir");
        System.out.println("   工作目录: " + userDir);
        File configInUserDir = new File(userDir, "config.json");
        System.out.println("   检查配置文件: " + configInUserDir.getAbsolutePath());
        System.out.println("   配置文件存在: " + configInUserDir.exists());
        if (configInUserDir.exists()) {
            System.out.println("   ✓ 找到配置文件（工作目录）");
            return configInUserDir;
        }

        System.out.println("3. 尝试从相对路径查找...");
        String[] possiblePaths = {
            "config.json",
            "./config.json",
            "../config.json",
            "./config/config.json"
        };

        for (String path : possiblePaths) {
            File file = new File(path);
            System.out.println("   检查: " + file.getAbsolutePath() + " -> 存在: " + file.exists());
            if (file.exists()) {
                System.out.println("   ✓ 找到配置文件（相对路径）");
                return file;
            }
        }

        System.out.println("4. 所有路径均未找到配置文件");
        return null;
    }

    @PostConstruct
    public void init() {
        TimeZone.setDefault(TimeZone.getTimeZone("Asia/Shanghai"));
    }
}
