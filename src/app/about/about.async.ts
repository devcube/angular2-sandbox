import {Component} from 'angular2/core';
import {Http} from 'angular2/http';

/*
 * We're loading this component asynchronously
 * We are using some magic with es6-promise-loader that will wrap the module with a Promise
 * see https://github.com/gdi2290/es6-promise-loader for more info
 */

console.log('`About` component loaded asynchronously');

@Component({
  selector: 'about',
  template: require('./about.html')
})
export class About {
  readmeContents: string;

  constructor(public http: Http) {
    var marked = require('marked');
    this.http.get('https://raw.githubusercontent.com/devcube/angular2-sandbox/master/README.md')
             .map(res => res.text()).subscribe(
                  data => this.readmeContents = marked(data),
                  err => console.log('Error occurred while fetching README.md: ' + err));
  }

  ngOnInit() {
  }

}
