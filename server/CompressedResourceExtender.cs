using Microsoft.AspNet.StaticFiles;
using System;
using System.IO;
using System.Net;
using Microsoft.Net.Http.Headers;
using Microsoft.Extensions.Logging;

namespace angular2sandbox
{
  public class CompressedResourceExtender
  {
    private readonly ILogger _logger;

    public CompressedResourceExtender(ILogger logger)
    {
        _logger = logger;
    }

    public void ServePrecompressedFiles(StaticFileResponseContext context)
    {
      var file = context.File;
      var request = context.Context.Request;
      var response = context.Context.Response;

      _logger.LogInformation($"{DateTime.Now.ToShortTimeString()}: Handling file: {file.Name}");

      var requestPath2 = request.Path.Value;
      if (file.Name.Contains("styles.css"))
      {
      _logger.LogInformation($"{DateTime.Now.ToShortTimeString()}: Sending .gz version: {file.Name}");
        response.Headers[HeaderNames.Location] = requestPath2 + ".gz";
        context.Context.Response.Headers.Add("Content-Encoding", "gzip");
      }

      return;

      if (file.Name.EndsWith(".gz"))
      {
        // response.Headers[HeaderNames.ContentEncoding] = "gzip";
        return;
      }

      var requestPath = request.Path.Value;
      var filePath = file.PhysicalPath;

      var acceptEncoding = (string)request.Headers[HeaderNames.AcceptEncoding];
      if (acceptEncoding.IndexOf("gzip", StringComparison.OrdinalIgnoreCase) != -1)
      {
        if (File.Exists(filePath + ".gz"))
        {
          _logger.LogInformation($"{DateTime.Now.ToShortTimeString()}: Found gzip version for: {file.Name}");
          response.StatusCode = (int)HttpStatusCode.MovedPermanently;
          response.Headers[HeaderNames.Location] = requestPath + ".gz";
        }
      }
    }
  }
}
