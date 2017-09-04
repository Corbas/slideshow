import { Injectable, Inject } from '@angular/core';
import { Deck } from './deck.model';
import { HttpClient, HttpErrorResponse } from '@angular/common/http';
import { Observable } from 'rxjs/Observable';
import 'rxjs/add/operator/catch';
import 'rxjs/add/operator/do';

import {AppConfig } from './../shared/app.config-t';
import {  SLIDESHOW_CONFIG } from './../shared/app.config';

const listDecksUrl: string = 'list-decks';

@Injectable()
export class DecksService {

    private requestUrl: string;

    constructor (private http: HttpClient, @Inject(SLIDESHOW_CONFIG) config: AppConfig) {
        this.requestUrl = config.restRoot + listDecksUrl;
    }

    listDecks(): Observable<Deck[]> {
        return this.http.get<Deck[]>(this.requestUrl);
    }

}
