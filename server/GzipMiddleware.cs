using Microsoft.AspNet.Http;
using System;
using System.Collections.Generic;
using System.IO.Compression;
using System.Threading.Tasks;

namespace angular2sandbox
{
    using AppFunc = Func<IDictionary<string, object>, Task>;

    public class GzipMiddleware
    {
        private readonly AppFunc _next;

        public GzipMiddleware(AppFunc next)
        {
            _next = next;
        }

        public async Task Invoke(IDictionary<string, object> environment, HttpContext httpContext)
        {
            await _next(environment);

            var response = httpContext.Response;
            var encoding = response.Headers["Content-Encoding"];

            if (String.Equals(encoding, "gzip", StringComparison.OrdinalIgnoreCase))
            {
                response.Body = new GZipStream(response.Body, CompressionMode.Decompress);
            }
        }
    }
}
