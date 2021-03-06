/*******************************************************************************
 * This file is part of OpenNMS(R).
 *
 * Copyright (C) 2009-2012 The OpenNMS Group, Inc.
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

package org.opennms.web.filter;

import org.hibernate.criterion.Conjunction;
import org.hibernate.criterion.Criterion;
import org.hibernate.criterion.Restrictions;

/**
 * AndFilter
 *
 * @author brozow
 * @version $Id: $
 * @since 1.8.1
 */
public class AndFilter extends ConditionalFilter {
    
    /**
     * <p>Constructor for AndFilter.</p>
     *
     * @param filters a {@link org.opennms.web.filter.Filter} object.
     */
    public AndFilter(Filter...filters) {
        super("AND", filters);
    }

    /** {@inheritDoc} */
    @Override
    public Criterion getCriterion() {
        Conjunction conjunction = Restrictions.conjunction();
        
        for(Filter filter : getFilters()) {
            conjunction.add(filter.getCriterion());
        }
        
        return conjunction;
    }

}
