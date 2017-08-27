import { IPresentations } from '../shared/presentations.interface';
import { Component } from '@angular/core';

@Component({
  selector: 'slides-presentations',
  templateUrl: './presentations.component.html',
  styleUrls: ['./presentations.component.css']
})
export class PresentationsComponent {
  title = 'Presentations';
  private _presentation_data: IPresentations[] = [
    {
      'id': 'pres003A10',
      'title': 'XML Basics',
      'description': 'Introductory XML Course, explaining the concepts of mark-up, XML, well-formedness and valiity.',
      'author': 'Nic Gibson',
      'updated': '2018-08-22',
      'decks': [
        {
          'id': 'markup-intro',
          'keywords': [
            'Mark-up',
            'XML',
            'Entity'
          ],
          'level': 'Introductory',
          'author': 'Nic Gibson',
          'updated': '2017-08-25',
          'title': 'Mark-up'
        },   {
          'id': 'xml-syntax',
          'keywords': [
            'Syntax',
            'XML'
          ],
          'level': 'Introductory',
          'author': 'Nic Gibson',
          'updated': '2017-08-25',
          'title': 'XML Components'
        }]
    },
    {
      'id': 'pres003A11',
      'title': 'DTD Basics',
      'author': 'Nic Gibson',
      'description': 'A brief introduction to the simpler aspects of DTD authoring.',
      'updated': '2018-08-22',
      'decks': [ {
        'id': 'dtd-intro',
        'keywords': [
          'Schema',
          'DTD',
          'XML',
          'DTD'
        ],
        'level': 'Intermediate',
        'author': 'Nic Gibson',
        'updated': '2017-08-25',
        'title': 'DTDs'
      }
      ]
    }
  ];

}
