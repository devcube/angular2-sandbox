using Microsoft.AspNet.Mvc;
using System;
using System.Text.RegularExpressions;
using angular2sandbox.Models;

namespace angular2sandbox.Controllers
{
  public class TestController : Controller
  {
    public string Test()
    {
      return "TestController is working!";
    }

    [HttpPost]
    public string GenerateGreeting([FromBody]TestModel testModel)
    {
      if (string.IsNullOrWhiteSpace(testModel.Name))
        return "Name is empty";

      return testModel.IsDeveloper ? $"Hello {testModel.Name}, happy coding!" : $"Hello {testModel.Name}, what do you do?";
    }
  }
}
