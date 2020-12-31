<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
	String basePath = request.getScheme()+"://"+request.getServerName()+":"
			+request.getServerPort()+request.getContextPath()+"/";
%>
<!DOCTYPE html>
<html>
<head>
<base href="<%=basePath%>"/>
<meta charset="UTF-8">

<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />
<link href="jquery/bs_pagination/jquery.bs_pagination.min.css" type="text/css" rel="stylesheet"/>

<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
<script type="text/javascript" src="jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
<script type="text/javascript" src="jquery/bs_pagination/en.js"></script>

<script type="text/javascript">

	//默认情况下取消和保存按钮是隐藏的
	var cancelAndSaveBtnDefault = true;
	
	$(function(){
		//导入时间拾取器
		$(".time").datetimepicker({
			minView:"month",
			language:"zh-CN",
			format:"yyyy-mm-dd",
			autoclose:true,
			todayBtn:true,
			pickerPosition:"top-left"
		});

		$("#remark").focus(function(){
			if(cancelAndSaveBtnDefault){
				//设置remarkDiv的高度为130px
				$("#remarkDiv").css("height","130px");
				//显示
				$("#cancelAndSaveBtn").show("2000");
				cancelAndSaveBtnDefault = false;
			}
		});
		
		$("#cancelBtn").click(function(){
			//显示
			$("#cancelAndSaveBtn").hide();
			//设置remarkDiv的高度为130px
			$("#remarkDiv").css("height","90px");
			cancelAndSaveBtnDefault = true;
		});

		$("#remarkDivs").on("mouseover",".remarkDiv",function (){
			$(this).children("div").children("div").show();
		})


		$("#remarkDivs").on("mouseout",".remarkDiv",function (){
			$(this).children("div").children("div").hide();
		})

		$("#remarkDivs").on("mouseover",".myHref",function (){
			$(this).children("span").css("color","red");
		})

		$("#remarkDivs").on("mouseout",".myHref",function (){
			$(this).children("span").css("color","#E6E6E6");
		})
		//获取当前线索的信息进行页面填充
		getClue();
		//获取当前线索的备注信息
		pageList(1,2);
		//获取绑定的市场活动信息
		getBundActivity();
		//点击修改按钮，将详细数据填入模态窗口中
		$("#editClueBtn").click(function(){
			$.each(userList,function (index,element) {
				if (currentClue.owner == element.name){
					$("#edit-clueOwner").append('<option value='+element.id+' selected>'+element.name+'</option>');
				}else{
					$("#edit-clueOwner").append('<option value='+element.id+'>'+element.name+'</option>');
				}
			})
			$("#edit-company").val(currentClue.company);
			$("#edit-call").val(currentClue.appellation);
			$("#edit-fullname").val(currentClue.fullname);
			$("#edit-job").val(currentClue.job);
			$("#edit-email").val(currentClue.email);
			$("#edit-phone").val(currentClue.phone);
			$("#edit-website").val(currentClue.website);
			$("#edit-mphone").val(currentClue.mphone);
			$("#edit-state").val(currentClue.state);
			$("#edit-source").val(currentClue.source);
			$("#edit-description").val(currentClue.description);
			$("#edit-contactSummary").val(currentClue.contactSummary);
			$("#edit-nextContactTime").val(currentClue.nextContactTime);
			$("#edit-address").val(currentClue.address);
			$("#editClueModal").modal("show");
		})

		//点击修改按钮，保存数据
		$("#editBtn").click(function () {
			var company = $.trim($("#edit-company").val());
			var fullname = $.trim($("#edit-fullname").val());
			if (company == "" || fullname == ""){
				alert("请输入公司名称和姓名！！");
				return false;
			}
			$.ajax({
				url:"clue/editClue.do",
				type:"post",
				data:{
					"id":currentClue.id,
					"owner":$("#edit-clueOwner").val(),
					"company":company,
					"appellation":$.trim($("#edit-call").val()),
					"fullname":fullname,
					"job":$.trim($("#edit-job").val()),
					"email":$.trim($("#edit-email").val()),
					"phone":$.trim($("#edit-phone").val()),
					"website":$.trim($("#edit-website").val()),
					"mphone":$.trim($("#edit-mphone").val()),
					"state":$.trim($("#edit-state").val()),
					"source":$.trim($("#edit-source").val()),
					"editBy":"${user.name}",
					"description":$.trim($("#edit-description").val()),
					"contactSummary":$.trim($("#edit-contactSummary").val()),
					"nextContactTime":$.trim($("#edit-nextContactTime").val()),
					"address":$.trim($("#edit-address").val()),
				},
				success(data) {
					if (data==1){
						alert("修改成功！");
						$("#editClueModal").modal("hide");
						getClue();
					}else{
						alert("保存失败，请稍后重试！");
					}
				}
			})
		})

		//点击删除按钮，本条数据及其关联数据
		$("#delClueBtn").click(function () {
			var a = confirm("确定要删除本条市场活动吗？");
			if (!a){
				return false;
			}
			$.ajax({
				url:"clue/delClues.do",
				type:"post",
				traditional:true,
				data:{"ids":[currentClue.id]},
				success(data){
					if (data==1){
						alert("成功删除!!");
						window.location.href="workbench/clue/index.jsp";
					}else{
						alert("删除失败！！")
					}
				}
			})
		})

		//添加备注信息
		$("#addRemark").click(function(){
			if ($.trim($("#remark").val()).length == 0){
				alert("请输入备注信息！！");
				return false;
			}
            $.ajax({
                url:"clueRemark/saveRemark.do",
                type:"get",
                data:{
                    "noteContent":$.trim($("#remark").val()),
                    "createBy":'${user.name}',
                    "editFlag":'0',
                    "clueId":currentClue.id
                },
                success(data){
                    if (data==1){
                        alert("保存成功！！");
                        $("#remarkForm")[0].reset();
                        pageList(1,2);
                    }else{
                        alert("保存失败！！请稍后重试！！");
                    }
                }
            })
		})

		//点击更新按钮更新备注
		$("#updateRemarkBtn").click(function () {
			var remark = $.trim($("#noteContent").val());
			if (remark.length == 0){
				alert("请输入备注信息！！");
				return false;
			}
			$.ajax({
				url:"clueRemark/editRemark.do",
				type:"get",
				data:{
					"id":$("#remarkId").val(),
					"noteContent":$("#noteContent").val(),
					"editFlag":'1',
					"editBy":'${user.name}'
				},
				success(data){
					if (data==1){
						alert("更新成功！！");
						$("#editRemarkModal").modal("hide");
						pageList(1,2);
					}else{
						alert("更新失败，请稍后重试！！");
					}
				}
			})
		})

        //点击获取市场活动的所有数据
        $("#activityListBtn").click(function () {
           activityPageList(1,2);
           $("#bundModal").modal("show");
        })

        //点击绑定模态窗口中的查询按钮的时候，进行市场活动的查询
        $("#searchActivityBtn").click(function () {
            $("#hidden-name").val($.trim($("#search-name").val()));
            activityPageList(1,2);
        })

		//对关联活动列表的复选框进行处理
		$("#selectAll").click(function () {
			$("input[name=select]").prop("checked",this.checked)
		})
		$("#activityList").on("click","input[name=select]",function () {
			$("#selectAll").prop("checked",$("input[name=select]:checked").length==$("input[name=select]").length)
		})

		//点击绑定模态窗口中的关联按钮，将选中的活动和当前线索关联
		$("#addRelation").click(function () {
			var $select = $("input[name=select]:checked");
			if ($select.length==0){
				alert("请选择要关联的市场活动！！");
				return false;
			}
			var ActivityIds = [];
			for (var i = 0; i < $select.length; i ++){
				ActivityIds[i] = $select[i].value;
			}
			$.ajax({
				url:"ClueActivityRelation/addRelation.do",
				type:"post",
				traditional: true,
				data:{
					"ActivityIds":ActivityIds,
					"clueId":currentClue.id
				},
				success(data){
					if (data == $select.length){
						alert("关联成功！！");
						getBundActivity();
						$("#bundModal").modal("hide");
					}else{
						alert("关联失败！！")
					}
				}
			})
		})

	});
	//点击进入详细界面以后，加载详细的信息列表
	function getClue(){
		$.ajax({
			url:"clue/getClue.do",
			type:"get",
			async:false,
			data:{
				"id":'${param.id}'
			},
			success(data){
				userList = data.userList;
				currentClue = data.clue;
				var clueMessage = $(".clueMessage");
				$("#title").html('<h3>'+currentClue.fullname+' <small>'+currentClue.company+'</small></h3>');
				$.each(clueMessage,function (index,element) {
					$.each(currentClue,function (key,values) {
						if (element.id == key){
							$(element).html(values);
						}
					})
				})
			}
		})
	}

	//备注的pageList方法
	function pageList(pageNo,pageSize){
		$.ajax({
			url:"clueRemark/pageList.do",
			type:"get",
			data:{
				"clueId":currentClue.id,
				"pageNo":pageNo,
				"pageSize":pageSize
			},
			success(data){
				var html = "";
				$.each(data.dataList,function (index,element){
					html += '<div class="remarkDiv"  style="height: 60px;">';
					if (element.editFlag=='0'){
						html += '<img title='+element.createBy+' src="image/user-thumbnail.png" style="width: 30px; height:30px;">';
					}else{
						html += '<img title='+element.editBy+' src="image/user-thumbnail.png" style="width: 30px; height:30px;">';
					}
					html += '<div style="position: relative; top: -40px; left: 40px;" >';
					html += '<h5>'+element.noteContent+'</h5>';
					html += '<font color="gray">线索</font> <font color="gray">-</font> <b>'+currentClue.fullname+'</b><font color="gray">-</font> <b>'+currentClue.company+'</b>';
					if (element.editFlag=='0'){
						html += '<small style="color: gray;"> '+element.createTime+' create by '+element.createBy+'</small>';
					}else{
						html += '<small style="color: gray;"> '+element.editTime+' edit by '+element.editBy+'</small>';
					}
					html += '<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">';
					//动态生成的元素绑定事件传入参数需要以字符的形式传入('传入参数<字符串形式>')
					html += '<a class="myHref" href="javascript:void(0);" onclick="editRemark(\''+element.id+'\')"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>&nbsp;&nbsp;&nbsp;&nbsp;';
					html += '<a class="myHref" href="javascript:void(0);" onclick="delRemark(\''+element.id+'\')"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>';
					html += '</div></div></div>';
				})
				$("#remarkDivs").html(html);
				//计算总页数
				var totalPages = data.total%pageSize==0?data.total/pageSize:parseInt(data.total/pageSize)+1;
				//数据处理完毕后，结合分页插件对前端展现分页信息
				$("#clueRemarkPage").bs_pagination({
					currentPage: pageNo,
					rowsPerPage: pageSize,
					maxRowsPerPage: 20,
					totalPages: totalPages,
					totalRows: data.total,
					visiblePageLinks: 3,
					showGoToPage: true,
					showRowsPerPage: true,
					showRowsInfo: true,
					showRowsDefaultInfo: true,
					//该回调函数是我们在调用分页组件的时候触发
					onChangePage: function (event,data) {
						pageList(data.currentPage,data.rowsPerPage);
					}
				})
			}
		})
	}

	//定义删除备注的方法
	function delRemark(id){
		$.ajax({
			url:"clueRemark/delRemark.do",
			type:"post",
			data:{
				"id":id
			},
			success(data){
				if (data==1){
					pageList(1,2);
				}else{
					alert("删除失败，请稍后重试！");
				}
			}
		})
	}

	//点击修改图标打开修改备注的模态窗口
	function editRemark(id){
		//将当前备注的id值放入隐藏域当中
		$("#remarkId").val(id);
		$.ajax({
			url:"clueRemark/getRemark.do",
			type:"get",
			data:{
				"id":id
			},
			success(data){
				$("#noteContent").val(data.noteContent);
			}
		})
		$("#editRemarkModal").modal("show");
	}

	//点击关联市场活动的模块中的活动列表
    function activityPageList(pageNo,pageSize) {
		$("#search-name").val($.trim($("#hidden-name").val()));
		$.ajax({
			url:"ClueActivityRelation/pageList.do",
			data:{
				"pageNo":pageNo,
				"pageSize":pageSize,
				"name":$("#search-name").val(),
                "clueId":currentClue.id
			},
			type:"get",
			success(data){
				/*data：市场活动信息列表、分页插件需要查询出来的总记录数 */
				var html="";
				$.each(data.dataList,function (index,element) {
                    html += '<tr>'
                    html += '<td><input type="checkbox" name="select" value='+element.id+'></td>'
                    //当点击活动名称的时候跳转到详细界面，同时携带活动的id编号，用于detail.jsp界面获取活动信息
                    html += '<td>'+element.name+'</td>'
                    html += '<td>'+element.startDate+'</td>'
                    html += '<td>'+element.endDate+'</td>'
                    html += '<td>'+element.owner+'</td>'
                    html += '</tr>'
				})
				$("#activityList").html(html);
				//计算总页数
				var totalPages = data.total%pageSize==0?data.total/pageSize:parseInt(data.total/pageSize)+1;
				//数据处理完毕后，结合分页插件对前端展现分页信息
				$("#activityListPage").bs_pagination({
					currentPage: pageNo,//页码
					rowsPerPage: pageSize,//每页显示的记录条数
					maxRowsPerPage: 20,//每页最多显示的数量
					totalPages: totalPages,//总页数
					totalRows: data.total,//总的记录条数
					visiblePageLinks: 3,//显示几个卡片
					showGoToPage: true,
					showRowsPerPage: true,
					showRowsInfo: true,
					showRowsDefaultInfo: true,
					//该回调函数是我们在调用分页组件的时候触发
					onChangePage: function (event,data) {
						activityPageList(data.currentPage,data.rowsPerPage);
					}
				});
			}
		})
    }

    //定义绑定的市场活动的列表获取方法
	function getBundActivity() {
		$.ajax({
			url:"ClueActivityRelation/getBundActivity.do",
			type:"get",
			data:{
				"clueId":currentClue.id
			},
			success(data){
				var html = "";
				$.each(data,function (index,element) {
					html += "<tr>";
					html += "<td>"+element.name+"</td>";
					html += "<td>"+element.startDate+"</td>";
					html += "<td>"+element.endDate+"</td>";
					html += "<td>"+element.owner+"</td>";
					html += '<td><a href="javascript:void(0);" style="text-decoration: none;" onclick="delActivityBund(\''+element.id+'\')"><span class="glyphicon glyphicon-remove"></span>解除关联</a></td>';
					html += "</tr>";
				})
				$("#activityBund").html(html);
			}
		})
	}

	//定义解除绑定的方法
	function delActivityBund(id) {
		$.ajax({
			url:"ClueActivityRelation/delActivityBund.do",
			type:"post",
			data:{
				"id":id
			},
			success(data){
				if (data==1){
					alert("解绑成功！！");
					getBundActivity();
				}else{
					alert("解绑失败，请稍后重试！！");
				}
			}
		})
	}

	
</script>

</head>
<body>
	<!-- 关联市场活动的模态窗口 -->
	<div class="modal fade" id="bundModal" role="dialog">
        <input type="hidden" id="hidden-name">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">关联市场活动</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input type="text" class="form-control" id="search-name" style="width: 300px;"  placeholder="请输入市场活动名称，支持模糊查询" >
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
							<button type="button" id="searchActivityBtn" class="btn btn-default">查询</button>
						</form>
					</div>
					<table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td><input type="checkbox" id="selectAll"/></td>
								<td>名称</td>
								<td>开始日期</td>
								<td>结束日期</td>
								<td>所有者</td>
								<td></td>
							</tr>
						</thead>
						<tbody id="activityList">

						</tbody>
					</table>
					<div id="activityListPage"></div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
					<button type="button" class="btn btn-default" id="addRelation">关联</button>
				</div>
			</div>
		</div>
	</div>

    <!-- 修改线索的模态窗口 -->
    <div class="modal fade" id="editClueModal" role="dialog">
        <div class="modal-dialog" role="document" style="width: 90%;">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
                        <span aria-hidden="true">×</span>
                    </button>
                    <h4 class="modal-title" id="myModalLabel">修改线索</h4>
                </div>
                <div class="modal-body">
                    <form class="form-horizontal" role="form">

                        <div class="form-group">
                            <label for="edit-clueOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <select class="form-control" id="edit-clueOwner">

                                </select>
                            </div>
                            <label for="edit-company" class="col-sm-2 control-label">公司<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-company">
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="edit-call" class="col-sm-2 control-label">称呼</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <select class="form-control" id="edit-call">
                                    <option></option>
                                    <c:forEach items="${appellation}" var="a">
										<option value="${a.value}">${a.text}</option>
									</c:forEach>
                                </select>
                            </div>
                            <label for="edit-fullname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-fullname">
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="edit-job" class="col-sm-2 control-label">职位</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-job">
                            </div>
                            <label for="edit-email" class="col-sm-2 control-label">邮箱</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-email">
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="edit-phone" class="col-sm-2 control-label">公司座机</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-phone">
                            </div>
                            <label for="edit-website" class="col-sm-2 control-label">公司网站</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-website">
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="edit-mphone" class="col-sm-2 control-label">手机</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-mphone">
                            </div>
                            <label for="edit-state" class="col-sm-2 control-label">线索状态</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <select class="form-control" id="edit-state">
                                    <option></option>
                                    <c:forEach items="${clueState}" var="c">
										<option value="${c.value}">${c.text}</option>
									</c:forEach>
                                </select>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="edit-source" class="col-sm-2 control-label">线索来源</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <select class="form-control" id="edit-source">
                                    <option></option>
                                    <c:forEach items="${source}" var="s">
										<option value="${s.value}">${s.text}</option>
									</c:forEach>
                                </select>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="edit-description" class="col-sm-2 control-label">描述</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="3" id="edit-description"></textarea>
                            </div>
                        </div>

                        <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

                        <div style="position: relative;top: 15px;">
                            <div class="form-group">
                                <label for="edit-contactSummary" class="col-sm-2 control-label">联系纪要</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="3" id="edit-contactSummary"></textarea>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
                                <div class="col-sm-10" style="width: 300px;">
                                    <input type="text" class="form-control time" id="edit-nextContactTime" readonly>
                                </div>
                            </div>
                        </div>

                        <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="edit-address" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="edit-address"></textarea>
                                </div>
                            </div>
                        </div>
                    </form>

                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    <button type="button" class="btn btn-primary" id="editBtn">更新</button>
                </div>
            </div>
        </div>
    </div>

	<!-- 返回按钮 -->
	<div style="position: relative; top: 35px; left: 10px;">
		<a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left" style="font-size: 20px; color: #DDDDDD"></span></a>
	</div>
	
	<!-- 大标题 -->
	<div style="position: relative; left: 40px; top: -30px;">
		<div class="page-header" id="title">

		</div>
		<div style="position: relative; height: 50px; width: 500px;  top: -72px; left: 700px;">
			<button type="button" class="btn btn-default" onclick="window.location.href='workbench/clue/convert.jsp';"><span class="glyphicon glyphicon-retweet"></span> 转换</button>
			<button type="button" class="btn btn-default" id="editClueBtn"><span class="glyphicon glyphicon-edit"></span> 编辑</button>
			<button type="button" class="btn btn-danger" id="delClueBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
		</div>
	</div>
	
	<!-- 详细信息 -->
	<div style="position: relative; top: -70px;">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">名称</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b class="clueMessage" id="fullname"></b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">所有者</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b class="clueMessage" id="owner"></b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">公司</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b class="clueMessage" id="company"></b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">职位</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b class="clueMessage" id="job"></b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">邮箱</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b class="clueMessage" id="email"></b>&nbsp;&nbsp;</div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">公司座机</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b class="clueMessage" id="phone"></b>&nbsp;&nbsp;</div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">公司网站</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b class="clueMessage" id="website"></b>&nbsp;&nbsp;</div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">手机</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b class="clueMessage" id="mphone"></b>&nbsp;&nbsp;</div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 40px;">
			<div style="width: 300px; color: gray;">线索状态</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b class="clueMessage" id="state"></b>&nbsp;&nbsp;</div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">线索来源</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b class="clueMessage" id="source"></b>&nbsp;&nbsp;</div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 50px;">
			<div style="width: 300px; color: gray;">创建者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b class="clueMessage" id="createBy"></b>&nbsp;&nbsp;<small style="font-size: 10px; color: gray;" class="clueMessage" id="createTime"></small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 60px;">
			<div style="width: 300px; color: gray;">修改者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b class="clueMessage" id="editBy"></b>&nbsp;&nbsp;<small style="font-size: 10px; color: gray;" class="clueMessage" id="editTime"></small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 70px;">
			<div style="width: 300px; color: gray;">描述</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b class="clueMessage" id="description">

				</b>&nbsp;&nbsp;
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 80px;">
			<div style="width: 300px; color: gray;">联系纪要</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b class="clueMessage" id="contactSummary">

				</b>&nbsp;&nbsp;
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 90px;">
			<div style="width: 300px; color: gray;">下次联系时间</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b class="clueMessage" id="nextContactTime"></b>&nbsp;&nbsp;</div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px; "></div>
		</div>
        <div style="position: relative; left: 40px; height: 30px; top: 100px;">
            <div style="width: 300px; color: gray;">详细地址</div>
            <div style="width: 630px;position: relative; left: 200px; top: -20px;">
                <b class="clueMessage" id="address">

                </b>&nbsp;&nbsp;
            </div>
            <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
        </div>
	</div>
	
	<!-- 备注 -->
	<div style="position: relative; top: 40px; left: 40px;">
		<div class="page-header">
			<h4>备注</h4>
		</div>
		<div id="remarkDivs">

		</div>

		<div style="height: 50px; position: relative;top: 30px;">
			<div id="clueRemarkPage"></div>
		</div>
		<div id="remarkDiv" style="background-color: white; width: 870px; height: 90px;">
			<form role="form" id="remarkForm" style="position: relative;top: 60px; left: 10px;">
				<textarea id="remark" class="form-control" style="width: 850px; resize : none;" rows="2"  placeholder="添加备注..."></textarea>
				<p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
					<button id="cancelBtn" type="button" class="btn btn-default">取消</button>
					<button type="button" class="btn btn-primary" id="addRemark">保存</button>
				</p>
			</form>
		</div>
	</div>

	<!--修改备注的模态窗口-->
	<div class="modal fade" id="editRemarkModal" role="dialog">
		<%-- 备注的id --%>
		<input type="hidden" id="remarkId">
		<div class="modal-dialog" role="document" style="width: 40%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">修改备注</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal"  role="form">
						<div class="form-group">
							<label for="edit-description" class="col-sm-2 control-label">内容</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="noteContent"></textarea>
							</div>
						</div>
					</form>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="updateRemarkBtn">更新</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 市场活动 -->
	<div>
		<div style="position: relative; top: 60px; left: 40px;">
			<div class="page-header">
				<h4>市场活动</h4>
			</div>
			<div style="position: relative;top: 0px;">
				<table class="table table-hover" style="width: 900px;">
					<thead>
						<tr style="color: #B3B3B3;">
							<td>名称</td>
							<td>开始日期</td>
							<td>结束日期</td>
							<td>所有者</td>
							<td></td>
						</tr>
					</thead>
					<tbody id="activityBund">

					</tbody>
				</table>
			</div>
			
			<div>
				<a href="javascript:void(0);" id="activityListBtn" style="text-decoration: none;"><span class="glyphicon glyphicon-plus"></span>关联市场活动</a>
			</div>
		</div>
	</div>
	
	
	<div style="height: 200px;"></div>
</body>
</html>