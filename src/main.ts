import {provide, enableProdMode} from 'angular2/core';
import {bootstrap, ELEMENT_PROBE_PROVIDERS} from 'angular2/platform/browser';
import {ROUTER_PROVIDERS, LocationStrategy, HashLocationStrategy} from 'angular2/router';
import {HTTP_PROVIDERS} from 'angular2/http';

const ENV_PROVIDERS = [];

if ('production' === process.env.ENV) {
  enableProdMode();
} else {
   ENV_PROVIDERS.push(ELEMENT_PROBE_PROVIDERS);
}

import {App} from './app/app';

document.addEventListener('DOMContentLoaded', function main() {
  bootstrap(App, [
    ...ENV_PROVIDERS,
    ...HTTP_PROVIDERS,
    ...ROUTER_PROVIDERS,
    provide(LocationStrategy, { useClass: HashLocationStrategy })
  ])
  .catch(err => console.error(err));

});

// For vendors for example jQuery, Lodash, angular2-jwt
// Import them in polyfills.ts to bundle all polyfills and vendors in the same chunk
// This helps us keep the app bundle as small as possible, thus maximizing cache effectiveness

// Also see custom_typings.d.ts as you also need to do `typings install x` where `x` is your module
