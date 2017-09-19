
import { Deck } from '../decks/deck.model';

/*
Simple class to represent a presentation retrieved from MarkLogic
Author: Nic Gibson
Date: 2017-09-02
*/

export class Presentation {
    id: string;
    title: string;
    description: string;
    author: string;
    updated: string;
    decks: Deck[];
}
