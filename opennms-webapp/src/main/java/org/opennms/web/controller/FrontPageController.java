/*******************************************************************************
 * This file is part of OpenNMS(R).
 *
 * Copyright (C) 2007-2012 The OpenNMS Group, Inc.
 * OpenNMS(R) is Copyright (C) 1999-2012 The OpenNMS Group, Inc.
 *
 * OpenNMS(R) is a registered trademark of The OpenNMS Group, Inc.
 *
 * OpenNMS(R) is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published
 * by the Free Software Foundation, either version 3 of the License,
 * or (at your option) any later version.
 *
 * OpenNMS(R) is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with OpenNMS(R).  If not, see:
 *      http://www.gnu.org/licenses/
 *
 * For more information contact:
 *     OpenNMS(R) Licensing <license@opennms.org>
 *     http://www.opennms.org/
 *     http://www.opennms.com/
 *******************************************************************************/

package org.opennms.web.controller;

import org.opennms.core.bank.BankLogWriter;
import org.opennms.web.springframework.security.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * <p>FrontPageController class.</p>
 *
 * @author ranger
 * @since 1.8.1
 */
@Controller
@RequestMapping("/frontPage.htm")
public class FrontPageController {

    @RequestMapping(method = RequestMethod.GET)
    protected ModelAndView handleRequest(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String userID = request.getRemoteUser();
        BankLogWriter logWriter = BankLogWriter.getSingle();
        logWriter.writeLog("用户登录：" + userID);
        if (request.isUserInRole(Authentication.ROLE_DASHBOARD)) {
            return new ModelAndView("redirect:/dashboard.jsp");
        } else if(request.isUserInRole(Authentication.ROLE_ADMIN)){
            return new ModelAndView("redirect:/index.jsp");
        } else{
            return new ModelAndView("redirect:/abcbank/index.jsp");
        }
    }
}
