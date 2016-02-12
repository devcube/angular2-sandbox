// Polyfills
import 'es6-shim';
// (these modules are what are in 'angular2/bundles/angular2-polyfills' so don't use that here)
import 'es6-promise';

if ('production' === process.env.ENV) {

  // Zone.js
  require('zone.js/dist/zone-microtask.min');

  // RxJS
  // In production manually include the operators you use
  require('rxjs/add/operator/map');

} else {
  // Reflect Polyfill
  require('es7-reflect-metadata/src/global/browser');
  // In production Reflect with es7-reflect-metadata/reflect-metadata is added

  // by webpack.prod.config ProvidePlugin
  Error['stackTraceLimit'] = Infinity;
  require('zone.js/dist/zone-microtask');
  require('zone.js/dist/long-stack-trace-zone');

  // RxJS
  // In development we are including every operator

  // Observable Operators
  require('rxjs/add/operator/map');
}

// For vendors for example jQuery, Lodash, angular2-jwt
// Import them in polyfills.ts to bundle all polyfills and vendors in the same chunk
// This helps us keep the app bundle as small as possible, thus maximizing cache effectiveness

import 'bootstrap/dist/css/bootstrap.css';
import 'bootstrap/dist/js/bootstrap.js';

import 'jquery/dist/jquery.js';

import 'sweetalert/lib/sweetalert.js';
import 'sweetalert/dist/sweetalert.css';

import 'marked/lib/marked.js';

import './assets/css/global.css';
