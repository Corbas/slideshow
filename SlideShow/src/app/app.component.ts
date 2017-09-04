import { Component } from '@angular/core';
import { HTTP_INTERCEPTORS } from '@angular/common/http';
import { PresentationsService } from './presentations/presentations.service';
import { DecksService } from './presentations/decks.service';
import { AppConfig } from './shared/app.config-t';
import { APP_CONFIG, SLIDESHOW_CONFIG } from './shared/app.config';
import { BasicAuthInterceptor } from './shared/auth.interceptor';

@Component({
  selector: 'slides-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css'],
  providers: [
      PresentationsService,
      DecksService,
      { provide: APP_CONFIG, useValue: SLIDESHOW_CONFIG },
      {
        provide: HTTP_INTERCEPTORS,
        useClass: BasicAuthInterceptor,
        multi: true
      }
    ]
})
export class AppComponent {
  title = 'SlideShow: a slide management tool';
}
