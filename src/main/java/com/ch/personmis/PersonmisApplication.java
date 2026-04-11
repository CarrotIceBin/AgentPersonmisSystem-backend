package com.ch.personmis;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;
import org.springframework.web.filter.CorsFilter;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.ViewControllerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@SpringBootApplication
@MapperScan(basePackages={"com.ch.personmis.repository"})
public class PersonmisApplication implements WebMvcConfigurer {

    public static void main(String[] args) {
        SpringApplication.run(PersonmisApplication.class, args);
    }
    //跨域设置
    private CorsConfiguration corsConfig() {
        CorsConfiguration corsConfiguration = new CorsConfiguration();
        //允许跨域请求的域名
        corsConfiguration.addAllowedOriginPattern("*");
        //允许发送的内容类型
        corsConfiguration.addAllowedHeader("*");
        //跨域请求允许的请求方式
        corsConfiguration.addAllowedMethod("*");
        //允许携带凭证
        corsConfiguration.setAllowCredentials(true);
        corsConfiguration.setMaxAge(3600L);
        return corsConfiguration;
    }
    @Bean
    public CorsFilter corsFilter() {
        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/**", corsConfig());
       return new CorsFilter(source);
    }
    
    @Override
    public void addViewControllers(ViewControllerRegistry registry) {
        // 重定向所有非API路径到index.html，让前端路由处理
        registry.addViewController("/department").setViewName("forward:/index.html");
        registry.addViewController("/adddepartment").setViewName("forward:/index.html");
        registry.addViewController("/post").setViewName("forward:/index.html");
        registry.addViewController("/addpost").setViewName("forward:/index.html");
        registry.addViewController("/addStaff").setViewName("forward:/index.html");
        registry.addViewController("/staff").setViewName("forward:/index.html");
        registry.addViewController("/peroidOp").setViewName("forward:/index.html");
        registry.addViewController("/addTransferStaff").setViewName("forward:/index.html");
        registry.addViewController("/transferStaff").setViewName("forward:/index.html");
        registry.addViewController("/addQuit").setViewName("forward:/index.html");
        registry.addViewController("/quit").setViewName("forward:/index.html");
        registry.addViewController("/newStaffReport").setViewName("forward:/index.html");
        registry.addViewController("/quitStaffReport").setViewName("forward:/index.html");
        registry.addViewController("/transferStaffReport").setViewName("forward:/index.html");
    }
    
    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        // 配置静态资源访问
        registry.addResourceHandler("/**")
                .addResourceLocations("classpath:/static/")
                .resourceChain(false)
                .addResolver(new org.springframework.web.servlet.resource.PathResourceResolver() {
                    @Override
                    protected org.springframework.core.io.Resource getResource(String resourcePath, org.springframework.core.io.Resource location) throws java.io.IOException {
                        org.springframework.core.io.Resource resource = super.getResource(resourcePath, location);
                        // 如果资源不存在，返回index.html，让前端路由处理
                        if (resource == null) {
                            return super.getResource("index.html", location);
                        }
                        return resource;
                    }
                });
    }
}
