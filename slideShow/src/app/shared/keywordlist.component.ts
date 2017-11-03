import { Component, Input } from '@angular/core';

@Component({
  selector: 'slides-kwlist',
  templateUrl: './keywordlist.component.html',
  styleUrls: ['./keywordlist.component.css']
})

export class KeywordListComponent {

    @Input() keywords: string[];

}
