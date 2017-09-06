import { Injectable, Inject } from '@angular/core';
import { Deck } from './deck.model';
import { HttpClient, HttpErrorResponse } from '@angular/common/http';
import { Observable } from 'rxjs/Observable';
import 'rxjs/add/operator/catch';
import 'rxjs/add/operator/do';

import { AppConfig, APP_CONFIG, SLIDESHOW_CONFIG } from './../shared/app.config';

const listDecksUrl: string = 'list-decks';

@Injectable()
export class DecksService {

    private requestUrl: string;

    constructor (@Inject(APP_CONFIG) private config: AppConfig, private http: HttpClient) {
        this.requestUrl = this.config.restRoot + listDecksUrl;
    }

    listDecks(): Observable<Deck[]> {
        return this.http.get<Deck[]>(this.requestUrl);
    }

}
