import { FacetValue } from './facet-value.model';

/*
Simple class to represent a search facet retrieved from MarkLogic
Author: Nic Gibson
Date: 2017-09-02
*/

export class Facet {
    name: string;
    values: FacetValue[];
}
