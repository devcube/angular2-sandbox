using Microsoft.AspNet.Builder;
using Microsoft.AspNet.Http;
using System;
using System.IO;
using System.IO.Compression;
using System.Threading.Tasks;
using Microsoft.Extensions.Logging;

namespace angular2sandbox
{
	public class CompressionMiddleware
	{
		private readonly RequestDelegate _next;
    private ILogger<CompressionMiddleware> _logger { get; set; }

    public CompressionMiddleware(RequestDelegate next, ILogger<CompressionMiddleware> logger)
		{
			_next = next;
      _logger = logger;
		}

		public async Task Invoke(HttpContext httpContext)
		{
      var filename = httpContext.Request.Path;
      _logger.LogInformation($"{DateTime.Now.ToShortTimeString()}: Invoking middleware. Location: {filename}");
			var acceptEncoding = httpContext.Request.Headers["Accept-Encoding"];
			if (acceptEncoding.ToString().IndexOf("gzip", StringComparison.CurrentCultureIgnoreCase) >= 0)
			{
				using (var memoryStream = new MemoryStream())
				{
					var stream = httpContext.Response.Body;
					httpContext.Response.Body = memoryStream;
					await _next(httpContext);
					using (var compressedStream = new GZipStream(stream, CompressionLevel.Optimal))
					{
						httpContext.Response.Headers.Add("Content-Encoding", new string[] { "gzip" });
						memoryStream.Seek(0, SeekOrigin.Begin);
						await memoryStream.CopyToAsync(compressedStream);
					}
				}
			}
		}
	}
}
