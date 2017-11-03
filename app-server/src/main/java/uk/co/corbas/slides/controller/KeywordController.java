package uk.co.corbas.slides.controller;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import uk.co.corbas.slides.db.KeywordService;
import uk.co.corbas.slides.model.Keyword;


import java.util.HashSet;

@RestController
public class KeywordController {

    @Autowired
    KeywordService kws;

    @RequestMapping("/keywords")
    public HashSet<Keyword> list() {
        return kws.listKeywords();
    }
}
