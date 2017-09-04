import { SlideProxy } from './slideproxy.model';

export class Deck {
    id: string;
    keyword: string[];
    level: string;
    author: string;
    updated: string;
    title: string;
    slide: SlideProxy[];
}
