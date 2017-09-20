import { combineAll } from 'rxjs/operator/combineAll';
import { BrowserModule } from '@angular/platform-browser';
import {HttpClientModule} from '@angular/common/http';
import { NgModule } from '@angular/core';
import {NgbModule} from '@ng-bootstrap/ng-bootstrap';
import { RouterModule } from '@angular/router';
import { FormsModule } from '@angular/forms';


import { AppComponent } from './app.component';
import { PresentationsComponent } from './presentations/presentations.component';
import { DeckListComponent } from './decks/decklist.component';
import { KeywordListComponent } from './shared/keywordlist.component';
import { HomeComponent } from './home/home.component';
import { NotFoundComponent } from './errors/notfound.component';

import { AppConfig, SLIDESHOW_CONFIG } from './shared/app.config';
import { DeckDetailComponent } from './decks/deck-detail.component';
import { PresentationDetailsComponent } from './presentations/presentation-detail.component';
import { DeckLinksComponent } from './decks/deck-link.component';

@NgModule({
  declarations: [
    AppComponent,
    PresentationsComponent,
    DeckListComponent,
    KeywordListComponent,
    DeckDetailComponent,
    HomeComponent,
    NotFoundComponent,
    PresentationDetailsComponent,
    DeckLinksComponent
  ],
  imports: [
    BrowserModule,
    HttpClientModule,
    FormsModule,
    RouterModule.forRoot([
      { path: 'decks', component: DeckListComponent },
      { path: 'presentations', component: PresentationsComponent },
      { path: 'pdetails/:id', component: PresentationDetailsComponent },
      { path: 'home', component: HomeComponent },
      { path: '', redirectTo: 'home', pathMatch: 'full' },
      { path: '**',  component: NotFoundComponent }

    ]),
    NgbModule.forRoot(),
  ],
  providers: [
    { provide: AppConfig, useValue: SLIDESHOW_CONFIG }
  ],
  bootstrap: [AppComponent]
})
export class AppModule { }
