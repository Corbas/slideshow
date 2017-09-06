import { Component, OnInit } from '@angular/core';
import { DecksService } from './decks.service';
import { Deck } from './deck.model';

@Component({
  selector: 'slides-decks',
  templateUrl: './decklist.component.html',
  styleUrls: ['./decklist.component.css']
})
export class DeckListComponent implements OnInit {

  decks: Deck[];
  constructor(private deckService: DecksService) {}


  ngOnInit(): void {
    this.deckService.listDecks().subscribe(decks => this.decks = decks);
  }

}
