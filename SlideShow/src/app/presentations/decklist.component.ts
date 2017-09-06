import { Component, OnInit } from '@angular/core';
import { DecksService } from './decks.service';
import { Deck } from './deck.model';

@Component({
  selector: 'slides-decks',
  templateUrl: './decklist.component.html',
  styleUrls: ['./decklist.component.css']
})
export class DeckListComponent implements OnInit {

  presentations: Deck[];
  constructor(private deckService: DecksService) {}


  ngOnInit(): void {
  }

}
