import { HttpParameterCodec } from '@angular/common/http/public_api';
import { Injectable, Inject } from '@angular/core';
import { Facet} from './facet.model';
import { HttpClient, HttpErrorResponse, HttpHeaders, HttpParams} from '@angular/common/http';
import { Observable } from 'rxjs/Observable';
import 'rxjs/add/operator/catch';
import 'rxjs/add/operator/do';

import { AppConfig } from './../shared/app.config';


const listFacetsUrl = 'facets';

@Injectable()
export class FacetsService {

    private requestUrl: string;
    private facets: Facet[];

    constructor(
        @Inject(AppConfig) private config: AppConfig,
        @Inject(HttpClient) private http: HttpClient) {
        this.requestUrl = this.config.restRoot + listFacetsUrl;
    }

    listFacets(): Observable<Facet[]> {
        const headers: HttpHeaders = new HttpHeaders({'Accept': 'application/json'});
        return this.http.get<Facet[]>(this.requestUrl, { headers: headers });
    }

}
