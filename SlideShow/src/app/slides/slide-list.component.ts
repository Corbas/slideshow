import { Component, Input } from '@angular/core';
import { SlideProxy } from './slideproxy.model';

@Component({
  selector: 'slides-slide-list',
  templateUrl: './slide-list.component.html'
})
export class SlideListComponent {

    @Input() slides: SlideProxy[];
    @Input() deck: string;

}
