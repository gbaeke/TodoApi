var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

var port = Environment.GetEnvironmentVariable("PORT") ?? "8080";


app.MapGet("/", () => "Hello World!");

app.MapGet("/healthz", () => "OK");

app.MapGet("/readyz", () => "OK");

app.Run($"http://*:{port}");
