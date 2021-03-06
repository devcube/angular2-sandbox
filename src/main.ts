import * as ngCore from 'angular2/core';
import * as browser from 'angular2/platform/browser';
import {ROUTER_PROVIDERS, LocationStrategy, HashLocationStrategy} from 'angular2/router';
import {HTTP_PROVIDERS} from 'angular2/http';

const ENV_PROVIDERS = [];

/*
 * App Environment Providers
 * providers that only live in certain environment
 */
if ('production' === process.env.ENV) {
  ngCore.enableProdMode();
  ENV_PROVIDERS.push(browser.ELEMENT_PROBE_PROVIDERS_PROD_MODE);
} else {
  ENV_PROVIDERS.push(browser.ELEMENT_PROBE_PROVIDERS);
}

/*
 * App Component
 * our top level component that holds all of our components
 */
import {App} from './app/app';

/*
 * Bootstrap our Angular app with a top level component `App` and inject
 * our Services and Providers into Angular's dependency injection
 */
export function main() {
  return browser.bootstrap(App, [
    ...ENV_PROVIDERS,
    ...HTTP_PROVIDERS,
    ...ROUTER_PROVIDERS,
    ngCore.provide(LocationStrategy, { useClass: HashLocationStrategy })
  ])
  .catch(err => console.error(err));
}

// For vendors for example jQuery, Lodash, angular2-jwt
// Import them in polyfills.ts to bundle all polyfills and vendors in the same chunk
// This helps us keep the app bundle as small as possible, thus maximizing cache effectiveness

// Also see custom_typings.d.ts as you also need to do `typings install x` where `x` is your module

/*
 * Hot Module Reload
 * experimental version by @gdi2290
 */
if ('development' === process.env.ENV) {
  // activate hot module reload
  if ('hot' in module) {
    if (document.readyState === 'complete') {
      main();
    } else {
      document.addEventListener('DOMContentLoaded', main);
    }
    module.hot.accept();
  }

} else {
  // bootstrap after document is ready
  document.addEventListener('DOMContentLoaded', main);
}
