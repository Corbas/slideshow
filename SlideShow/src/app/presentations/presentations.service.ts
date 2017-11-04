import { HttpParameterCodec } from '@angular/common/http/public_api';
import { Injectable, Inject } from '@angular/core';
import { Presentation} from './presentation.model';
import { HttpClient, HttpErrorResponse, HttpHeaders, HttpParams} from '@angular/common/http';
import { Observable } from 'rxjs/Observable';
import 'rxjs/add/operator/catch';
import 'rxjs/add/operator/do';

import { AppConfig } from './../shared/app.config';


const listPresentationsUrl = 'presentations';

@Injectable()
export class PresentationsService {

    private requestUrl: string;

    constructor(
        @Inject(AppConfig) private config: AppConfig,
        @Inject(HttpClient) private http: HttpClient) {
        this.requestUrl = this.config.restRoot + listPresentationsUrl;
    }

    listPresentations(): Observable<Presentation[]> {
        const headers: HttpHeaders = new HttpHeaders({'Accept': 'application/json'});
        return this.http.get<Presentation[]>(this.requestUrl, { headers: headers });
    }

    getPresentation(id: string): Observable<Presentation> {

        const headers: HttpHeaders = new HttpHeaders({'Accept': 'application/json'});
        const thisUrl: string = this.requestUrl + '/' + id;

        return this.http.get<Presentation>(thisUrl, { headers: headers });
    }

    savePresentation(presentation: Presentation): Observable<Presentation> {
        const headers: HttpHeaders = new HttpHeaders({'Accept': 'application/json'});
        headers.append('Content-Type', 'application/json');
        const thisUrl: string = this.requestUrl + '/' + presentation.id;

        return this.http.post<Presentation>(thisUrl, JSON.stringify(presentation), { headers: headers });

    }
}
