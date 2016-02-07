using Microsoft.AspNet.Builder;
using Microsoft.AspNet.StaticFiles;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;

namespace angular2sandbox
{
    public class Startup
    {
        public void ConfigureServices(IServiceCollection services)
        {
            services.AddMvc();
            services.AddLogging();
        }

        public void Configure(IApplicationBuilder app, ILoggerFactory loggerFactory)
        {
            var logger = loggerFactory.CreateLogger<Startup>();
            var loggingConfiguration = new ConfigurationBuilder().AddJsonFile("logging.json").Build();
            loggerFactory.AddConsole(loggingConfiguration);
            loggingConfiguration.ReloadOnChanged("logging.json");

            var cre = new CompressedResourceExtender(logger);

            app.UseDefaultFiles();
            app.UseStaticFiles();
            // TODO: Testing different approaches to send gzipped static files, none of them is working yet
            // app.Use(typeof(GzipMiddleware));
            app.UseCompression();
            // app.UseStaticFiles(new StaticFileOptions
            //    {
            //        OnPrepareResponse = cre.ServePrecompressedFiles
            //    });

            app.UseMvc(routes =>
            {
                routes.MapRoute(name: "default", template: "{controller=Home}/{action=Index}/{id?}");
            });
        }
    }
}
