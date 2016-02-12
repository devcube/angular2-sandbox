Questions
====
## Question about gzip compression on server side
I'm still struggling to send compressed static resources (.js and .css) from Kestrel. I have precompressed files: i.e. both styles.css and styles.css.gz but I'm ok to also compress the files on the server if that is somehow easier. I tried following this tutorial: http://www.codeproject.com/Articles/1042980/Enabling-GZip-Compression-in-ASP-NET but it does not seem to work at all.
This issue (aspnet/StaticFiles#7) is also related but I tried modifying the code and implementing it, still no go: https://gist.github.com/devcube/cec0de7db496c8024dfc
Tips? Links?

### Answer
* @davidfowl
> Kestrel will never support it either. Think of kestrel as a really dumb byte pump that handles http.
> nginx does not support it either, the following link is a module:
> https://coderwall.com/p/2dx_mq/pre-compress-css-js-resources-for-nginx
* http://stackoverflow.com/questions/27836176/asp-net-vnext-enable-compression-to-iis-8-on-azure/28759054#28759054
* Azure Web Apps does gzip compression out of the box
  http://stackoverflow.com/questions/34006236/azure-web-app-not-using-gzip-compression

## Question about webpack production bundles
https://github.com/AngularClass/angular2-webpack-starter/issues/307

### Answer

Links
====
[Markdown-Cheatsheet](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet)
