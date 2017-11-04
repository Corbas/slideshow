import { Injectable, Inject } from '@angular/core';
import { Deck } from './deck.model';
import { HttpClient, HttpErrorResponse, HttpHeaders} from '@angular/common/http';
import { ActivatedRoute, ParamMap } from '@angular/router';
import { Observable } from 'rxjs/Observable';
import 'rxjs/add/operator/catch';
import 'rxjs/add/operator/do';

import { AppConfig } from './../shared/app.config';

const decksPath: string = 'decks';


@Injectable()
export class DecksService {

    private requestUrl: string;
    private getRequestUrl: string;
    private headers: HttpHeaders;

  constructor(
        @Inject(AppConfig) private config: AppConfig,
        @Inject(HttpClient) private http: HttpClient) {
        this.requestUrl = this.config.restRoot + decksPath;
        this.headers = new HttpHeaders({'Accept': 'application/json'});
    }

    listDecks(): Observable<Deck[]> {
        return this.http.get<Deck[]>(this.requestUrl, { headers: this.headers});
    }

    getDeck(id: string): Observable<Deck> {

        const thisUrl: string = this.requestUrl + '/' + id;

        return this.http.get<Deck>(thisUrl, { headers: this.headers });
    }
}
