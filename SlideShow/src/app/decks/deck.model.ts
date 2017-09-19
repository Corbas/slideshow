import { SlideProxy } from '../slides/slideproxy.model';

export class Deck {
    id: string;
    title: string;
    level: string;
    author: string;
    updated: string;
    keywords: string[];
    slides: SlideProxy[];
}
