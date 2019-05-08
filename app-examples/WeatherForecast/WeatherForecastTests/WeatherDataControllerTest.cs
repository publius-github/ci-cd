using Microsoft.VisualStudio.TestTools.UnitTesting;
using WeatherForecast.Controllers;

namespace WeatherForecastTests
{
    [TestClass]
    public class WeatherDataControllerTest
    {
        [TestMethod]
        public void GetDataTest()
        {
            Assert.IsNotNull(new WeatherDataController().WeatherForecasts());
        }

        [TestMethod]
        public void TemperatureConversionTest()
        {
            WeatherDataController.WeatherForecast forecastNegative = new WeatherDataController.WeatherForecast()
            {
                TemperatureC = -1
            };

            Assert.AreEqual(31, forecastNegative.TemperatureF);

            WeatherDataController.WeatherForecast forecastPositive = new WeatherDataController.WeatherForecast()
            {
                TemperatureC = 1
            };

            Assert.AreEqual(33, forecastPositive.TemperatureF);
        }
    }
}
