import { Component } from '@angular/core';
import {HttpClient} from '@angular/common/http';
import {AppConfig } from './shared/app.config';
import { PresentationsService } from './presentations/presentations.service';
import { DecksService } from './decks/decks.service';
import { SlidesService } from './slides/slides.service';


@Component({
  selector: 'slides-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css'],
  providers: [
     PresentationsService,
     DecksService,
     SlidesService
    ]
})
export class AppComponent {
  title = 'SlideShow: a slide management tool';
}
