import { combineAll } from 'rxjs/operator/combineAll';
import { BrowserModule } from '@angular/platform-browser';
import {HttpClientModule} from '@angular/common/http';
import { NgModule } from '@angular/core';
import {NgbModule} from '@ng-bootstrap/ng-bootstrap';
import { RouterModule } from '@angular/router';

import { AppComponent } from './app.component';
import { PresentationsComponent } from './presentations/presentations.component';
import { DeckListComponent } from './presentations/decklist.component';
import { KeywordListComponent } from './shared/keywordlist.component';
import { HomeComponent } from './home/home.component';

import { AppConfig, SLIDESHOW_CONFIG } from './shared/app.config';
import { DeckDetailComponent } from './presentations/deck-detail.component';

@NgModule({
  declarations: [
    AppComponent,
    PresentationsComponent,
    DeckListComponent,
    KeywordListComponent,
    DeckDetailComponent,
    HomeComponent
  ],
  imports: [
    BrowserModule,
    HttpClientModule,
    RouterModule.forRoot([
      { path:  'list-decks', component: DeckListComponent },
      { path: 'home', component: HomeComponent},
      { path: '', redirectTo: 'home', pathMatch: 'full'}

    ]),
    NgbModule.forRoot(),
  ],
  providers: [
    { provide: AppConfig, useValue: SLIDESHOW_CONFIG }
  ],
  bootstrap: [AppComponent]
})
export class AppModule { }
