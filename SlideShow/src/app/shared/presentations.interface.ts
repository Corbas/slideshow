
import { IDeck } from './decks.interface';

export interface IPresentations {
    id: string;
    title: string;
    description: string;
    author: string;
    updated: string;
    decks: IDeck[];
}
