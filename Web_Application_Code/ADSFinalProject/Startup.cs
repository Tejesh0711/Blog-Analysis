using Microsoft.Owin;
using Owin;

[assembly: OwinStartupAttribute(typeof(ADSFinalProject.Startup))]
namespace ADSFinalProject
{
    public partial class Startup {
        public void Configuration(IAppBuilder app) {
            ConfigureAuth(app);
        }
    }
}
