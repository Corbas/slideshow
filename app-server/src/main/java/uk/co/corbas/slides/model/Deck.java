package uk.co.corbas.slides.model;

import java.util.HashSet;

/**
 * A POJO that is used to handle a reference to a deck stored in MarkLogic.
 * A presentation is served via a MarkLogic REST API transform but we need a way to reference it
 * in the app server.
 *
 */
public class Deck {



    private String id;
    private String uri;
    private HashSet<String> keywords;

    public String getId() { return id; }
    public void setId(String id) { this.id = id; }

    public String getUri() { return uri; }
    public void setUri(String uri) { this.uri = uri; }

    public HashSet<String> getKeywords() { return keywords; }
    public void setKeywords(HashSet<String> keywords) { this.keywords = new HashSet<String>(keywords); }

}
