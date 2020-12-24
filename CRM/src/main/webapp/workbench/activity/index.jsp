<%@ page import="com.quanrong.utils.UUIDUtil" %>
<%@ page import="com.quanrong.utils.DateUtil" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
	String basePath = request.getScheme()+"://"+request.getServerName()+":"
				+request.getServerPort()+request.getContextPath()+"/";
%>
<!DOCTYPE html>
<html>
<head>
	<base href="<%=basePath%>">
<meta charset="UTF-8">

<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />
<link href="jquery/bs_pagination/jquery.bs_pagination.min.css" type="text/css" rel="stylesheet"/>

<script type="text/javascript" src="jquery/jquery-1.11.1-min.js" charset="UTF-8"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js" charset="UTF-8"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js" charset="UTF-8"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js" charset="UTF-8"></script>
<script type="text/javascript" src="jquery/bs_pagination/jquery.bs_pagination.min.js" charset="UTF-8"></script>
<script type="text/javascript" src="jquery/bs_pagination/en.js" charset="UTF-8"></script>

<script type="text/javascript">

	$(function(){
		//页面加载完毕获取活动列表中的数据
		pageList(1,2);

		//导入时间拾取器
		$(".time").datetimepicker({
			minView:"month",
			language:"zh-CN",
			format:"yyyy-mm-dd",
			autoclose:true,
			todayBtn:true,
			pickerPosition:"bottom-left"
		});

		//点击创建按钮，弹出模态窗口
		$("#addBtn").click(function (){
			//通过ajax请求，从后台获取用户信息列表
			$.ajax({
				url:"activity/getUserList.do",
				type:"get",
				success(data){
					$("#create-marketActivityOwner").empty();
					$.each(data,function (index,element){
						$("#create-marketActivityOwner")
								.append("<option value="+element.id+">"+element.name+"</option>")

					})
					/*操作模态窗口的方式：找到需要操作模态窗口的JQuery对象，调用modal方法
				 	方法参数：show打开模态窗口；hide：关闭模态窗口*/
					//下拉框数据处理完毕之后打开模态窗口
					$("#createActivityModal").modal("show");
				}
			})
		})

		//保存市场活动记录
		$("#saveBtn").click(function (){
			var owner = $("#create-marketActivityOwner").val();
			var name = $.trim($("#create-marketActivityName").val());
			if (owner=="" || name==""){
				alert("请至少输入所有者和名称！！")
				return false;
			}
			$.ajax({
				url:"activity/saveActivity.do",
				type:"post",
				data:{
					"owner":owner,
					"name":name,
					"startDate":$.trim($("#create-startTime").val()),
					"endDate":$.trim($("#create-endTime").val()),
					"cost":$.trim($("#create-cost").val()),
					"description":$("#create-describe").val(),
					"createBy":"${user.name}",
				},
				success(data){
					if (data==1){
						alert("保存成功！");
						//属性市场活动列表信息
						pageList(1,2);
						//关闭模态窗口，同时重置表单
						$("#createActivityModal").modal("hide");
						$("#addActivity")[0].reset();
					}else{
						alert("保存失败！请稍后重试！");
					}
				}
			})
		})

		//点击查询按钮，执行对应的信息查询
		$("#searchBtn").click(function (){
			//每一次点击查询按钮的时候，我们应该使用隐藏域将搜索框中的信息保存起来
			$("#hidden-name").val($.trim($("#search-name").val()));
			$("#hidden-owner").val($.trim($("#search-owner").val()));
			$("#hidden-startDate").val($.trim($("#search-startDate").val()));
			$("#hidden-endDate").val($.trim($("#search-endDate").val()));
			pageList(1,2);
		})

		//点击全选的复选框按钮，触发全选操作
		$("#selectAll").click(function (){
			$("input[name=select]").prop("checked",this.checked);
		})

		//动态生成的元素，需要使用on方法绑定事件
		// $(需要绑定元素的有效外层元素).on(绑定事件的方式，需要绑定元素的JQuery对象，回调函数)
		$("#activityBody").on("click",$("input[name=select]"),function (){
			$("#selectAll").prop("checked",$("input[name=select]").length==$("input[name=select]:checked").length);
		})

		//为删除按钮绑定事件，执行市场活动的删除
		$("#deleteBtn").click(function (){
			//获取所有选中的市场活动JQuery对象
			var $select = $("input[name=select]:checked");
			if ($select.length==0){
				alert("请选择需要删除的记录！");
			}else{
				var ids = [];
				for (var i=0; i < $select.length; i++){
					ids.push($select[i].value);
				}
				$.ajax({
					url:"activity/delActivity.do",
					type:"post",
					data:{"ids":ids},
					traditional: true,
					success(data){
						alert("成功删除"+data+"条数据! 删除失败"+($select.length-data)+"条数据！");
						pageList(1,2);
					}
				})
			}
		})

		//点击修改按钮，弹出修改模态窗口
		$("#editBtn").click(function (){
			if ($("input[name=select]:checked").length!=1){
				alert("请选择一个活动进行修改！");
			}else{
				//导入时间拾取器
				$(".time").datetimepicker({
					minView:"month",
					language:"zh-CN",
					format:"yyyy-mm-dd",
					autoclose:true,
					todayBtn:true,
					pickerPosition:"botton-left"
				});
				//通过ajax请求，从后台获取当前修改的活动的信息
				$.ajax({
					url:"activity/getActivity.do",
					type:"get",
					data:{
						"id":$("input[name=select]:checked").val()
					},
					success(data){
						$("#edit-marketActivityOwner").empty();
						$.each(data.userList,function (index,element){
							if (element.name==data.activity.owner){
								$("#edit-marketActivityOwner")
										.append("<option value="+element.id+" selected>"+element.name+"</option>")
							}else{
                                $("#edit-marketActivityOwner")
                                    .append("<option value="+element.id+">"+element.name+"</option>")
                            }
						})
						$("#edit-marketActivityName").val(data.activity.name);
						$("#edit-startTime").val(data.activity.startDate);
						$("#edit-endTime").val(data.activity.endDate);
						$("#edit-cost").val(data.activity.cost);
						$("#edit-describe").val(data.activity.description)
						$("#editActivityModal").modal("show");
					}
				})
			}
		})

        //点击更新按钮，将数据更新到数据库当中
        $("#editSaveBtn").click(function (){
            var owner = $("#edit-marketActivityOwner").val();
            var name = $.trim($("#edit-marketActivityName").val());
            if (owner=="" || name==""){
                alert("请至少输入所有者和名称！！")
                return false;
            }
            $.ajax({
                url:"activity/editActivity.do",
                type:"post",
                data:{
                    "id":$("input[name=select]:checked").val(),
                    "owner":owner,
                    "name":name,
                    "startDate":$.trim($("#edit-startTime").val()),
                    "endDate":$.trim($("#edit-endTime").val()),
                    "cost":$.trim($("#edit-cost").val()),
                    "description":$("#edit-describe").val(),
                    "editBy":"${user.name}"
                },
                success(data){
                    if (data==1){
                        alert("修改成功！");
                        //属性市场活动列表信息
                        pageList(1,2);
                        //关闭模态窗口，同时重置表单
                        $("#editActivityModal").modal("hide");
                    }else{
                        alert("修改失败！请稍后重试！");
                    }
                }
            })
        })
	});


	//向后台发出ajax请求，获取活动列表数据
	/*什么情况下需要调用pageList方法：
		* 	1、进入市场活动界面的时候调用这个方法
		* 	2、在添加、修改、删除后需要刷新市场活动列表
		* 	3、点击查询的时候需要刷新活动列表
		* 	4、点击分页组件的时候需要属性活动列表*/
	function pageList(pageNo,pageSize){
		//执行查询前，将隐藏域中的信息取出来，重新赋予到搜索框中
		$("#search-name").val($.trim($("#hidden-name").val()));
		$("#search-owner").val($.trim($("#hidden-owner").val()));
		$("#search-startDate").val($.trim($("#hidden-startDate").val()));
		$("#search-endDate").val($.trim($("#hidden-endDate").val()));
		$.ajax({
			url:"activity/pageList.do",
			data:{
				"pageNo":pageNo,
				"pageSize":pageSize,
				"name":$.trim($("#search-name").val()),
				"owner":$.trim($("#search-owner").val()),
				"startDate":$.trim($("#search-startDate").val()),
				"endDate":$.trim($("#search-endDate").val())
			},
			type:"get",
			success(data){
				/*data：市场活动信息列表、分页插件需要查询出来的总记录数 */
				var html="";
				$.each(data.dataList,function (index,element) {
					html += '<tr class="active">'
					html += '<td><input type="checkbox" name="select" value='+element.id+'></td>'
					//当点击活动名称的时候跳转到详细界面，同时携带活动的id编号，用于detail.jsp界面获取活动信息
					html += '<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/activity/detail.jsp?id='+element.id+'\';">'+element.name+'</a></td>'
					html += '<td>'+element.owner+'</td>'
					html += '<td>'+element.startDate+'</td>'
					html += '<td>'+element.endDate+'</td>'
					html += '</tr>'
				})
				$("#activityBody").html(html);
				//计算总页数
				var totalPages = data.total%pageSize==0?data.total/pageSize:parseInt(data.total/pageSize)+1;
				//数据处理完毕后，结合分页插件对前端展现分页信息
				$("#activityPage").bs_pagination({
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
						pageList(data.currentPage,data.rowsPerPage);
					}
				});
			}
		})
	}
</script>
</head>
<body>
	<!--创建隐藏域保存数据-->
	<input type="hidden" id="hidden-name"/>
	<input type="hidden" id="hidden-owner"/>
	<input type="hidden" id="hidden-startDate"/>
	<input type="hidden" id="hidden-endDate"/>
	<!-- 创建市场活动的模态窗口 -->
	<div class="modal fade" id="createActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">创建市场活动</h4>
				</div>
				<div class="modal-body">
				
					<form id="addActivity" class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="create-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-marketActivityOwner">
								</select>
							</div>
                            <label for="create-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-marketActivityName">
                            </div>
						</div>
						
						<div class="form-group">
							<label for="create-startTime" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="create-startTime" readonly>
							</div>
							<label for="create-endTime" class="col-sm-2 control-label" >结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="create-endTime" readonly>
							</div>
						</div>
                        <div class="form-group">

                            <label for="create-cost" class="col-sm-2 control-label">成本</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-cost">
                            </div>
                        </div>
						<div class="form-group">
							<label for="create-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-describe"></textarea>
							</div>
						</div>
						
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" id="saveBtn" class="btn btn-primary">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改市场活动的模态窗口 -->
	<div class="modal fade" id="editActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel2">修改市场活动</h4>
				</div>
				<div class="modal-body">
				
					<form class="form-horizontal" id="editActivity" role="form">
					
						<div class="form-group">
							<label for="edit-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-marketActivityOwner">

								</select>
							</div>
                            <label for="edit-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-marketActivityName" >
                            </div>
						</div>

						<div class="form-group">
							<label for="edit-startTime" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="edit-startTime" readonly>
							</div>
							<label for="edit-endTime" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="edit-endTime" readonly>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-cost" class="col-sm-2 control-label">成本</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-cost">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-describe"></textarea>
							</div>
						</div>
						
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="editSaveBtn">更新</button>
				</div>
			</div>
		</div>
	</div>
	
	

	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>市场活动列表</h3>
			</div>
		</div>
	</div>
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
				      <input class="form-control" type="text" id="search-name"/>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" type="text" id="search-owner"/>
				    </div>
				  </div>


				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">开始日期</div>
					  <input class="form-control" type="text" id="search-startDate" />
				    </div>
				  </div>
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">结束日期</div>
					  <input class="form-control" type="text" id="search-endDate">
				    </div>
				  </div>
				  
				  <button type="button" id="searchBtn" class="btn btn-default">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
				<div class="btn-group" style="position: relative; top: 18%;">
					<!--
						点击创建按钮，观察两个属性和属性值：
							data-toggle="modal"：表示触发该按钮，将要打开一个模态窗口
							data-target="#createActivityModal"：表示打开哪一个模态窗口
						这种写法存在问题：无法对当前的按钮进行功能的扩充，所以触发模态窗口的方式使用JS实现
					-->
					<button type="button" class="btn btn-primary" id="addBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
					<button type="button" class="btn btn-default" id="editBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
					<button type="button" class="btn btn-danger" id="deleteBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="selectAll" /></td>
							<td>名称</td>
                            <td>所有者</td>
							<td>开始日期</td>
							<td>结束日期</td>
						</tr>
					</thead>
					<tbody id="activityBody">
					</tbody>
				</table>
			</div>
			
			<div style="height: 50px; position: relative;top: 30px;">
					<div id="activityPage"></div>
			</div>
			
		</div>
		
	</div>
</body>
</html>