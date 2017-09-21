import { DecksService } from '../decks/decks.service';
import { SlideProxy } from '../slides/slideproxy.model';
import { Component, EventEmitter, Input, OnInit, Output } from '@angular/core';
import { ActivatedRoute, ParamMap } from '@angular/router';

import 'rxjs/add/operator/switchMap';


import { PresentationsService } from './presentations.service';
import { Presentation } from './presentation.model';

/*
Angular component used to display/edit/etc presentation detail
Author: Nic Gibson
Date: 2017-09-12
*/

@Component({
    templateUrl: './presentation-player.component.html',
    styleUrls: ['./presentation-player.component.css']
})
export class PresentationPlayerComponent implements OnInit {

    presentation: Presentation;
    slides: Array<SlideProxy> = [];

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

        /* Iterate over the arrays, merging decks */
        // tslint:disable-next-line:prefer-const
        for (let deck of this.presentation.decks) {
            console.log('Deck size: ' + deck.slides.length);
            if (deck.slides.length === 0) {
                this.slides = deck.slides;
            } else {
                this.slides = this.slides.concat(deck.slides);
            }
        }
    }
}
