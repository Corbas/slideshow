import { Injectable } from '@angular/core';
import { Presentation} from './presentation.model';

const apiBaseUrl = 'http://localhost:8070';

export class PresentationsService {

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
            'title': 'Mark-up'
        },   {
            'id': 'xml-syntax',
            'keywords': [],
            'level': '',
            'author': '',
            'updated': '',
            'title': 'XML Components'
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
            'title': 'DTDs'
            }]
    }];


    getPresentations(): Presentation[] {
        return this._presentation_data;
    }

}
