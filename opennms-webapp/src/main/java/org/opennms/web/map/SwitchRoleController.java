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

package org.opennms.web.map;

/*
 * Created on 8-giu-2005
 *
 */
import java.io.BufferedWriter;
import java.io.IOException;
import java.io.OutputStreamWriter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


import org.opennms.core.utils.ThreadCategory;

import org.opennms.web.map.MapsConstants;
import org.opennms.web.map.view.*;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.Controller;


/**
 * <p>SwitchRoleController class.</p>
 *
 * @author mmigliore
 *
 * this class provides to create, manage and delete
 * proper session objects to use when working with maps
 * @version $Id: $
 * @since 1.8.1
 */
public class SwitchRoleController implements Controller {
	ThreadCategory log;

	private Manager manager;
	
	
	/**
	 * <p>Getter for the field <code>manager</code>.</p>
	 *
	 * @return a {@link org.opennms.web.map.view.Manager} object.
	 */
	public Manager getManager() {
		return manager;
	}

	/**
	 * <p>Setter for the field <code>manager</code>.</p>
	 *
	 * @param manager a {@link org.opennms.web.map.view.Manager} object.
	 */
	public void setManager(Manager manager) {
		this.manager = manager;
	}

	/** {@inheritDoc} */
	public ModelAndView handleRequest(HttpServletRequest request, HttpServletResponse response) throws IOException {
		
		ThreadCategory.setPrefix(MapsConstants.LOG4J_CATEGORY);
		log = ThreadCategory.getInstance(this.getClass());
		String adminModeStr = request.getParameter("adminMode");
		boolean adminMode = false;
		BufferedWriter bw = new BufferedWriter(new OutputStreamWriter(response
				.getOutputStream(), "UTF-8"));
		try {
			
			if(adminModeStr!=null ){
				adminMode=Boolean.parseBoolean(adminModeStr);
				log.info("Swithing to mode admin: "+!adminMode);
				bw.write(ResponseAssembler.getActionOKMapResponse(MapsConstants.SWITCH_MODE_ACTION));
			} else{
				throw new IllegalStateException("Parameter adminMode is null ");
			}
		} catch (Throwable e) {
			log.error("Exception found when changing adminMode: ",e);
			bw.write(ResponseAssembler.getMapErrorResponse(MapsConstants.SWITCH_MODE_ACTION));
		} finally {
			bw.close();
		}
		

		return null;
	}

}
