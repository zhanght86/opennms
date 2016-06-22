<%@ taglib prefix="html" uri="http://jakarta.apache.org/struts/tags-html" %>
<%--
  Created by IntelliJ IDEA.
  User: laiguanhui
  Date: 2016/3/17
  Time: 17:20
  To change this template use File | Settings | File Templates.
--%>
<%@page language="java"
        contentType="text/html"
        session="true"
%>

<%@ page import="org.opennms.core.bank.WebLine" %>
<%@ page import="org.opennms.core.bank.WebLineOperator" %>
<%@ page import="org.opennms.web.springframework.security.Authentication" %>

<%@include file="/abcbank/getVars.jsp"%>

<%!
    int pageCount;
    int curPage = 1;
    WebLine[] lines;
%>

<%

    WebLineOperator op = new WebLineOperator();
    WebLine[] linesReturn = (WebLine[])request.getAttribute("webLines");
    if(linesReturn != null)
        lines = linesReturn;
    if(lines == null){
        if(request.isUserInRole(Authentication.ROLE_ADMIN))
            lines = op.selectAll("");
        else
            lines = op.selectAll(group);
    }

    int row = 0;
    int nums = lines.length;
%>

<jsp:include page="/includes/header.jsp" flush="false" >
    <jsp:param name="title" value="线路台帐" />
    <jsp:param name="headTitle" value="线路台帐" />
    <jsp:param name="breadcrumb" value="<a href='abcbank/index.jsp'>台帐管理</a>" />
    <jsp:param name="breadcrumb" value="线路台帐" />
</jsp:include>

<script type="text/javascript" >

    function addWebLine()
    {
        document.allWebLines.action="abcbank/newWebLine.jsp";
        document.allWebLines.submit();
    }

    function delectSelected(numbers){
        var selectedId = "";
        for (var i = 0; i < numbers; ++i) {
            var item = document.getElementById("choose-"+i);
            if (item.checked == true) {
                selectedId += document.getElementById("id-" + i).value + "\t";
            }
        }
        deleteWebLine(selectedId);
    }

    function deleteWebLine(id)
    {
        document.allWebLines.action="abcbank/deleteWebLine";
        document.allWebLines.webLineID.value=id;
        document.allWebLines.submit();
    }

    function searchWebLine()
    {

        document.allWebLines.action="abcbank/searchWebLine";
        document.allWebLines.submit();
    }

    function outputExcel(row){
        document.allWebLines.action="abcbank/exportWeblineExcel";
        document.allWebLines.rows.value=row;
        document.allWebLines.submit();
    }

    function selectAll(numbers) {
        for (var i = 0; i <= numbers; ++i) {
            var choose = document.getElementById("choose-"+i);
            choose.checked = true;
        }
    }

    function unselectAll(numbers) {
        for (var i = 0; i <= numbers; ++i) {
            var choose = document.getElementById("choose-"+i);
            choose.checked = false;
        }
    }
</script>

<form method="post" name="allWebLines">
    <input type="hidden" name="webLineID"/>
    <input type="hidden" name="rowID"/>
    <input type="hidden" name="searchKey"/>
    <input type="hidden" name="rows"/>

    <h3>线路台帐</h3>
    <table>

        <td align="left">
            <a id="doNewIPSegment" href="javascript:addWebLine()"><img src="images/add1.gif" alt="新增线路" border="0"></a>
            <a href="javascript:addWebLine()">新增线路</a>
        </td>

        <td align="left">&nbsp;&nbsp;
            <strong>专线类型：</strong><select id="type" name="type">
                <option value="" selected="">请选择</option>
                <%
                    for(int i = 0; i < weblineTypes.length; ++i){
                %>
                <option value="<%=weblineTypes[i]%>"> <%=weblineTypes[i]%></option>
                <%
                    }
                %>
            </select>&nbsp;&nbsp;
            <strong>申请人:</strong><input id="applicant" name="applicant" size="8" value="">&nbsp;&nbsp;
            <strong>审批人:</strong><input id="approver" name="approver" size="8" value="">&nbsp;&nbsp;
            <strong>所属支行（分行）：</strong><select id="" name="bank" onChange="selectDepts(this.value, 'dept')">
                <option value="" selected="">请选择</option>
                <%
                    for(int i = 0; i < bankNames.length; ++i){
                %>
                <option value="<%=bankNames[i]%>"><%=bankNames[i]%></option>
                <%
                    }
                %>
            </select>&nbsp;&nbsp;
            <strong>所属网点（部门）：</strong><select id="dept" name="dept">
                <option value="" selected>请选择</option>
            </select>&nbsp;&nbsp;
            <a id="doSearch" href="javascript:searchWebLine()"><img src="images/search.png" alt="搜索" border="0"></a>
            <a id="search" href="javascript:searchWebLine()">搜索</a>
        </td>

        <td align="left">
            <a id="output" href="javascript:outputExcel(<%=nums%>)"><img src="images/output.jpg" alt="输出报表" border=""0></a>
            <a href="javascript:outputExcel(<%=nums%>)">输出报表</a>
        </td>
    </table>

    <div style="overflow: auto; width: 100%;">
    <table border="1" cellspacing="0" cellpadding="2" bordercolor="black" class="tab_css_2">

        <tr class="header1">
            <td style="width: 30px"><b>选择</b></td>
            <td width="5%"><b>操作</b></td>
            <td width="5%"><b>专线类型</b></td>
            <td width="5%"><b>申请人</b></td>
            <td width="10%"><b>联系方式</b></td>
            <td width="5%"><b>审批人</b></td>
            <td width="8%"><b>所属分行（支行）</b></td>
            <td width="8%"><b>所属网点（部门）</b></td>
            <td width="15%"><b>地址</b></td>
            <td width="5%"><b>开通日期</b></td>
            <td width="5%"><b>月租</b></td>
            <td width="5%"><b>VLAN编号</b></td>
            <td width="5%"><b>物理端口号</b></td>
            <td width="5%"><b>运营商接口号</b></td>
            <td width="10%"><b>备注</b></td>
        </tr>
        <%
            int size = lines.length;
            pageCount = (size%PAGESIZE==0)?(size/PAGESIZE):(size/PAGESIZE+1);
            String tmp = request.getParameter("curPage");
            if(tmp==null){
                tmp="1";
            }
            curPage = Integer.parseInt(tmp);
            if(curPage >= pageCount)
                curPage = pageCount;
            int lineAtArray = (curPage - 1) * PAGESIZE;

            for(int j = lineAtArray; j < lineAtArray + PAGESIZE && j < lines.length; ++j){
                WebLine line = lines[j];
                String lineId = line.getId();
                String type = line.getType();
                String applicant = line.getApplicant();
                String approver = line.getApprover();
                String contact = line.getContact();
                String bank = line.getBank();
                String dept = line.getDept();
                String address = line.getAddress();
                String start_date = line.getStart_date();
                String rent = line.getRent();
                String vlan_num = line.getVlan_num();
                String port = line.getPort();
                String inter = line.getInter();
                String comment = line.getComment();
        %>
        <tr>
            <td>
                <div>
                    <input id="choose-<%=row%>" type="checkbox" value="" />
                </div>
            </td>

            <td align="center" style="vertical-align:middle;">
                <a id="<%= "ips("+lineId+").doStop" %>" href="javascript:deleteWebLine('<%=lineId%>')" onclick="return confirm('确定要删除该专线？')">删除</a>
            </td>

            <input type="hidden" id="id-<%=row%>" name="id-<%=row%>" value="<%=lineId %>"/>

            <td>
                <div id="type-<%=row%>" >
                    <%= ((type == null || type.equals("")) ? "&nbsp;" : type) %>
                    <input type="hidden" name="type-<%=row%>" value="<%= ((type == null || type.equals("")) ? "&nbsp;" : type) %>"/>
                </div>
            </td>

            <td>
                <div id="applicant-<%=row%>">
                    <%= ((applicant == null || applicant.equals("")) ? "&nbsp;" : applicant) %>
                    <input type="hidden"  name="applicant-<%=row%>" value="<%= ((applicant == null || applicant.equals("")) ? "&nbsp;" : applicant) %>"/>
                </div>
            </td>

            <td>
                <div id="contact-<%=row%>">
                    <%= ((contact == null || contact.equals("")) ? "&nbsp;" : contact) %>
                    <input type="hidden"  name="contact-<%=row%>" value="<%= ((contact == null || contact.equals("")) ? "&nbsp;" : contact) %>"/>
                </div>
            </td>

            <td>
                <div id="approver-<%=row%>" >
                    <%= ((approver == null || approver.equals("")) ? "&nbsp;" : approver) %>
                    <input type="hidden"  name="approver-<%=row%>" value="<%= ((approver == null || approver.equals("")) ? "&nbsp;" : approver) %>"/>
                </div>
            </td>

            <td>
                <div id="bank-<%=row%>">
                    <%= ((bank == null || bank.equals("")) ? "&nbsp;" : bank) %>
                    <input type="hidden"  name="bank-<%=row%>" value="<%= ((bank == null || bank.equals("")) ? "&nbsp;" : bank) %>"/>
                </div>
            </td>

            <td>
                <div id="dept-<%=row%>">
                    <%= ((dept == null || dept.equals("")) ? "&nbsp;" : dept) %>
                    <input type="hidden"  name="dept-<%=row%>" value="<%= ((dept == null || dept.equals("")) ? "&nbsp;" : dept) %>"/>
                </div>
            </td>

            <td>
                <div id="address-<%=row%>">
                    <%= ((address == null || address.equals("")) ? "&nbsp;" : address) %>
                    <input type="hidden"  name="address-<%=row%>" value="<%= ((address == null || address.equals("")) ? "&nbsp;" : address) %>"/>
                </div>
            </td>

            <td>
                <div id="start_date-<%=row%>">
                    <%= ((start_date == null || start_date.equals("")) ? "&nbsp;" : start_date) %>
                    <input type="hidden"  name="start_date-<%=row%>" value="<%= ((start_date == null || start_date.equals("")) ? "&nbsp;" : start_date) %>"/>
                </div>
            </td>

            <td>
                <div id="rent-<%=row%>">
                    <%= ((rent == null || rent.equals("")) ? "&nbsp;" : rent) %>
                    <input type="hidden"  name="rent-<%=row%>" value="<%= ((rent == null || rent.equals("")) ? "&nbsp;" : rent) %>"/>
                </div>
            </td>

            <td>
                <div id="vlan_num-<%=row%>">
                    <%= ((vlan_num == null || vlan_num.equals("")) ? "&nbsp;" : vlan_num) %>
                    <input type="hidden"  name="vlan_num-<%=row%>" value="<%= ((vlan_num == null || vlan_num.equals("")) ? "&nbsp;" : vlan_num) %>"/>
                </div>
            </td>

            <td>
                <div id="port-<%=row%>">
                    <%= ((port == null || port.equals("")) ? "&nbsp;" : port) %>
                    <input type="hidden"  name="port-<%=row%>" value="<%= ((port == null || port.equals("")) ? "&nbsp;" : port) %>"/>
                </div>
            </td>

            <td>
                <div id="inter-<%=row%>">
                    <%= ((inter == null || inter.equals("")) ? "&nbsp;" : inter) %>
                    <input type="hidden"  name="inter-<%=row%>" value="<%= ((inter == null || inter.equals("")) ? "&nbsp;" : inter) %>"/>
                </div>
            </td>

            <td>
                <div>
                    <input id="comment-<%=row%>" name="comment-<%=row%>" type="text" size="8" value="<%= ((comment == null || comment.equals("")) ? "无备注；" : comment) %>"/>
                </div>
            </td>
        </tr>

        <%
                row++;
            }
        %>
    </table>
        <div>&nbsp;
            <input type="button" onclick="javascript:selectAll(<%=row%>)" value="全选"/>&nbsp;
            <input type="button" onclick="javascript:unselectAll(<%=row%>)" value="全不选"/>&nbsp;
            <input type="button" onclick="javascript:deleteSelected(<%=row%>)" value="删除选中"/>&nbsp;
        </div>

        <br>
        <div>&nbsp;
        <a href = "abcbank/webline.jsp?curPage=1" >首页</a>
        <%
            if(curPage - 1 > 0)
                out.print("<a href = 'abcbank/webline.jsp?curPage=" + (curPage - 1) + "' >上一页</a>");
            else
                out.print("上一页");
        %>
        <%
            if(curPage + 1 <= pageCount)
                out.print("<a href = 'abcbank/webline.jsp?curPage=" + (curPage + 1) + "' >下一页</a>");
            else
                out.print("下一页");
        %>
        <a href = "abcbank/webline.jsp?curPage=<%=pageCount%>" >尾页</a>
        第<%=curPage%>页/共<%=pageCount%>页
        </div>
        </div>

</form>

<jsp:include page="/includes/footer.jsp" flush="false" />

