package uk.co.corbas.slides.db;

/**
 * Manage interactions with MarkLogic where Keywords are used.
 * Currently, this only manages searches for keywords themselves.
 */

import com.marklogic.client.io.ValuesHandle;
import com.marklogic.client.query.QueryManager;
import com.marklogic.client.query.ValuesDefinition;
import com.marklogic.client.query.CountedDistinctValue;


import org.springframework.stereotype.Component;

import uk.co.corbas.slides.model.Keyword;

import java.util.ArrayList;
import java.util.HashSet;


/**
 * KeywordService
 * Interface class to query MarkLogic for keywords
 */
@Component
public class KeywordService extends ServiceBase {

    public HashSet<Keyword> listKeywords() {

        HashSet keywords = new HashSet<Keyword>();

        QueryManager qMgr = client.newQueryManager();
        ValuesDefinition defs = qMgr.newValuesDefinition("keyword-list", "keyword-list");
        ValuesHandle results = qMgr.values(defs, new ValuesHandle());

        for (CountedDistinctValue result: results.getValues()) {
            keywords.add(new Keyword(result.get("xs:string", String.class)));
        }

        return keywords;
    }

}
