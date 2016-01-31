import {Injectable} from 'angular2/core';
import {Http} from 'angular2/http';

@Injectable()
export class Title {
  constructor(public http: Http) {
  }

  getData() {
    console.log('Title#getData(): Get Data');
    return {
      value: 'devcube'
    };
  }

}
