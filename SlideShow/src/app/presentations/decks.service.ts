import { Injectable, Inject } from '@angular/core';
import { Deck } from './deck.model';
import { HttpClient, HttpErrorResponse } from '@angular/common/http';
import { Observable } from 'rxjs/Observable';
import 'rxjs/add/operator/catch';
import 'rxjs/add/operator/do';

import { AppConfig } from './../shared/app.config';

const listDecksUrl: string = 'list-decks/json';

@Injectable()
export class DecksService {

    private requestUrl: string;

    constructor(@Inject(AppConfig) private config: AppConfig, @Inject(HttpClient) private http: HttpClient) {
        this.requestUrl = this.config.restRoot + listDecksUrl;
    }

    listDecks(): Observable<Deck[]> {
        return this.http.get<Deck[]>(this.requestUrl);
    }

}
