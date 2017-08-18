/*
 * Derived from com.marklogic.samplestack.dbclient.Clients
 * Simplified to support only a single role for this application and
 * updated to use non deprecated methods.
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
 */
package uk.co.corbas.slides.db;


import com.marklogic.client.query.QueryManager;
import org.springframework.core.env.Environment;

import com.marklogic.client.DatabaseClient;
import com.marklogic.client.DatabaseClientFactory;
import org.springframework.stereotype.Component;

/**
 * A simple wrapper for a connection that enables autowiring of the MarkLogic
 * database client in the Services
 *
 */
@Component
public class Client {

    /**
     * Provided by Spring at startup, for accessing environment-specific variables.
     */
    private Environment env;

    /**
     * Database client to be returned to services
     */
    private DatabaseClient client;

    public Client(Environment env) {
        super();
        this.env = env;
        this.client = initializeDatabaseClient();
    }

    /**
     * Get the client
     * @return client - a DatabaseClient object
     */
    public DatabaseClient getClient() {
        return client;
    }

    /**
     * Constructs a Java Client API database Client
     * and stores the instance for use by all connections
     * @return A DatabaseClient for accessing MarkLogic
     */
    private DatabaseClient initializeDatabaseClient() {

        String host = env.getProperty("marklogic.rest.host");
        Integer port = Integer.parseInt(env.getProperty("marklogic.rest.port"));
        String username = env.getProperty("marklogic.rest.user");
        String password = env.getProperty("marklogic.rest.password");

        DatabaseClientFactory.DigestAuthContext context = new DatabaseClientFactory.DigestAuthContext(username, password);
        DatabaseClient client = DatabaseClientFactory.newClient(host, port, context);

        return client;

    }

    /**
     * Get a new query manager
     * @return queryMgr -  a QueryManager object.
     */
    public QueryManager newQueryManager() { return client.newQueryManager(); }
}
