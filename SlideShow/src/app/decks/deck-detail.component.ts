import { Input, Component, OnInit } from '@angular/core';
import { ActivatedRoute, ParamMap } from '@angular/router';

import 'rxjs/add/operator/switchMap';

import { Deck } from './deck.model';
import { DecksService } from './decks.service';

@Component({
  templateUrl: './deck-detail.component.html'
})
export class DeckDetailComponent implements OnInit {

  @Input() deck: Deck;

    constructor(
        private deckService: DecksService,
        private route: ActivatedRoute) {

    }

    ngOnInit(): void {
        this.route.paramMap
            .switchMap((params: ParamMap) => this.deckService.getDeck(params.get('id')))
            .subscribe(deck =>  this.setDeck(deck) );
    }

    setDeck(deck: Deck) {
        this.deck = deck;
       /* console.log(JSON.stringify(deck)); */
    }

}
