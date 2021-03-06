/*******************************************************************************
 * This file is part of OpenNMS(R).
 *
 * Copyright (C) 2010-2012 The OpenNMS Group, Inc.
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

package org.opennms.netmgt.rt;

import java.io.Serializable;

import org.apache.commons.lang.builder.ToStringBuilder;

public class RTUser implements Serializable {
    /**
	 * 
	 */
	private static final long serialVersionUID = -4830811460415894277L;
	private long m_id;
    private String m_username;
    private String m_realname;
    private String m_email;

    public RTUser(final long id, String username, String realname, String email) {
        m_id = id;
        m_username = username;
        m_realname = realname;
        m_email = email;
    }

    public long getId() {
        return m_id;
    }
    
    public String getUsername() {
        return m_username;
    }
    
    public String getRealname() {
        return m_realname;
    }
    
    public String getEmail() {
        return m_email;
    }
    
    public String toString() {
        return new ToStringBuilder(this)
            .append("id", m_id)
            .append("username", m_username)
            .append("realname", m_realname)
            .append("email", m_email)
            .toString();
    }
}
