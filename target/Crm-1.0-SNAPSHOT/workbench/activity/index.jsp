<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";
%>
<!DOCTYPE html>
<html>
<head>
    <base href="<%=basePath%>">
    <meta charset="UTF-8">

    <link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet"/>
    <link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css"
          rel="stylesheet"/>

    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
    <script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
    <link rel="stylesheet" type="text/css" href="jquery/bs_pagination/jquery.bs_pagination.min.css">
    <script type="text/javascript" src="jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
    <script type="text/javascript" src="jquery/bs_pagination/en.js"></script>


    <script type="text/javascript">

        $(function () {

            $(".time").datetimepicker({
                minView: "month",
                language: 'zh-CN',
                format: 'yyyy-mm-dd',
                autoclose: true,
                todayBtn: true,
                pickerPosition: "bottom-left"
            })

            //为创建按钮绑定事件，打开需要操作的模态窗口
            $("#addBtn").click(function () {

                //需要操作该模态窗口的jquery对象，调用modal方法，为该窗口传递参数 show:打开模态窗口   hide:关闭模态窗口
                // $("#createActivityModal").modal("show");

                //走后台，目的是为了取得用户信息列表
                $.ajax({
                    url: "workbench/activity/getUserList.do",
                    type: "post",
                    dataType: "json",
                    success: function (data) {
                        /*
                            List<User> ulist

                            data
                                [{用户1}，{用户2}，{用户3}]


                         */
                        var html = "<option></option>"

                        //遍历出来的每一个n，就是每一个user对象
                        $.each(data, function (i, n) {

                            html += "<option value='" + n.id + "'>" + n.name + "</option>";

                        })
                        $("#create-owner").html(html);

                        //将当前登录的用户设置为下拉框默认的选项
                        /*
                            <select id="create=owner">
                                <option value="">张三</option>
                                <option value="">李四</option>
                            </select>



                            $("#create-owner").val();

                         */
                        //取得当前登录用户的id
                        var id = "${user.id}"
                        $("#create-owner").val(id);
                        //所有者下拉框处理完毕后，展现模态窗口

                        $("#createActivityModal").modal("show");
                    }
                })


            })
            //为保存按钮绑定添加操作
            $("#saveBtn").click(function () {
                $.ajax({
                    url: "workbench/activity/save.do",
                    data: {
                        "owner": $.trim($("#create-owner").val()),
                        "name": $.trim($("#create-name").val()),
                        "startDate": $.trim($("#create-startDate").val()),
                        "endDate": $.trim($("#create-endDate").val()),
                        "cost": $.trim($("#create-cost").val()),
                        "description": $.trim($("#create-description").val()),
                    },
                    type: "post",
                    dataType: "json",
                    success: function (data) {
                        /*
                            data
                            {"success" : true/false}
                         */
                        if (data.success) {
                            //添加成功后
                            // 刷新市场活动信息列表（局部刷新）
                            /*
                            pageList(1,2)

                            pageList($("#activityPage").bs_pagination('getOption','currentPage')
                            操作后停留在当前页


                            ,$("#activityPage").bs_pagination('getOption','rowsPage'),)
                            操作后维持已经设置好的每页展现的记录数


                             */
                            //添加操作后，应该回到第一页，维持每页展现的记录数
                            pageList(1,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
                            //清空模态窗口中的数据
                            $("#avtivityAddForm")[0].reset();
                            //关闭市场活动模态窗口
                            $("#createActivityModal").modal("hide");
                        } else {
                            alert("添加市场活动失败")
                        }
                    }
                })

            })

            //页面加载完毕后触发一个方法
            pageList(1, 2);

            //为查询按钮绑定事件，触发pagelist方法
            $("#searchBtn").click(function () {
                /*
                    点击查询按钮的时候，我们应该将我们搜索框中的信息先保存起来,保存到隐藏域中

                 */
                $("#hidden-name").val($.trim($("#search-name").val()));
                $("#hidden-owner").val($.trim($("#search-owner").val()));
                $("#hidden-startDate").val($.trim($("#search-startDate").val()));
                $("#hidden-endDate").val($.trim($("#search-endDate").val()));

                pageList(1,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));


            })

            //为全选复选框绑定事件，触发全选操作
            $("#qx").click(function () {
                $("input[name=xz]").prop("checked", this.checked);
            })
            //这种做法是不行的
            //因为动态生成的元素是不能够以普通绑定事件的形式来进行操作的
            // $("input[name=xz]").click(function () {
            //     alert(123)
            // })

            /*
                动态生成的元素要以on方法的形式来触发事件

                语法：
                    （需要绑定元素的有效外层元素）.on(绑定事件的方式，需要绑定的元素的jQuery对象，回调函数)
             */
            $("#activityBody").on("click", $("input[name=xz]"), function () {

                $("#qx").prop("checked", $("input[name=xz]").length == $("input[name=xz]:checked").length);

            })

            //为删除按钮绑定事件，执行市场活动的删除操作
            $("#deleteBtn").click(function () {

                //找到复选框选中的所有挑√的jQuery对象
                var $xz = $("input[name=xz]:checked")

                if ($xz.length == 0) {
                    alert("请选择需要删除的记录");
                    //选择了，有可能是一条有可能是多条
                } else {


                    if (confirm("确定删除所选中的记录吗？")) {
                        //url:workbench/activity/delete.do?id=xxx&id=xxx&id=xxx
                        //拼接参数
                        var param = "";

                        //$xz中的每一个dom对象遍历出来，取其value值，就相当于取得了需要删除的记录id
                        for (var i = 0; i < $xz.length; i++) {
                            param += "id=" + $($xz[i]).val();
                            //目的是为了取得id=xxx&id=xxx&id=xxx这种形式的id对应的复选框串，这样便能多选或者单选了
                            //如果不是最后一个元素需要在后面最加一个&符
                            if (i < $xz.length - 1) {
                                param += "&";
                            }
                        }

                        $.ajax({
                            url: "workbench/activity/delete.do",
                            data: param,
                            type: "post",
                            dataType: "json",
                            success: function (data) {

                                /*
                                    data
                                        {"success":true/false}
                                 */

                                if (data.success) {

                                    //删除成功后
                                    // pageList(1, 2);
                                    pageList(1,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));


                                } else {
                                    alert("删除市场活动失败")
                                }
                            }
                        })

                    }

                }

            })

            //为修改按钮绑定事件，目的是打开修改按钮的模态窗口
            $("#editBtn").click(function () {

                var $xz = $("input[name=xz]:checked");

                if($xz.length==0){

                    alert("请选择需要修改的记录")

                }else if($xz.length>1){
                    alert("只能选择一条记录进行修改")
                    //肯定只选择了一条记录
                }else {
                    var id = $xz.val();

                    $.ajax({
                        url : "workbench/activity/getUserListAndActivity.do",
                        data : {
                                "id":id
                        },
                        type : "get",
                        dataType : "json",
                        success : function (data) {




                            /*
                                data
                                    用户列表
                                    市场活动对象
                                    {“uList”:[{用户1}{用户2}{用户3}],"a":{市场活动}}
                             */
                            //处理所有者下拉框
                            var html = "<option></option>";

                            $.each(data.uList,function (i,n) {
                                html += "<option value='"+n.id+"'>"+n.name+"</option>"
                            })

                            $("#edit-owner").html(html);

                            //处理单条activity

                            $("#edit-id").val(data.a.id);
                            $("#edit-name").val(data.a.name);
                            $("#edit-owner").val(data.a.owner);
                            $("#edit-startDate").val(data.a.startDate);
                            $("#edit-endDate").val(data.a.endDate);
                            $("#edit-cost").val(data.a.cost);
                            $("#edit-description").val(data.a.description);

                            //打开修改操作的模态窗口
                            $("#editActivityModal").modal("show");

                        }


                    })


                }

            })

            //为模态窗口中更新按钮绑定事件
            /*
                在实际项目开发中，一定是先做添加后做修改
                所以为了节省开发时间，修改操作一般都是copy添加操作
             */
            $("#updateBtn").click(function () {
                $.ajax({
                    url: "workbench/activity/update.do",
                    data: {
                        "id": $.trim($("#edit-id").val()),
                        "owner": $.trim($("#edit-owner").val()),
                        "name": $.trim($("#edit-name").val()),
                        "startDate": $.trim($("#edit-startDate").val()),
                        "endDate": $.trim($("#edit-endDate").val()),
                        "cost": $.trim($("#edit-cost").val()),
                        "description": $.trim($("#edit-description").val()),
                    },
                    type: "post",
                    dataType: "json",
                    success: function (data) {
                        /*
                            data
                            {"success" : true/false}
                         */
                        if (data.success) {
                            //添加成功后
                            // 刷新市场活动信息列表（局部刷新）
                            //pageList(1,2)

                            pageList($("#activityPage").bs_pagination('getOption', 'currentPage')
                                ,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
                            //关闭修改操作的模态窗口
                            $("#editActivityModal").modal("hide");
                        } else {
                            alert("修改市场活动失败")
                        }
                    }
                })

            })

        });


        function pageList(pageNo, pageSize) {
            //将全选的复选框√干掉
            $("#qx").prop("checked", false);
            //查询前，将隐藏域中保存的信息取出来，保存到搜索框中
            $("#search-name").val($.trim($("#hidden-name").val()));
            $("#search-owner").val($.trim($("#hidden-owner").val()));
            $("#search-startDate").val($.trim($("#hidden-startDate").val()));
            $("#search-endDate").val($.trim($("#hidden-endDate").val()));


            $.ajax({
                url: "workbench/activity/pageList.do",
                data: {
                    "pageNo": pageNo,
                    "pageSize": pageSize,
                    "name": $.trim($("#search-name").val()),
                    "owner": $.trim($("#search-owner").val()),
                    "startDate": $.trim($("#search-startDate").val()),
                    "endDate": $.trim($("#search-endDate").val()),
                },
                type: "get",
                dataType: "json",
                success: function (data) {
                    /*
                         我们需要的市场活动信息列表
                         [{市场活动1}，{市场活动2}，{3}]  List<Activity> alist
                         分页插件需要的，查询出来的总记录数
                         {“total” : 100} int total

                         {"total" : 100,"datalist":[{市场活动1}，{市场活动2}，{3}]}
                     */
                    var html = "";
                    //每一个n就是每一个市场活动对象
                    $.each(data.dataList, function (i, n) {

                        html += '<tr class="active">';
                        html += '<td><input type="checkbox" name="xz" value="' + n.id + '"/></td>';
                        html += '<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/activity/detail.do?id='+n.id+'\';">' + n.name + '</a></td>';
                        html += '<td>' + n.owner + '</td>';
                        html += '<td>' + n.startDate + '</td>';
                        html += '<td>' + n.endDate + '</td>';
                        html += '</tr>';

                    })

                    $("#activityBody").html(html);

                    //计算总页数
                    var totalPages = data.total % pageSize == 0 ? data.total / pageSize : parseInt(data.total / pageSize) + 1;

                    //数据处理完毕后，结合分页插件，对前端展现分页信息
                    $("#activityPage").bs_pagination({
                        currentPage: pageNo, // 页码
                        rowsPerPage: pageSize, // 每页显示的记录条数
                        maxRowsPerPage: 20, // 每页最多显示的记录条数
                        totalPages: totalPages, // 总页数
                        totalRows: data.total, // 总记录条数

                        visiblePageLinks: 3, // 显示几个卡片

                        showGoToPage: true,
                        showRowsPerPage: true,
                        showRowsInfo: true,
                        showRowsDefaultInfo: true,
                        //该回调函数是在我们点击分页组件的时候触发的
                        onChangePage: function (event, data) {
                            pageList(data.currentPage, data.rowsPerPage);
                        }


                    });

                }
            })

        }

    </script>


</head>
<body>

<input type="hidden" id="hidden-name">
<input type="hidden" id="hidden-owner">
<input type="hidden" id="hidden-startDate">
<input type="hidden" id="hidden-endDate">




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

                <form id="avtivityAddForm" class="form-horizontal" role="form">

                    <div class="form-group">
                        <label for="create-marketActivityOwner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-owner">
                                <!--通过后台在打开模态窗口之前，动态获得option-->
                            </select>
                        </div>
                        <label for="create-marketActivityName" class="col-sm-2 control-label">名称<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-name">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-startTime" class="col-sm-2 control-label">开始日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control time" id="create-startDate" readonly>
                        </div>
                        <label for="create-endTime" class="col-sm-2 control-label">结束日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control time" id="create-endDate" readonly>
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
                            <textarea class="form-control" rows="3" id="create-description"></textarea>
                        </div>
                    </div>

                </form>

            </div>
            <div class="modal-footer">
                <!--data-dismiss:关闭模态窗口-->
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="saveBtn">保存</button>
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

                <form class="form-horizontal" role="form">
                    <input type="hidden" id="edit-id">
                    <div class="form-group">
                        <label for="edit-marketActivityOwner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-owner">

                            </select>
                        </div>
                        <label for="edit-marketActivityName" class="col-sm-2 control-label">名称<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-name">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-startTime" class="col-sm-2 control-label">开始日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control time" id="edit-startDate">
                        </div>
                        <label for="edit-endTime" class="col-sm-2 control-label">结束日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control time" id="edit-endDate">
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
                            <!--
                                关于文本域textarea
                                    (1)一定要以标签对的形式呈现，正常状态下标签对要紧紧挨着
                                    (2)textarea虽然是以标签对的形式来呈现的，但是它也是属于表单元素范畴

                            -->
                            <textarea class="form-control" rows="3" id="edit-description"></textarea>
                        </div>
                    </div>

                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="updateBtn">更新</button>

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
                        <input class="form-control" type="text" id="search-name">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">所有者</div>
                        <input class="form-control" type="text" id="search-owner">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">开始日期</div>
                        <input class="form-control time" type="text" id="search-startDate" readonly/>
                    </div>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">结束日期</div>
                        <input class="form-control time" type="text" id="search-endDate" readonly>
                    </div>
                </div>

                <button type="button" id="searchBtn" class="btn btn-default">查询</button>

            </form>
        </div>
        <div class="btn-toolbar" role="toolbar"
             style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
            <div class="btn-group" style="position: relative; top: 18%;">

                <!--
                    点击创建按钮，观察两个属性和属性值

                    data-toggle="motal"
                    表示触发该按钮，将要打开一个模态窗口
                    data-target = "id"
                    表示要打开哪个模态窗口，通过#id的形式找到该窗口
                    但是这样做是有问题的，这样就把属性和属性值写死了，没有办法对按钮功能进行扩充
                -->
                <button type="button" class="btn btn-primary" id="addBtn"><span class="glyphicon glyphicon-plus"></span>创建</button>
                <button type="button" class="btn btn-default" id="editBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
                <button type="button" class="btn btn-danger" id="deleteBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
            </div>

        </div>
        <div style="position: relative;top: 10px;">
            <table class="table table-hover">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td><input type="checkbox" id="qx"/></td>
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