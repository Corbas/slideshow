import { HttpParameterCodec } from '@angular/common/http/public_api';
import { Injectable, Inject } from '@angular/core';
import { SlideProxy} from './slideproxy.model';
import { HttpClient, HttpErrorResponse, HttpHeaders, HttpParams} from '@angular/common/http';
import { Observable } from 'rxjs/Observable';
import 'rxjs/add/operator/catch';
import 'rxjs/add/operator/do';

import { AppConfig } from './../shared/app.config';


const listSlidesUrl = 'slides';

@Injectable()
export class SlidesService {

    private requestUrl: string;

    constructor(
        @Inject(AppConfig) private config: AppConfig,
        @Inject(HttpClient) private http: HttpClient) {
        this.requestUrl = this.config.restRoot + listSlidesUrl;
    }


    getSlide(deck: string, slide: string): Observable<string> {

        const headers: HttpHeaders = new HttpHeaders({'Accept': 'text/html'});
        const thisUrl: string = this.requestUrl + '/' + deck + '/' + slide;

        return this.http.get(thisUrl, { headers: headers, responseType: 'text' });
    }


}
