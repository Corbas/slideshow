
import { Deck } from './deck.model';

export class Presentation {
    id: string;
    title: string;
    description: string;
    author: string;
    updated: string;
    decks: Deck[];
}
