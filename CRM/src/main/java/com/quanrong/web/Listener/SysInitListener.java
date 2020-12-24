package com.quanrong.web.Listener;

import com.quanrong.workbench.domian.DicValue;
import com.quanrong.workbench.service.DicService;
import org.springframework.context.ApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import java.util.List;
import java.util.Map;
import java.util.Set;

public class SysInitListener implements ServletContextListener{

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        //获取全局作用域
        ServletContext application = sce.getServletContext();
        ApplicationContext context = WebApplicationContextUtils.getRequiredWebApplicationContext(application);
        //此处传入的bean对象需要是实现类对象，并且首字母小写，因为我们使用@Service注解创建的对象是首字母小写的类名全称
        DicService dicService = (DicService) context.getBean("dicServiceImpl");
        System.out.println("全局作用域对象创建！");
        //从数据库中获取数据字典的数据
        Map<String, List<DicValue>> map = dicService.getAll();
        //将map对象解析为放入全局作用域对象中的键值对
        Set<String> set = map.keySet();
        for (String typeCode:set){
            List<DicValue> dicValues = map.get(typeCode);
            application.setAttribute(typeCode,dicValues);
        }
    }
}
