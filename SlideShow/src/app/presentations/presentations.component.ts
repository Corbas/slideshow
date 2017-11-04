import { Component, OnInit } from '@angular/core';
import { PresentationsService} from './presentations.service';
import { Presentation } from './presentation.model';

@Component({
  selector: 'slides-presentations',
  templateUrl: './presentations.component.html',
  styleUrls: ['./presentations.component.css']
})
export class PresentationsComponent implements OnInit {

  presentations: Presentation[];
  constructor(private presentationService: PresentationsService) {}

  ngOnInit(): void {
    this.presentationService.listPresentations().subscribe(presentations => this.presentations = presentations);
  }

}
