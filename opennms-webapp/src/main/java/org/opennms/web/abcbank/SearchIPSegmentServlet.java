package org.opennms.web.abcbank;

import org.opennms.core.bank.IPSegment;
import org.opennms.core.bank.IPSegmentOperater;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;

/**
 * Created by laiguanhui on 2016/4/28.
 */
public class SearchIPSegmentServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String ipSeg = request.getParameter("search");
        IPSegmentOperater op = new IPSegmentOperater();
        response.setContentType("text/html;charset=gb2312");
        PrintWriter pw=response.getWriter();

        try {
            IPSegment[] rs = op.selectAll(ipSeg);
            if(rs != null && rs.length > 0){
                request.setAttribute("ipSeg", rs);
                request.getRequestDispatcher("ipsegment.jsp").forward(request, response);
            } else {
                pw.print("<script language='javascript'>alert('查询无结果，请更换查询内容！' );window.location=('/opennms/abcbank/ipsegment.jsp');</script>");
                pw.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}
