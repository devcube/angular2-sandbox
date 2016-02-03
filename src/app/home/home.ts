import {Component} from 'angular2/core';
import {FORM_DIRECTIVES} from 'angular2/common';

import {Title} from './services/title';
import {XLarge} from './directives/x-large';

@Component({
  selector: 'home',
  providers: [ Title ],
  directives: [
    ...FORM_DIRECTIVES,
    XLarge
  ],
  pipes: [ ],
  styles: [ require('./home.css') ],
  template: require('./home.html')
})

export class Home {
  data = { value: '' };

  constructor(public title: Title) {
  }

  swalTest(event) {
    swal('Good job!', 'You clicked the button!', 'success');
  }

  ngOnInit() {
    console.log('Hello `Home` component');
    // this.title.getData().subscribe(data => this.data = data);
  }
}
