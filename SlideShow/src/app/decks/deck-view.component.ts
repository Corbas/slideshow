import { Input, Component, OnInit } from '@angular/core';
import { Deck } from './deck.model';

@Component({
  selector: 'slides-deck-view',
  templateUrl: './deck-view.component.html',
  styleUrls: ['./deck-view.component.css']
})
export class DeckViewComponent {

  @Input() deck: Deck;
  @Input() displaySlides: boolean;

  constructor() {
    // By default don't show slides
    this.displaySlides = false;

   }

}
