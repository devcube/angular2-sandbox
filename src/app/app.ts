import {Component} from 'angular2/core';
import {RouteConfig, Router, ROUTER_DIRECTIVES} from 'angular2/router';
import {FORM_PROVIDERS} from 'angular2/common';

import {RouterActive} from './directives/router-active';
import {Home} from './home/home';

@Component({
  selector: 'app',
  providers: [ ...FORM_PROVIDERS ],
  directives: [ ...ROUTER_DIRECTIVES, RouterActive ],
  pipes: [],
  styles: [ require('./app.css') ],
  template: require('./app.html')
})

@RouteConfig([
  { path: '/home', component: Home, name: 'Home' },
  // Async load a component using Webpack's require with es6-promise-loader
  { path: '/about', loader: () => require('./about/about')('About'), name: 'About' },
  { path: '/**', redirectTo: ['Home'] }
])

export class App {
  angularclassLogo = 'assets/img/angularclass-avatar.png';
  name = 'Angular2 Sandbox';
  environment = process.env.ENV;
}
