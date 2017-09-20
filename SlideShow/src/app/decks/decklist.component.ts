import { Component, OnInit } from '@angular/core';
import { DecksService } from './decks.service';
import { Deck } from './deck.model';

@Component({
  templateUrl: './decklist.component.html',
  styleUrls: ['./decklist.component.css']
})
export class DeckListComponent implements OnInit {

  decks: Deck[];
  constructor(private deckService: DecksService) {}


  ngOnInit(): void {
    this.deckService.listDecks().subscribe(decks => this.setDecks(decks));
  }


  setDecks(decks: Deck[]) {
    this.decks = decks;
    /* console.log(JSON.stringify(decks)); */
  }
}
