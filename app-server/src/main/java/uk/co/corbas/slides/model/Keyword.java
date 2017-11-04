package uk.co.corbas.slides.model;


/**
 * A POJO is used to wrap a keyword returned from MarkLogic
 *
 */
public class Keyword {

    private String value;

    public Keyword(String value) {setValue(value);}

    public String getValue() {
        return value;
    }

    public void setValue(String value) {
        this.value = value;
    }
}
