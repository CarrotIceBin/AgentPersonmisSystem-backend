package com.ch.personmis;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;
import org.springframework.web.filter.CorsFilter;

@SpringBootApplication
@MapperScan(basePackages={"com.ch.personmis.repository"})
public class PersonmisApplication {

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
}
