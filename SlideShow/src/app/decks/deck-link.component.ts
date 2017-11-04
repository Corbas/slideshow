import { Component, Input } from '@angular/core';
import { Deck } from './deck.model';

@Component({
  selector: 'slides-deck-link-list',
  templateUrl: './deck-link.component.html',
  styleUrls: ['./deck-link.component.css']
})

export class DeckLinksComponent {

    @Input() decks: Deck[];

}
