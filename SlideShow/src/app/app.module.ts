import { BrowserModule } from '@angular/platform-browser';
import {HttpClientModule, HTTP_INTERCEPTORS} from '@angular/common/http';
import { NgModule } from '@angular/core';
import {NgbModule} from '@ng-bootstrap/ng-bootstrap';

import { AppComponent } from './app.component';
import { PresentationsComponent } from './presentations/presentations.component';
import { DeckListComponent } from './presentations/decklist.component';
import { BasicAuthInterceptor } from './shared/auth.interceptor';


import { AppConfig, APP_CONFIG, SLIDESHOW_CONFIG } from './shared/app.config';

@NgModule({
  declarations: [
    AppComponent,
    PresentationsComponent,
    DeckListComponent
  ],
  imports: [
    BrowserModule,
    HttpClientModule,
    NgbModule.forRoot(),
  ],
  providers: [
    { provide: APP_CONFIG, useValue: SLIDESHOW_CONFIG },
    {
      provide: HTTP_INTERCEPTORS,
      useClass: BasicAuthInterceptor,
      multi: true
    }
  ],
  bootstrap: [AppComponent]
})
export class AppModule { }
