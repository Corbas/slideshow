import { Component, EventEmitter, Input, OnInit, Output } from '@angular/core';
import { ActivatedRoute, ParamMap } from '@angular/router';

import 'rxjs/add/operator/switchMap';


import { PresentationsService } from './presentations.service';
import { Presentation } from './presentation.model';

/*
Angular component used to display/edit/etc presentation detail
Author: Nic Gibson
Date: 2017-09-18
*/

@Component({
    templateUrl: './presentation-detail.component.html',
    styleUrls: ['./presentation-detail.component.css']
})
export class PresentationDetailsComponent implements OnInit {

    @Input() presentation: Presentation;

    constructor(
        private presentationService: PresentationsService,
        private route: ActivatedRoute) {

      }

    ngOnInit(): void {
        this.route.paramMap
            .switchMap((params: ParamMap) => this.presentationService.getPresentation(params.get('id')))
            .subscribe(presentation =>  this.setPresentation(presentation) );
    }

    setPresentation(presentation: Presentation) {
        this.presentation = presentation;
        console.log(JSON.stringify(presentation));
    }
}


