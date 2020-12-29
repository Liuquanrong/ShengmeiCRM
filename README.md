# ShengmeiCRM
ShengmeiCRM Project
主要负责开发登陆验证模块和activity模块
  ·登陆验证模块中要求验证用户名和密码、账户是否过期、账户的锁定状态、登陆的IP地址是否合法
  ·activity模块主要开发活动的添加、修改、删除、活动详细信息、活动信息的备注、备注信息的删除、修改、发表
    ·修改的时候要求再修改界面放入原有的信息内容，修改所有者使用下拉菜单，菜单中的名称来源数据库的tbl_user表
    ·同时活动界面支持信息查询功能，支持模糊查询
    ·如果活动被修改，记录下修改人员的信息，以及修改的时间yyyy-MM-dd HH-mm-ss
    ·再界面中加入分页组件、后端使用PageHelper进行分页和总数统计、前端使用BootStrap的Pagnition分页组件
    ·显示的活动信息列表根据活动的创建时间进行desc降序排列
    ·删除的时候需要把和该活动相关联的活动备注信息一同清楚
    ·活动详细界面中的备注栏中要求显示备注人的名称、头像、备注时间、备注活动的名称
    ·如果备注信息被修改，此条备注信息显示为修改人的名称以及修改时间
    ·备注信息根据时间进行排序，当活动的备注被修改以后，修改时间作为本条备注出现在最新的备注信息中
  ·clue线索模块的开发流程，出去常用的CRUD操作外，增加使用数据字典的方式缓存数据
    ·在服务器启动的时候从数据库中获取一些常用的数据，将他们放入到服务器的缓存当中，方便使用，我们可以将这些数据放入到全局作用域对象当中
      ·需要注意使用SSM框架整合开发的时候，使用监听器对象，监听全局作用域的创建，同时将数据取出放入到全局作用域当中
      ·在监听器开发中不能使用@Resource来创建Service对象，因为这个注解数据Spring而监听器对象属于web创建，需要使用如下方式创建Service对象
        //获取全局作用域
        ServletContext application = sce.getServletContext();
        ApplicationContext context = WebApplicationContextUtils.getRequiredWebApplicationContext(application);
        //此处传入的bean对象需要是实现类对象，并且首字母小写，因为我们使用@Service注解创建的对象是首字母小写的类名全称
        DicService dicService = (DicService) context.getBean("dicServiceImpl");
      ·将线索模块与市场活动模块相关联
