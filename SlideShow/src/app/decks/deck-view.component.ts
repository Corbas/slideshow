import { Input, Component, OnInit } from '@angular/core';
import { Deck } from './deck.model';

@Component({
  selector: 'slides-deck-detail',
  templateUrl: './deck-detail.component.html',
  styleUrls: ['./deck-detail.component.css']
})
export class DeckDetailComponent {

  @Input() deck: Deck;
  displaySlides: boolean;

  constructor() {
    // By default don't show slides
    this.displaySlides = false;

   }

}
