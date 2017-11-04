import { Component, EventEmitter, Input, OnInit, Output } from '@angular/core';



import { SlidesService } from './slides.service';
import { SlideProxy } from './slideproxy.model';

/*
Angular component used to display/edit/etc Slide detail
Author: Nic Gibson
Date: 2017-09-18
*/

@Component({
    selector: 'slides-slide-preview',
    templateUrl: './slide-preview.component.html',
    styleUrls: ['./slide-preview.component.css']
})
export class SlidePreviewComponent implements OnInit {

    @Input() slide: string;     /* Identifier for the slide */
    @Input() deck: string;
    slideHtml: string;


    constructor(private slideService: SlidesService) {

      }

    ngOnInit(): void {
        this.slideService.getSlide(this.deck, this.slide)
            .subscribe(html =>  this.setSlideHtml(html) );
    }

    setSlideHtml(html: string) {
        this.slideHtml = html;
    }
}
