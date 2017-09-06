import { Component } from '@angular/core';

import { PresentationsService } from './presentations/presentations.service';
import { DecksService } from './presentations/decks.service';


@Component({
  selector: 'slides-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css'],
  providers: [
      PresentationsService,
      DecksService
    ]
})
export class AppComponent {
  title = 'SlideShow: a slide management tool';
}
