package com.quanrong.web.Filter;

import com.quanrong.settings.domain.User;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class CheckFilter implements Filter {
    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest) servletRequest;
        HttpServletResponse response = (HttpServletResponse) servletResponse;
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        String uri = request.getRequestURI();
        if (uri.contains("login") || (request.getContextPath()+"/").equals(uri)){
            filterChain.doFilter(servletRequest,servletResponse);
        }else{
            if (user!=null){
                filterChain.doFilter(servletRequest,servletResponse);
            }else{
                /*非法访问，使用重定向转到登陆界面，使用绝对路径！重定向使用的传统路径说明，/项目名/资源
                * 此处不能使用请求转发，转发之后路径会停留在旧路径，我们应该在为用户跳转到登录页时候，应该将
                * 用户的地址栏变为登录页的路径，动态获取项目名request.getContextPath()*/
                response.sendRedirect(request.getContextPath()+"/login.jsp");
            }
        }
    }
}
