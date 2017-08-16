package uk.co.corbas.slides.db;


/*
 *
 * Derived from com.marklogic.simplestack.dbclient.MarkLogicBaseServices.
 * Simplified to remove security settings
 *
 * Copyright 2012-2015 MarkLogic Corporation
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 *
 */

import org.springframework.stereotype.Component;
import org.springframework.beans.factory.annotation.Autowired;
import com.marklogic.client.query.QueryManager;

/**
 * A base class for services that interact with MarkLogic.
 */
@Component
public abstract class ServiceBase {

    /**
     * Manage MarkLogic interaction via a single database client
     */
    @Autowired
    protected Client client;

    /**
     * Gets a new MarkLogic QueryManager for a derived class
     * @return A QueryManager
     */
    protected QueryManager queryManager() {
        return client.getClient().newQueryManager();
    }


}
