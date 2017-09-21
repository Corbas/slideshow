import { DeckDetailComponent } from './decks/deck-detail.component';
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
import { DeckViewComponent } from './decks/deck-view.component';
import { PresentationDetailComponent } from './presentations/presentation-detail.component';
import { PresentationPlayerComponent } from './presentations/presentation-player.component';
import { DeckLinksComponent } from './decks/deck-link.component';
import { SlideListComponent } from './slides/slide-list.component';
import { SlidePreviewComponent } from './slides/slide-preview.component';

@NgModule({
  declarations: [
    AppComponent,
    PresentationsComponent,
    DeckListComponent,
    KeywordListComponent,
    DeckViewComponent,
    HomeComponent,
    NotFoundComponent,
    PresentationDetailComponent,
    DeckLinksComponent,
    DeckDetailComponent,
    SlideListComponent,
    SlidePreviewComponent,
    PresentationPlayerComponent
  ],
  imports: [
    BrowserModule,
    HttpClientModule,
    FormsModule,
    RouterModule.forRoot([
      { path: 'decks', component: DeckListComponent },
      { path: 'presentations', component: PresentationsComponent },
      { path: 'pdetails/:id', component: PresentationDetailComponent },
      { path: 'ddetails/:id', component: DeckDetailComponent},
      { path: 'play/:id', component: PresentationPlayerComponent },
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
