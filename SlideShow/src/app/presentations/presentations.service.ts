import { Injectable, Inject } from '@angular/core';
import { Presentation} from './presentation.model';
import { HttpClient, HttpErrorResponse } from '@angular/common/http';
import { AppConfig} from './../shared/app.config';

const listPresentationsUrl = 'list-presentations';

@Injectable()
export class PresentationsService {

    private requestUrl: string;
    private _presentation_data: Presentation[] = [
    {
        'id': 'pres003A10',
        'title': 'XML Basics',
        'description': 'Introductory XML Course, explaining the concepts of mark-up, XML, well-formedness and valiity.',
        'author': 'Nic Gibson',
        'updated': '2018-08-22',
        'decks': [{
            'id': 'markup-intro',
            'keywords': [],
            'level': '',
            'author': '',
            'updated': '',
            'title': 'Mark-up',
            'slides': []
        },   {
            'id': 'xml-syntax',
            'keywords': [],
            'level': '',
            'author': '',
            'updated': '',
            'title': 'XML Components',
            'slides': []
        }]},
        {
            'id': 'pres003A11',
            'title': 'DTD Basics',
            'author': 'Nic Gibson',
            'description': 'A brief introduction to the simpler aspects of DTD authoring.',
            'updated': '2018-08-22',
            'decks': [ {
            'id': 'dtd-intro',
            'keywords': [],
            'level': '',
            'author': '',
            'updated': '',
            'title': 'DTDs',
            'slides': []
            }]
    }];

    constructor(@Inject(AppConfig) private config: AppConfig, @Inject(HttpClient) private http: HttpClient) {
      this.requestUrl = this.config.restRoot + listPresentationsUrl;
    }


    getPresentations(): Presentation[] {
        return this._presentation_data;
    }

}
