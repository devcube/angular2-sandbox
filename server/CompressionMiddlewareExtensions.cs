using Microsoft.AspNet.Builder;

namespace angular2sandbox
{
	public static class CompressionMiddlewareExtensions
	{
		public static IApplicationBuilder UseCompression(this IApplicationBuilder builder)
		{
			return builder.UseMiddleware<CompressionMiddleware>();
		}
	}
}
